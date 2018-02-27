//
//  Call.m
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "Call.h"

@implementation Call


- (instancetype)initWithCall:(NSUUID *)uuid outgoing:(BOOL)outgoing handle:(NSString *)handle{
    self = [super init];
    if (self) {
        self.uuid = uuid;
        self.outgoing = outgoing;
        self.handle = handle;
    }
    return self;
}

-(void)setCallType:(CallTypeStatus)CallType{
    if (CallType == CallTypeEnded) {
        self.stateChangedBlock();
    }
}

-(void)setConectedType:(ConectedTypeStatus)ConectedType{
    if (ConectedType == ConectedTypePending) {
        self.connectedStateChangedBlock();
    }
}

-(void)startComplete:(void (^)(BOOL success))CompleteBlock{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.CallType = CallTypeConnecting;
        self.ConectedType = ConectedTypePending;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.CallType = CallTypeActive;
        self.ConectedType = ConectedTypeComplete;
    });
    
    CompleteBlock(YES);
}

-(void)answer{
    self.CallType = CallTypeActive;
}

-(void)end{
    self.CallType = CallTypeEnded;
}


@end

