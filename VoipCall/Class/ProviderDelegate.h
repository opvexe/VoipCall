//
//  ProviderDelegate.h
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
#import "CallManager.h"
#import "Call.h"

@interface ProviderDelegate : NSObject<CXProviderDelegate>

/*!
 * 初始化通话管理类
 */
- (instancetype)initWithCallController:(CallManager*)CallManager;

/*!
 * 发起通话
 */
-(void)reportIncomingCall:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void(^)(NSError *))completionBlock;


@end
