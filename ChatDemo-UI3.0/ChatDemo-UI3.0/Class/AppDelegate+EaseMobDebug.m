//
//  AppDelegate+EaseMobDebug.m
//  ChatDemo-UI2.0
//
//  Created by dujiepeng on 15/7/1.
//  Copyright (c) 2015年 dujiepeng. All rights reserved.
//  测试用，开发者不需要使用此类

#import "AppDelegate+EaseMobDebug.h"

#warning 环信内部测试用，开发者不需要使用此类

@implementation AppDelegate (EaseMobDebug)


-(BOOL)isSpecifyServer {
    
//    NSDictionary *dic = @{kSDKAppKey:@"easemobdemo#chatdemoui",
//                          kSDKApnsCertName:@"chatdemoui_dev",
//                          kSDKServerApi:@"172.17.18.220:8080",
//                          kSDKServerChat:@"172.17.2.224",
//                          kSDKServerGroupDomain:@"conference.easemob.com",
//                          kSDKServerChatDomain:@"easemob.com",
//                          kSDKServerChatPort:@"5222"};
//    
//    [[EaseMob sharedInstance] registerPrivateServerWithParams:dic];
//    
//    
//    return YES;
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSNumber *specifyServer = [ud objectForKey:@"identifier_enable"];
    if ([specifyServer boolValue]) {
        NSString *apnsCertName = nil;
#if DEBUG
        apnsCertName = @"chatdemoui_dev";
#else
        apnsCertName = @"chatdemoui";
#endif
        NSString *appkey = [ud stringForKey:@"identifier_appkey"];
        if (!appkey)
        {
            appkey = @"easemob-demo#chatdemoui";
            [ud setObject:appkey forKey:@"identifier_appkey"];
        }
        NSString *imServer = [ud stringForKey:@"identifier_imserver"];
        if (!imServer)
        {
            imServer = @"im1.sandbox.easemob.com";
            [ud setObject:imServer forKey:@"identifier_imserver"];
        }
        NSString *imPort = [ud stringForKey:@"identifier_import"];
        if (!imPort)
        {
            imPort = @"443";
            [ud setObject:imPort forKey:@"identifier_import"];
        }
        NSString *restServer = [ud stringForKey:@"identifier_restserver"];
        if (!restServer)
        {
            restServer = @"a1.sdb.easemob.com";
            [ud setObject:restServer forKey:@"identifier_restserver"];
        }
        [ud synchronize];
        
        NSDictionary *dic = @{kSDKAppKey:appkey,
                              kSDKApnsCertName:apnsCertName,
                              kSDKServerApi:restServer,
                              kSDKServerChat:imServer,
                              kSDKServerGroupDomain:@"conference.easemob.com",
                              kSDKServerChatDomain:@"easemob.com",
                              kSDKServerChatPort:imPort};
        
        id easemob = [EaseMob sharedInstance];
        SEL selector = @selector(registerPrivateServerWithParams:);
        [easemob performSelector:selector withObject:dic];
        return YES;
    }
    
    return NO;
}
@end
