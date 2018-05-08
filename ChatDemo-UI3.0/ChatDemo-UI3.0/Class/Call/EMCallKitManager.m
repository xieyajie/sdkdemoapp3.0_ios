//
//  EMCallKitManager.m
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2018/5/4.
//  Copyright © 2018 XieYajie. All rights reserved.
//

#import <PushKit/PushKit.h>
#import <CallKit/CallKit.h>
#import "EMCallKitManager.h"

@interface EMCallKitManager()<PKPushRegistryDelegate>

//@property (nonatomic, strong) ProviderDelegate* provider;

@end

static EMCallKitManager *sharedManager = nil;
@implementation EMCallKitManager

- (instancetype)init
{
    self = [super init];
    if (self) {
#if DEMO_CALL == 1
        //详见:https://developer.apple.com/library/content/documentation/Performance/Conceptual/EnergyGuide-iOS/OptimizeVoIP.html#//apple_ref/doc/uid/TP40015243-CH30-SW1
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        PKPushRegistry * voipRegistry = [[PKPushRegistry alloc] initWithQueue: mainQueue];
        voipRegistry.delegate = self;
        voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
#endif
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[EMCallKitManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - PKPushRegistryDelegate

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{
    NSString *tokenString = [[[[credentials.token description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"xieyajie============pushkit=============credentialsToken=%@", credentials.token);
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    // 呼出系统接听界面
    // 或者生成本地推送
    
    // 从payload中获取推送信息
//    NSDictionary *dic = payload.dictionaryPayload;
//    NSDictionary *apsDic = dic[@"aps"];
//    NSString *msgId = dic[@"mssage_id"];
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate date];
//    localNotification.alertBody = apsDic[@"alert"];
//    localNotification.soundName = @"default";
//    localNotification.alertTitle = @"一条来自PushKit的推送";
//    localNotification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: msgId, @"msgid", nil];
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
