//
//  EMConferenceViewController.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2018/9/20.
//  Copyright © 2018 XieYajie. All rights reserved.
//

#import "EMCallViewController.h"

#import "DemoConfManager.h"
#import "EMConferenceVideoView.h"

#define kConferenceVideoMaxCol 2

//默认状态：
//1. 使用前置摄像头
//2. 不上传本地视频
@interface EMConferenceViewController : EMCallViewController

@property (nonatomic, strong) EMButton *switchCameraButton;
@property (nonatomic, strong) EMButton *videoButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) __block EMCallConference *conference;
@property (nonatomic, readonly) EMConferenceType type;
@property (nonatomic, strong) NSString *password;
@property (nonatomic) BOOL isCreater;
@property (nonatomic, strong) NSString *joinConfId;

@property (nonatomic, strong) EMCallLocalView *localVideoView;
@property (nonatomic, strong) NSString *pubStreamId;
@property (nonatomic, strong, readonly) NSMutableDictionary *streamItemDict;

@property (nonatomic) float videoViewBorder;
@property (nonatomic) CGSize videoViewSize;

- (instancetype)initWithType:(EMConferenceType)aType
                    password:(NSString *)aPassword
                 inviteUsers:(NSArray *)aInviteUsers;

- (void)createConference;

@end