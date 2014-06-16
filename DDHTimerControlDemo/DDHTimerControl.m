//
//  DDHTimerControl.m
//  DDHTimerControlDemo
//
//  Created by Dominik Hauser on 29.05.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

#import "DDHTimerControl.h"

const CGFloat kDDHInsetX = 10.0f;
const CGFloat kDDHInsetY = kDDHInsetX;
const CGFloat kDDHLabelWidth = 40;
const CGFloat kDDHLabelHeight = kDDHLabelWidth;

@interface DDHTimerControl ()
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat currentValue;
@property (nonatomic, assign) CGPoint timerCenter;
@property (nonatomic, assign) CGRect timerElementRect;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) UILabel *minutesOrSecondsLabel;
@property (nonatomic, assign) CGRect staticLableRect;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) CAShapeLayer *majorShapeLayer;
@property (nonatomic, strong) CAShapeLayer *minorShapeLayer;
@end

@implementation DDHTimerControl

+ (instancetype)timerControlWithType:(DDHTimerType)type {
    DDHTimerControl *control = [[DDHTimerControl alloc] initWithFrame:CGRectZero];
    control.type = type;
    return control;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _maxValue = 60.0f;
        _ringWidth = 4;
        
        _minutesOrSecondsLabel = [[UILabel alloc] init];
        _minutesOrSecondsLabel.layer.cornerRadius = 6.0f;
        _minutesOrSecondsLabel.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _minorShapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_minorShapeLayer];
        
        _majorShapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_majorShapeLayer];
        
        [self addSubview:_titleLabel];
        [self addSubview:_minutesOrSecondsLabel];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    _timerElementRect = CGRectInset(frame, kDDHInsetX, kDDHInsetY);
    _radius = CGRectGetWidth(_timerElementRect) / 2;

    _staticLableRect = CGRectInset(self.bounds, kDDHInsetX + floorf(0.18*frame.size.width), kDDHInsetY + floorf(0.18*frame.size.height));
    _staticLableRect.origin.y -= floorf(0.1*frame.size.height);
    _minutesOrSecondsLabel.frame = _staticLableRect;

    CGFloat height = _staticLableRect.size.height;
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_staticLableRect), CGRectGetMaxY(_staticLableRect)-floorf(0.1*height), _staticLableRect.size.width, floorf(0.4f*height));
    _titleLabel.textColor = self.color;
    
    self.fontSize = ceilf(0.85f*height);

    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:floorf(self.fontSize/2.0f)];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSString* expression = [NSString stringWithFormat: @"%ld", (long)round(self.minutesOrSeconds)];
    
    //// TimerElement Drawing
    CGFloat startAngle = 3 * M_PI/2;
    self.endAngle = self.minutesOrSeconds * 2 * M_PI / self.maxValue - M_PI_2;
    self.timerCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    CGFloat dashLength = 2*self.radius*M_PI/(2*(self.maxValue-1));
    
    if (!self.color) {
        self.color = [UIColor greenColor];
    }
    if (!self.highlightColor) {
        self.highlightColor = [UIColor yellowColor];
    }
    
    UIColor *timerColor = self.highlighted ? self.highlightColor : self.color;
    [timerColor setFill];
    
    UIBezierPath* timerElementPath = UIBezierPath.bezierPath;
    [timerElementPath addArcWithCenter:self.timerCenter radius:self.radius startAngle:startAngle endAngle:startAngle-0.01 clockwise: YES];
    
    self.majorShapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.majorShapeLayer.strokeColor = [timerColor CGColor];
    self.majorShapeLayer.lineWidth = self.ringWidth;
    self.majorShapeLayer.strokeEnd = (float)self.minutesOrSeconds/self.maxValue;
    if (self.type >= DDHTimerTypeNumberOfTypes) {
        NSAssert1(false, @"The given type (%lu) is not supported", self.type);
    }
    
    if (self.type != DDHTimerTypeSolid) {
        if (self.type == DDHTimerTypeElements) {
            self.majorShapeLayer.lineDashPattern = @[@(dashLength), @(8.76*dashLength)];
        } else if (self.type == DDHTimerTypeEqualElements) {
            self.majorShapeLayer.lineDashPattern = @[@(dashLength), @(0.955*dashLength)];
        }
        self.majorShapeLayer.lineDashPhase = 1;
    }
    self.majorShapeLayer.path = timerElementPath.CGPath;

    if (self.type == DDHTimerTypeElements) {
        UIBezierPath *timerMinorElementPath = UIBezierPath.bezierPath;
        [timerMinorElementPath addArcWithCenter:self.timerCenter radius:self.radius startAngle:startAngle endAngle:startAngle-0.01 clockwise: YES];
        self.minorShapeLayer.fillColor = [[UIColor clearColor] CGColor];
        self.minorShapeLayer.strokeColor = [[timerColor colorWithAlphaComponent:0.5f] CGColor];
        self.minorShapeLayer.lineWidth = 1;
        self.minorShapeLayer.strokeEnd = (float)self.minutesOrSeconds/self.maxValue;
        self.minorShapeLayer.lineDashPattern = @[@(dashLength), @(0.955*dashLength)];
        self.minorShapeLayer.lineDashPhase = 1;
        self.minorShapeLayer.path = timerMinorElementPath.CGPath;
    }
    
    CGFloat handleRadius;
    if (self.userInteractionEnabled) {
        handleRadius = self.ringWidth;
    } else {
        handleRadius = ceilf(self.ringWidth/2);
    }

    UIBezierPath *handlePath = [UIBezierPath bezierPathWithArcCenter:[self handlePoint] radius:handleRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [handlePath fill];
    
    NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    labelStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size:self.fontSize], NSForegroundColorAttributeName:self.color, NSParagraphStyleAttributeName: labelStyle};
    
    self.minutesOrSecondsLabel.attributedText = [[NSAttributedString alloc] initWithString:expression attributes:labelFontAttributes];
}

#pragma mark - helper methods
- (CGPoint)handlePoint {
    CGFloat handleAngle = self.endAngle + M_PI_2;
    CGPoint handlePoint = CGPointZero;
    handlePoint.x = self.timerCenter.x + (self.radius) * sinf(handleAngle);
    handlePoint.y = self.timerCenter.y - (self.radius) * cosf(handleAngle);
    return handlePoint;
}

#pragma mark - Setters
- (void)setMinutesOrSeconds:(NSInteger)minutesOrSeconds {
    if (minutesOrSeconds > self.maxValue) {
        minutesOrSeconds = self.maxValue;
    } else if (minutesOrSeconds < 0) {
        minutesOrSeconds = 0;
    }
    
    if (_minutesOrSeconds != minutesOrSeconds) {
        _minutesOrSeconds = minutesOrSeconds;
        [self setNeedsDisplay];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint position = [touch locationInView:self];
    
    CGPoint handlePoint = [self handlePoint];
    UIBezierPath *handlePath = [UIBezierPath bezierPathWithArcCenter:handlePoint radius:20.0f startAngle:0 endAngle:2*M_PI clockwise:YES];
    if ([handlePath containsPoint:position]) {
        self.highlighted = YES;
    } else {
        self.highlighted = NO;
    }
    self.currentValue = self.minutesOrSeconds;
    
    [UIView animateWithDuration:0.2f delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:20.0f options:kNilOptions animations:^{
        self.minutesOrSecondsLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20);
    } completion:^(BOOL finished) {
        self.minutesOrSecondsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        [self setNeedsDisplay];
    }];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
    CGPoint position = [touch locationInView:self];
    
    CGFloat angleInDegrees = atanf((position.y - self.timerCenter.y)/(position.x - self.timerCenter.x))*180/M_PI + 90;
    if (position.x < self.timerCenter.x) {
        angleInDegrees += 180;
    }
    
    CGFloat selectedMinutesOrSeconds = angleInDegrees * self.maxValue / 360;
    
    self.minutesOrSeconds = (NSInteger)selectedMinutesOrSeconds;
    
    CGPoint handlePoint = [self handlePoint];
    
    [UIView animateWithDuration:0.1 delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:kNilOptions animations:^{
        self.minutesOrSecondsLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20);
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    
    self.minutesOrSecondsLabel.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.2f animations:^{
        self.minutesOrSecondsLabel.center = CGPointMake(CGRectGetMidX(self.staticLableRect), CGRectGetMidY(self.staticLableRect));
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];

}

#pragma mark - Accessibility
- (BOOL)isAccessibilityElement {
    return YES;
}

- (NSString*)accessibilityValue {
    return [NSString stringWithFormat:@"%@ %@", self.minutesOrSecondsLabel.text, self.titleLabel.text];
}

- (UIAccessibilityTraits)accessibilityTraits {
    return UIAccessibilityTraitAdjustable;
}

- (void)accessibilityIncrement {
    self.minutesOrSeconds = self.minutesOrSeconds + 1;
}

- (void)accessibilityDecrement {
    self.minutesOrSeconds = self.minutesOrSeconds - 1;
}

@end
