//
//  Call.h
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 通话状态
 */
typedef NS_ENUM(NSInteger, CallTypeStatus) {
    CallTypeConnecting = 1,
    CallTypeActive,
    CallTypeHold,
    CallTypeEnded,
};

/*!
 * 连接状态
 */
typedef NS_ENUM(NSInteger, ConectedTypeStatus) {
    ConectedTypePending = 0x1,
    ConectedTypeComplete,
};

typedef void(^connectedStateChanged)(void);
typedef void(^stateChanged)(void);

@interface Call : NSObject

@property(nonatomic,strong)NSUUID *uuid;
@property(nonatomic,assign)BOOL outgoing;
@property(nonatomic,strong)NSString *handle;

@property (nonatomic,assign) CallTypeStatus CallType;
@property (nonatomic,assign) ConectedTypeStatus ConectedType;

@property (nonatomic, copy) connectedStateChanged connectedStateChangedBlock;
@property (nonatomic, copy) stateChanged stateChangedBlock;

- (instancetype)initWithCall:(NSUUID *)uuid outgoing:(BOOL)outgoing handle:(NSString *)handle;

-(void)startComplete:(void (^)(BOOL success))CompleteBlock;
-(void)answer;
-(void)end;


@end

