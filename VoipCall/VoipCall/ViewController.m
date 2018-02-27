//
//  ViewController.m
//  VoipCall
//
//  Created by Facebook on 2018/2/13.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property(nonatomic,strong)UITextField *iphoneNumber;
@property(nonatomic,strong)UISegmentedControl *callSgement;
@property(nonatomic,strong)UISwitch *Hasvideo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"Voip"];
    
    
    self.iphoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(40, 100, [UIScreen mainScreen].bounds.size.width - 80, 40)];
    self.iphoneNumber.placeholder = @"输入号码";
    [self.view addSubview:self.iphoneNumber];
    
    self.callSgement = [[UISegmentedControl alloc]initWithItems:@[@"Call In",@"Call Out"]];
    self.callSgement.frame = CGRectMake(40, 170, 200, 40);
    self.callSgement.selectedSegmentIndex = 0;
    [self.callSgement setWidth:80.0 forSegmentAtIndex:0];
    [self.callSgement setWidth:80.0 forSegmentAtIndex:1];
    [self.callSgement addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.callSgement];
    
    self.Hasvideo= [[UISwitch alloc]initWithFrame:CGRectMake(40,250 , 100, 30)];
    self.Hasvideo.on = NO;
    [self.Hasvideo addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview: self.Hasvideo];
    
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callButton.frame = CGRectMake(40, 300, 100, 30);
    [callButton setTitle:@"Call" forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callButton];
    
}

-(void)segmentChange:(UISegmentedControl *)control{
    
    NSLog(@"%ld",control.selectedSegmentIndex);
    
    if (control.selectedSegmentIndex == 0) {
        
        NSLog(@"Call In");
    }else{
        
        NSLog(@"Call Out");
    }
}


-(void)switchAction:(UISwitch *)sender{
    
    if (sender.on == NO) {
        
        sender.on = YES;
    }else{
        
        sender.on = NO;
    }
}


-(void)callAction{
    
    if (self.callSgement.selectedSegmentIndex==0) {
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) displayIncomingCall:[NSUUID UUID] handle:self.iphoneNumber.text hasVideo:self.Hasvideo.on completion:^(NSError *error) {
            
        }];
        
    }else{
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).callManager startCall:self.iphoneNumber.text videoEnabled:self.Hasvideo.on];
        
    }
}

@end

