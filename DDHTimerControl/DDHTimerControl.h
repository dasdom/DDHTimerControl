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
 *  Timer direction (countdown vs count up)
 */
typedef NS_ENUM(NSUInteger, DDHTimerDirection) {
    /**
     *  The time will count up
     */
    DDHTimerDirectionUp = 0,
    /**
     *  The timer will count down
     */
    DDHTimerDirectionDown
};

/**
 *  Time interval (minutes or seconds)
 */
typedef NS_ENUM(NSUInteger, DDHTimeInterval) {
    /**
     *  The timer will represent seconds
     */
    DDHTimeIntervalSeconds = 0,
    /**
     *  The timer will represent minutes
     */
    DDHTimeIntervalMinutes
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
 *  The state of the timer
 */
@property (nonatomic) BOOL isActive;

/**
 *  The timer type
 */
@property (nonatomic, assign) DDHTimerType type;

/**
 *  The time interval for the control
 */
@property (nonatomic, assign) DDHTimeInterval timeInterval;

/**
 *  The timer direction for the control
 */
@property (nonatomic, assign) DDHTimerDirection direction;

/**
 *  Create a timer control with a type
 *
 *  @param type The type the conrol should have
 *
 *  @return An initialized timer control
 */
+ (instancetype)timerControlWithType:(DDHTimerType)type;

/**
 *  Create a timer control with a type, time interval, direction, and initial value
 *
 *  @param type The type the control should have
 *  @param interval The DDHTimeInterval value for this control (DDHTimeIntervalMinutes or DDHTimeIntervalSeconds)
 *  @param direction The direction in which the timer will move (DDHTimerDirectionUp or DDHTimerDirectionDown)
 *  @param startValue The time value the timer will begin with
 *  @return An initialized timer control with the provided type, interval, direction, and initial value
 */
+ (instancetype)timerControlWithType:(DDHTimerType)type interval:(DDHTimeInterval)interval direction:(DDHTimerDirection)direction startValue:(NSInteger)startValue;

/**
 *  The setter for the value
 *
 *  @param minutesOrSeconds The new value
 */
- (void)setMinutesOrSeconds:(NSInteger)minutesOrSeconds;

/**
 *  Tell the timer to start
 *
 */
- (void)start;

/**
 *  Tell the timer to stop
 *
 */
- (void)stop;

@end
