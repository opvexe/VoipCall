//
//  AppDelegate.h
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFAudio.h>
#import <PushKit/PushKit.h>
#import "ProviderDelegate.h"
#import "CallManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong) ProviderDelegate *providerDelegate;
@property(nonatomic,strong) CallManager *callManager;

-(void)displayIncomingCall:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void(^)(NSError *))completionBlock;

@end

