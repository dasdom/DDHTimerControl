//
//  DDHTimerControl.h
//  DDHTimerControlDemo
//
//  Created by Dominik Hauser on 29.05.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Type of the timer ring
 */
typedef NS_ENUM(NSUInteger, DDHTimerType) {
    /**
     *  The ring looks like a clock
     */
    DDHTimerTypeElements = 0,
    /**
     *  All the elements are equal
     */
    DDHTimerTypeEqualElements,
    /**
     *  The ring is a solid line
     */
    DDHTimerTypeSolid,
    /**
     *  The number of the different types
     */
    DDHTimerTypeNumberOfTypes
};

/**
 *  A simple subclass of UIControl to set seconds or minutes
 */
@interface DDHTimerControl : UIControl

/**
 *  The value of the control
 */
@property (nonatomic, assign) NSInteger minutesOrSeconds;

/**
 *  The maximal allowed value
 */
@property (nonatomic, assign) NSInteger maxValue;

/**
 *  The color of the control
 */
@property (nonatomic, strong) UIColor *color;

/**
 *  The color of the control during interaction
 */
@property (nonatomic, strong) UIColor *highlightColor;

/**
 *  The label for the title show below the value
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  The ring width
 */
@property (nonatomic, assign) CGFloat ringWidth;

/**
 *  The timer type
 */
@property (nonatomic, assign) DDHTimerType type;

/**
 *  Create a timer control with a type
 *
 *  @param type The type the conrol should have
 *
 *  @return An initialized timer control
 */
+ (instancetype)timerControlWithType:(DDHTimerType)type;

/**
 *  The setter for the value
 *
 *  @param minutesOrSeconds The new value
 */
- (void)setMinutesOrSeconds:(NSInteger)minutesOrSeconds;

@end
