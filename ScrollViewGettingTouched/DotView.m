//
//  DotView.m
//  ScrollViewGettingTouched
//
//  Copyright (c) 2014 CocoaHeadsFFM. All rights reserved.
//

#import "DotView.h"
#import <QuartzCore/QuartzCore.h>

@interface DotView()

@end

@implementation DotView

+ (instancetype)randomDot {
    
    CGFloat radius = arc4random_uniform([self maxRadius]);
    CGFloat red = arc4random_uniform(255.0f) / 255.0f;
    CGFloat green = arc4random_uniform(255.0f) / 255.0f;
    CGFloat blue = arc4random_uniform(255.0f) / 255.0f;
    
    DotView* random = [[DotView alloc] initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    random.radius = radius;
    random.color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    return random;
}

+ (CGFloat)maxRadius {
    return 42;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = CGRectGetWidth(frame)/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    CGFloat x = CGRectGetMinX(self.frame);
    CGFloat y = CGRectGetMinY(self.frame);
    self.frame = CGRectMake(x, y, radius*2, radius*2);
    self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = color;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat h,s,b,a;
    if ([_color getHue:&h saturation:&s brightness:&b alpha:&a]) {
        self.backgroundColor = [UIColor colorWithHue:h
                                          saturation:s
                                          brightness:1.0f
                                               alpha:a];
    }

    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = _color;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = _color;
    [self setNeedsDisplay];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect touchBounds = self.bounds;
    if (_radius < 22.0) {
        CGFloat expansion = 22.0 - _radius;
        touchBounds = CGRectInset(touchBounds, -expansion, -expansion);
    }
    return CGRectContainsPoint(touchBounds, point);
}

@end
