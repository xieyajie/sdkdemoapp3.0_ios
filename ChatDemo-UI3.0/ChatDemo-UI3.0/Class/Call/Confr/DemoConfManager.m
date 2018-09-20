//
//  DemoConfManager.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 23/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import "DemoConfManager.h"

#if DEMO_CALL == 1

#import <Hyphenate/Hyphenate.h>

#import "DemoCallManager.h"
#import "MainViewController.h"
#import "EMConfUserSelectionViewController.h"

#import "ConfInviteUsersViewController.h"
#import "MeetingViewController.h"

static DemoConfManager *confManager = nil;

@interface DemoConfManager()<EMConferenceManagerDelegate, EMChatManagerDelegate>

@end

#endif

@implementation DemoConfManager

#if DEMO_CALL == 1

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initManager];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        confManager = [[DemoConfManager alloc] init];
    });
    
    return confManager;
}

- (void)dealloc
{
    [[EMClient sharedClient].conferenceManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private

- (void)_initManager
{
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].conferenceManager addDelegate:self delegateQueue:nil];
}

#pragma mark - EMConferenceManagerDelegate

- (void)userDidRecvInvite:(NSString *)aConfId
                 password:(NSString *)aPassword
                      ext:(NSString *)aExt
{
//    if ([DemoCallManager sharedManager].isCalling) {
//        return;
//    }
//    
//    NSData *jsonData = [aExt dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    NSString *creater = [dic objectForKey:@"creater"];
//    ConferenceViewController *confController = [[ConferenceViewController alloc] initWithConferenceId:aConfId creater:creater password:aPassword];
//    [self.mainController.navigationController pushViewController:confController animated:NO];
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        NSString *conferenceId = [message.ext objectForKey:@"em_conference_id"];
        if ([conferenceId length] == 0) {
            continue;
        }
        
        NSString *op = [message.ext objectForKey:@"em_conference_op"];
        if ([op isEqualToString:@"request_tobe_speaker"] || [op isEqualToString:@"request_tobe_audience"]) {
            UIViewController *controller = self.mainController.navigationController.topViewController;
            if ([controller isKindOfClass:[LiveViewController class]]) {
                LiveViewController *liveController = (LiveViewController *)controller;
                [liveController handleMessage:message];
            }
        }
    }
}

#pragma mark - conference

- (ConferenceViewController *)pushConferenceControllerWithType:(EMConferenceType)aType
{
    [[DemoCallManager sharedManager] setIsCalling:YES];
    
    ConferenceViewController *controller = nil;
    if (aType != EMConferenceTypeLive) {
        controller = [[ConferenceViewController alloc] initWithConferenceType:aType];
        [self.mainController.navigationController pushViewController:controller animated:NO];
    }
    
    return controller;
}

- (LiveViewController *)pushLiveControllerWithPassword:(NSString *)aPassword
{
    [[DemoCallManager sharedManager] setIsCalling:YES];
    
    LiveViewController *controller = [[LiveViewController alloc] initWithPassword:aPassword];
    [self.mainController.navigationController pushViewController:controller animated:NO];
    
    return controller;
}

- (void)pushCustomVideoConferenceController
{
    [[DemoCallManager sharedManager] setIsCalling:YES];
    
    ConferenceViewController *confController = [[ConferenceViewController alloc] initVideoCallWithIsCustomData:YES];
    [self.mainController.navigationController pushViewController:confController animated:NO];
}

- (void)handleMessageToJoinConference:(EMMessage *)aMessage
{
    NSString *conferenceId = [aMessage.ext objectForKey:@"conferenceId"];
    NSString *password = [aMessage.ext objectForKey:@"password"];
    if ([conferenceId length] == 0) {
        conferenceId = [aMessage.ext objectForKey:@"em_conference_id"];
        password = [aMessage.ext objectForKey:@"em_conference_password"];
    }
    if ([conferenceId length] > 0) {
        if ([DemoCallManager sharedManager].isCalling) {
            return;
        }
        
        NSString *op = [aMessage.ext objectForKey:@"em_conference_op"];
        if ([op length] > 0) {
            if ([op isEqualToString:@"invite"]) {
                [[DemoCallManager sharedManager] setIsCalling:YES];
                EMConferenceType type = (EMConferenceType)[[aMessage.ext objectForKey:@"em_conference_type"] integerValue];
                if (type == EMConferenceTypeLive) {
                    LiveViewController *controller = [[LiveViewController alloc] initWithConfrId:conferenceId password:password admin:aMessage.from];
                    [self.mainController.navigationController pushViewController:controller animated:NO];
                } else {
                    ConferenceViewController *confController = [[ConferenceViewController alloc] initWithConferenceId:conferenceId password:password confrType:type];
                    [self.mainController.navigationController pushViewController:confController animated:NO];
                }
            }
        } else {
            ConferenceViewController *confController = [[ConferenceViewController alloc] initWithConferenceId:conferenceId password:password confrType:EMConferenceTypeLargeCommunication];
            [self.mainController.navigationController pushViewController:confController animated:NO];
        }
    }
}

#pragma mark - New

- (void)selectConfMemberWithType:(EMConferenceType)aType
{
    ConfInviteUsersViewController *controller = [[ConfInviteUsersViewController alloc] initWithType:aType];
    [self.mainController presentViewController:controller animated:NO completion:^{
        NSArray *usernames = [[EMClient sharedClient].contactManager getContacts];
        [controller.dataArray removeAllObjects];
        [controller.dataArray addObjectsFromArray:usernames];
        [controller.tableView reloadData];
    }];
}

- (EMConferenceViewController *)startConferenceWithType:(EMConferenceType)aType
                                               password:(NSString *)aPassword
                                            inviteUsers:(NSArray *)aInviteUsers
{
    [[DemoCallManager sharedManager] setIsCalling:YES];
    
    EMConferenceViewController *controller = nil;
    if (aType != EMConferenceTypeLive) {
        controller = [[MeetingViewController alloc] initWithPassword:aPassword inviteUsers:aInviteUsers];
    } else {
        
    }
    [self.mainController presentViewController:controller animated:NO completion:nil];
    
    return controller;
}

- (void)endConference:(EMCallConference *)aCall
            isDestroy:(BOOL)aIsDestroy
{
    if (aCall) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        [audioSession setActive:YES error:nil];
        
        [[EMClient sharedClient].conferenceManager stopMonitorSpeaker:aCall];
        
        if (aIsDestroy) {
            [[EMClient sharedClient].conferenceManager destroyConferenceWithId:aCall.confId completion:nil];
        } else {
            [[EMClient sharedClient].conferenceManager leaveConference:aCall completion:nil];
        }
        
        [[DemoCallManager sharedManager] setIsCalling:NO];
    }
}

#endif

@end