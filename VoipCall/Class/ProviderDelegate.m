//
//  ProviderDelegate.m
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ProviderDelegate.h"

@interface ProviderDelegate ()

@property (nonatomic, strong) CXProvider* provider;
@property (nonatomic, strong) CXProviderConfiguration* config;
@property (nonatomic, strong) CallManager* CallManager;

@end

@implementation ProviderDelegate


- (instancetype)initWithCallController:(CallManager*)CallManager{
    self = [super init];
    if (self) {
        self.CallManager = CallManager;
        self.provider = [[CXProvider alloc] initWithConfiguration:self.config];
        [self.provider setDelegate:self queue:nil];
    }
    
    return self;
}

- (CXProviderConfiguration *)config{
    static CXProviderConfiguration* configInternal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configInternal = [[CXProviderConfiguration alloc] initWithLocalizedName:@"NewsReport"];
        configInternal.supportsVideo = YES;
        configInternal.maximumCallsPerCallGroup = 1;
        configInternal.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypePhoneNumber)];
//        configInternal.ringtoneSound = @"Ringtone.caf"; ///响铃声音
        
    });
    return configInternal;
}

/*!
 * 来电
 */
-(void)reportIncomingCall:(NSUUID *)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void(^)(NSError *))completionBlock{
    
    CXCallUpdate *update = [[CXCallUpdate alloc]init];
    update.remoteHandle  = [[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:handle];
    update.hasVideo      = hasVideo;
    
    [self.provider reportNewIncomingCallWithUUID:uuid update:update completion:^(NSError * _Nullable error) {
        
        if (error==nil) {
            Call *call = [[Call alloc]initWithCall:uuid outgoing:NO handle:handle];
            [self.CallManager add:call];
        }
        
        completionBlock(error);
        
    }];
}

#pragma mark < CXProviderDelegate >

- (void)providerDidReset:(CXProvider *)provider{
    
    for (Call *call in self.CallManager.calls) {
        [call end];
    }
    [self.CallManager removeAllCalls];
    
    NSLog(@"Stopping audio");
}


- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action{
    
    Call *call = [self.CallManager callWithUUID:action.UUID];
    if (!call) {
        [action fail];
        return;
    }
    
    [call answer];
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action{
    
    Call *call = [self.CallManager callWithUUID:action.UUID];
    if (!call) {
        [action fail];
        return;
    }
    
    [call end];
    [action fulfill];
    [self.CallManager remove:call];
    
    NSLog(@"Stopping audio");
}

- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action{
    
    Call *call = [self.CallManager callWithUUID:action.UUID];
    if (!call) {
        [action fail];
        return;
    }
    
    call.CallType = action.onHold? CallTypeHold:CallTypeActive;
    if (call.CallType == CallTypeHold) {
        
        NSLog(@"Stopping audio");
    }else{
        
        NSLog(@"Starting audio");
    }
    
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action{
    
    Call *call = [[Call alloc]initWithCall:action.UUID outgoing:YES handle:action.handle.value];
     NSUUID* currentID = call.uuid;
      __weak ProviderDelegate* weakSelf = self;
    
    call.connectedStateChangedBlock = ^{
        
        if (ConectedTypePending == call.ConectedType) {
            
             [weakSelf.provider reportOutgoingCallWithUUID:currentID startedConnectingAtDate:nil];
        }else if (ConectedTypeComplete == call.ConectedType){
            
            [weakSelf.provider reportOutgoingCallWithUUID:currentID connectedAtDate:nil];
        }
    };
    
    [call startComplete:^(BOOL success) {
        
        if (success) {
            [action fulfill];
            [weakSelf.CallManager add:call];
        }else{
            [action fail];
        }
    }];
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession{
    
        NSLog(@"Starting audio");
}


@end

