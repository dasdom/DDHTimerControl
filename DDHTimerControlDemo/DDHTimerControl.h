//
//  DDHTimerControl.h
//  DDHTimerControlDemo
//
//  Created by Dominik Hauser on 29.05.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDHTimerControl : UIControl
@property (nonatomic, assign) NSInteger minutesOrSeconds;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *highlightColor;

- (void)setMinutesOrSeconds:(NSInteger)minutesOrSeconds animated:(BOOL)animated;
@end
