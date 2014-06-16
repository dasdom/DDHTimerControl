//
//  DDHTimerControl.h
//  DDHTimerControlDemo
//
//  Created by Dominik Hauser on 29.05.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol DDHTimerControlDelegate <NSObject>
//@optional
//
//@end

typedef NS_ENUM(NSUInteger, DDHTimerType) {
    DDHTimerTypeElements = 0,
    DDHTimerTypeEqualElements,
    DDHTimerTypeSolid,
    DDHTimerTypeNumberOfTypes
};


@interface DDHTimerControl : UIControl
@property (nonatomic, assign) NSInteger minutesOrSeconds;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat ringWidth;
@property (nonatomic, assign) DDHTimerType type;

+ (instancetype)timerControlWithType:(DDHTimerType)type;
- (void)setMinutesOrSeconds:(NSInteger)minutesOrSeconds;
@end
