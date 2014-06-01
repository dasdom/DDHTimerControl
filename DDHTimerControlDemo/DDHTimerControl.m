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
//const CGFloat kDDHLabelInsetX = kDDHInsetX + 16.0f;
//const CGFloat kDDHLabelInsetY = kDDHLabelInsetX;
const CGFloat kDDHLabelWidth = 40;
const CGFloat kDDHLabelHeight = kDDHLabelWidth;
//const CGFloat kDDHMovingLabelWidth = 40.0f;
//const CGFloat kDDHMovingLabelHeight = 30.0f;

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
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation DDHTimerControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _maxValue = 60.0f;
        
        _minutesOrSecondsLabel = [[UILabel alloc] init];
        _minutesOrSecondsLabel.layer.cornerRadius = 6.0f;
        _minutesOrSecondsLabel.clipsToBounds = YES;
//        _minutesOrSecondsLabel.backgroundColor = [UIColor grayColor];
        
        [self addSubview:_minutesOrSecondsLabel];
        
        self.shapeLayer = [CAShapeLayer layer];
        
        [self.layer addSublayer:self.shapeLayer];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    _timerElementRect = CGRectInset(frame, kDDHInsetX, kDDHInsetY);
    _radius = CGRectGetWidth(_timerElementRect) / 2;

    _staticLableRect = CGRectInset(self.bounds, kDDHInsetX + 0.14*frame.size.width, kDDHInsetY + 0.14*frame.size.height);
    _minutesOrSecondsLabel.frame = _staticLableRect;

    self.fontSize = ceilf(_staticLableRect.size.height) - 10;
    NSLog(@"fontSize: %f", self.fontSize);

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat endAngleDegrees = 90 - self.minutesOrSeconds * 360 / 60.0;
    NSString* expression = [NSString stringWithFormat: @"%ld", (long)round(self.minutesOrSeconds)];
    
    //// TimerElement Drawing
    UIBezierPath* timerElementPath = UIBezierPath.bezierPath;
    CGFloat startAngle = 3 * M_PI/2;
    self.endAngle = -endAngleDegrees * M_PI/180;
    self.timerCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

    [timerElementPath addArcWithCenter:self.timerCenter radius:self.radius startAngle:startAngle endAngle:self.endAngle clockwise: YES];
//    [timerElementPath addArcWithCenter:self.timerCenter radius:self.radius - 4 startAngle:self.endAngle endAngle:startAngle  clockwise: NO];
//    [timerElementPath closePath];
    timerElementPath.lineWidth = 4;
    
    CGFloat dashLength = 2*self.radius*M_PI/118;
    CGFloat dash_pattern[]={dashLength,dashLength};
    [timerElementPath setLineDash:dash_pattern count:2 phase:0];
    
    if (!self.color) {
        self.color = [UIColor greenColor];
    }
    if (!self.highlightColor) {
        self.highlightColor = [UIColor yellowColor];
    }
    
    UIColor *timerColor = self.highlighted ? self.highlightColor : self.color;
    [timerColor setFill];
//    [timerElementPath fill];
    
//    [timerColor setStroke];
//    [timerElementPath stroke];
    
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.shapeLayer.strokeColor = [timerColor CGColor];
    self.shapeLayer.lineWidth = 4.0f;
    self.shapeLayer.strokeEnd = 1.0f;
    self.shapeLayer.lineDashPattern = @[@(dashLength), @(dashLength)];
    self.shapeLayer.path = timerElementPath.CGPath;

    UIBezierPath *handlePath = [UIBezierPath bezierPathWithArcCenter:[self handlePoint] radius:3.0f startAngle:0 endAngle:2*M_PI clockwise:YES];
    [handlePath fill];
    
    NSMutableParagraphStyle* labelStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    labelStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *labelFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Light" size:self.fontSize], NSForegroundColorAttributeName:self.color, NSParagraphStyleAttributeName: labelStyle};
    
//    self.minutesOrSecondsLabel.frame = labelRect;
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
- (void)setMinutesOrSeconds:(NSInteger)minutesOrSeconds animated:(BOOL)animated {
    CGFloat fromValue = _minutesOrSeconds / self.minutesOrSeconds;

    _minutesOrSeconds = minutesOrSeconds;
    [self setNeedsDisplay];
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @0.0f;
        animation.toValue = @1.0f;
        animation.duration = 5.0f;
        [self.shapeLayer addAnimation:animation forKey:@"strokeEnd"];
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

    [UIView animateWithDuration:0.2f animations:^{
        self.minutesOrSecondsLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20);
    } completion:^(BOOL finished) {
        self.minutesOrSecondsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self setNeedsDisplay];
    }];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
//    CGPoint previousPosition = [touch previousLocationInView:self];
    CGPoint position = [touch locationInView:self];
    
    CGFloat angleInDegrees = atanf((position.y - self.timerCenter.y)/(position.x - self.timerCenter.x))*180/M_PI + 90;
    if (position.x < self.timerCenter.x) {
        angleInDegrees += 180;
    }
    
    CGFloat selectedMinutesOrSeconds = angleInDegrees * 60 / 360;
    
//    self.currentValue = self.currentValue + (previousPosition.y - position.y)/5.0f;
    
//    self.minutesOrSeconds = (NSInteger)self.currentValue;
    self.minutesOrSeconds = selectedMinutesOrSeconds;
    
    CGPoint handlePoint = [self handlePoint];
       
    self.minutesOrSecondsLabel.center = CGPointMake(handlePoint.x, handlePoint.y - self.staticLableRect.size.height/2 - 20);

//    self.minutesOrSecondsLabel.frame = CGRectMake(handlePoint.x-kDDHMovingLabelWidth/2, handlePoint.y-kDDHMovingLabelHeight-20.0f, kDDHMovingLabelWidth, kDDHMovingLabelHeight);
    
    [self setNeedsDisplay];
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

@end
