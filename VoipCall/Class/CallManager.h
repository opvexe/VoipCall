//
//  CallManager.h
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>
#import "Call.h"

typedef void(^callsChangedHandler)(void);

@interface CallManager : NSObject

@property(nonatomic,strong)NSMutableArray *calls;
@property (nonatomic,copy) callsChangedHandler callBlock;

/*!
 * 开始通话
 */
- (void)startCall:(NSString*)handle videoEnabled:(BOOL)videoEnabled;

/*!
 * 结束通话
 */
- (void)end:(Call *)call;

/*!
 * 挂起通话
 */
-(void)setHeld:(Call *)call onHold:(BOOL)onHold;

/*!
 * 根据UUID获取指定会话人
 */
-(Call *)callWithUUID:(NSUUID *)uuid;

/*!
 * 添加会话
 */
-(void)add:(Call *)call;

/*!
 * 移除会话
 */
-(void)remove:(Call *)call;

/*!
 * 移除所有会话
 */
-(void)removeAllCalls;

@end
