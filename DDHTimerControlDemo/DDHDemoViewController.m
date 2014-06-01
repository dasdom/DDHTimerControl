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
    _timerControl1.minutesOrSeconds = 33;
    [contentView addSubview:_timerControl1];
    
    DDHTimerControl *timerControl2 = [[DDHTimerControl alloc] init];
    timerControl2.translatesAutoresizingMaskIntoConstraints = NO;
    timerControl2.color = [UIColor orangeColor];
    timerControl2.highlightColor = [UIColor redColor];
    timerControl2.minutesOrSeconds = 12;
    [contentView addSubview:timerControl2];
    
    self.view = contentView;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerControl1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_timerControl1 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:timerControl2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:timerControl2 attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];

    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_timerControl1, timerControl2);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_timerControl1(100)]-[timerControl2(70)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.timerControl1 setMinutesOrSeconds:55 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
