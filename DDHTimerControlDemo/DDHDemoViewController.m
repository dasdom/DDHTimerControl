//
//  DDHDemoViewController.m
//  DDHTimerControlDemo
//
//  Created by dasdom on 29.05.14.
//  Copyright (c) 2014 dasdom. All rights reserved.
//

#import "DDHDemoViewController.h"
#import "DDHTimerControl.h"

@interface DDHDemoViewController ()
@property (nonatomic, strong) DDHTimerControl *timerControl1;
@property (nonatomic, strong) DDHTimerControl *timerControl2;
@property (nonatomic, strong) DDHTimerControl *timerControl3;
@property (nonatomic, strong) DDHTimerControl *timerControl4;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation DDHDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor colorWithRed:0.142 green:0.149 blue:0.204 alpha:1.000];
    
    _timerControl1 = [[DDHTimerControl alloc] init];
    _timerControl1.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl1.color = [UIColor greenColor];
    _timerControl1.highlightColor = [UIColor yellowColor];
    _timerControl1.minutesOrSeconds = 55;
    _timerControl1.titleLabel.text = @"min";
    [contentView addSubview:_timerControl1];
    
    [_timerControl1 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _timerControl2 = [DDHTimerControl timerControlWithType:DDHTimerTypeEqualElements];
    _timerControl2.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl2.color = [UIColor orangeColor];
    _timerControl2.highlightColor = [UIColor redColor];
    _timerControl2.minutesOrSeconds = 12;
    _timerControl2.titleLabel.text = @"min";
    _timerControl2.userInteractionEnabled = NO;
    [contentView addSubview:_timerControl2];
    
    _timerControl3 = [DDHTimerControl timerControlWithType:DDHTimerTypeSolid];
    _timerControl3.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl3.color = [UIColor orangeColor];
    _timerControl3.highlightColor = [UIColor redColor];
    _timerControl3.minutesOrSeconds = 59;
    _timerControl3.titleLabel.text = @"sec";
    _timerControl3.userInteractionEnabled = NO;
    [contentView addSubview:_timerControl3];
    
    _timerControl4 = [DDHTimerControl timerControlWithType:DDHTimerTypeSolid interval:DDHTimeIntervalSeconds direction:DDHTimerDirectionUp startValue:0];
    _timerControl4.translatesAutoresizingMaskIntoConstraints = NO;
    _timerControl4.color = [UIColor redColor];
    _timerControl4.userInteractionEnabled = NO;
    [contentView addSubview:_timerControl4];

    UIButton *startStopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startStopButton.translatesAutoresizingMaskIntoConstraints = NO;
    [startStopButton setTitle:@"start/stop" forState:UIControlStateNormal];
    [startStopButton addTarget:self action:@selector(toggleStartStop) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:startStopButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitle:@"random" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(random:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    self.view = contentView;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_timerControl1 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_timerControl2 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_timerControl3 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_timerControl3 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_timerControl4 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_timerControl1, _timerControl2, _timerControl3, _timerControl4, startStopButton, button);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_timerControl1(200)]-20-[button(40)]-30-[_timerControl2(80)]-[startStopButton(10)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_timerControl4(60)]-[_timerControl2]-[_timerControl3(60)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
    self.endDate = [NSDate dateWithTimeIntervalSinceNow:12.0f*60.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleStartStop {
    if (_timerControl4.isActive) {
        [_timerControl4 stop];
    }
    else {
        [_timerControl4 start];
    }
}

- (void)random:(UIButton*)sender {
    NSUInteger randomInteger = arc4random_uniform(60);
    
    self.timerControl1.minutesOrSeconds = randomInteger;
}

- (void)changeTimer:(NSTimer*)timer {
    NSTimeInterval timeInterval = [self.endDate timeIntervalSinceNow];
    
//    NSLog(@"timeInterval: %f, minutes: %f", timeInterval, timeInterval/60.0f);
    self.timerControl2.minutesOrSeconds = (NSInteger)(timeInterval/60.0f);
    self.timerControl3.minutesOrSeconds = ((NSInteger)timeInterval)%60;
}

- (void)valueChanged:(DDHTimerControl*)sender {
    NSLog(@"value: %d", sender.minutesOrSeconds);
}

@end
