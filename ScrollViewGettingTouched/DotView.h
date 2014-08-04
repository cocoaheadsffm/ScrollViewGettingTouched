//
//  DotView.h
//  ScrollViewGettingTouched
//
//  Copyright (c) 2014 CocoaHeadsFFM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotView : UIView
@property(nonatomic) CGFloat radius;
@property(nonatomic) UIColor* color;
+ (instancetype)randomDot;
+ (CGFloat)maxRadius;
@end
