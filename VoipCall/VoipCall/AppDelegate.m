//
//  AppDelegate.m
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
@interface AppDelegate ()<PKPushRegistryDelegate>

@property(nonatomic,strong) PKPushRegistry* pushRegistry;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]init];
    
    self.window.frame = [UIScreen mainScreen].bounds;
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    
    
    self.pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    self.pushRegistry.delegate = self;
    self.pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    self.callManager = [[CallManager alloc]init];
    self.providerDelegate = [[ProviderDelegate alloc]initWithCallController:self.callManager];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)displayIncomingCall:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void(^)(NSError *))completionBlock{
    
    [self.providerDelegate reportIncomingCall:uuid handle:handle hasVideo:hasVideo completion:^(NSError *error) {
        completionBlock(error);
    }];
}

#pragma mark < PKPushRegistryDelegate >

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type{
    
    
}


- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type{
    
    
}




@end

