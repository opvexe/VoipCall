//
//  CallManager.m
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CallManager.h"

@interface CallManager ()

@property(nonatomic,strong)CXCallController *callController;

@end

@implementation CallManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

/*!
 * 开始通话
 */
- (void)startCall:(NSString*)handle videoEnabled:(BOOL)videoEnabled{
    
    CXHandle *handles = [[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:handle];
    CXStartCallAction *startCallAction = [[CXStartCallAction alloc]initWithCallUUID:[NSUUID UUID] handle:handles];
    startCallAction.video = videoEnabled;
    CXTransaction *transaction = [[CXTransaction alloc]initWithAction:startCallAction];
    [self requestTransaction:transaction];
}

/*!
 * 结束通话
 */
- (void)end:(Call *)call{
    
    CXEndCallAction *endCallAction = [[CXEndCallAction alloc]initWithCallUUID:call.uuid];
    CXTransaction *transaction = [[CXTransaction alloc]initWithAction:endCallAction];
    [self requestTransaction:transaction];
}

/*!
 * 挂起通话
 */
-(void)setHeld:(Call *)call onHold:(BOOL)onHold{
    
    CXSetHeldCallAction *setHeldCallAction = [[CXSetHeldCallAction alloc]initWithCallUUID:call.uuid onHold:onHold];
    CXTransaction *transaction = [[CXTransaction alloc]initWithAction:setHeldCallAction];
    [self requestTransaction:transaction];
}

/*!
 * 发起会话通话
 */
-(void)requestTransaction:(CXTransaction *)transaction{
    
    [self.callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"Transaction Error");
        }else{
            
            NSLog(@"Transaction Suceessfully");
        }
    }];
}

/*!
 * 根据UUID获取指定会话人
 */
-(Call *)callWithUUID:(NSUUID *)uuid{
    
    for (int index = 0; index < self.calls.count; index ++) {
        Call *call  = self.calls[index];
        if ([[call.uuid UUIDString] isEqualToString:[uuid UUIDString]]) {
            return  call;
        }
    }
    return nil;
}

/*!
 * 添加会话
 */
-(void)add:(Call *)call{
    
    [self.calls addObject:call];
    
    if (self.callBlock) {
     self.callBlock();
    }
}

/*!
 * 移除会话
 */
-(void)remove:(Call *)call{
    
    for (int index = 0 ; index <self.calls.count; index++) {
        Call *calls = self.calls[index];
        if ([[calls.uuid UUIDString] isEqualToString:[call.uuid UUIDString]]) {
            [self.calls removeObjectAtIndex:index];
        }
    }
    self.callBlock();
}

/*!
 * 移除所有会话
 */
-(void)removeAllCalls{
    
    [self.calls removeAllObjects];
    self.callBlock();
}


-(NSMutableArray *)calls{
    if (!_calls) {
        _calls = [[NSMutableArray alloc]init];
    }
    return _calls;
}

-(CXCallController *)callController{
    if (!_callController) {
        _callController = [[CXCallController alloc]initWithQueue:dispatch_get_main_queue()];
    }
    return _callController;
}

@end

