//
//  ViewController.m
//  ScrollViewGettingTouched
//
//  Created by Flori on 04.08.14.
//  Copyright (c) 2014 CocoaHeadsFFM. All rights reserved.
//

#import "ViewController.h"
#import "DotView.h"
#import "OverlayScrollView.h"

@interface ViewController ()
@property(nonatomic, strong) UIView* canvasView;
@property(nonatomic, strong) UIScrollView* scrollView;
@property(nonatomic, strong) UIVisualEffectView* drawerView;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    _canvasView = [[UIView alloc] initWithFrame:bounds];
    _canvasView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_canvasView];
    
    [self addDots:25 toView:_canvasView];
    [self arrageDotsRandomlyInView:_canvasView];
    
    _scrollView = [[OverlayScrollView alloc] initWithFrame:bounds];
    [self.view addSubview:_scrollView];
    
    _drawerView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _drawerView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 650.0f);
    [_scrollView addSubview:_drawerView];
    
    [self addDots:20 toView:_drawerView.contentView];
    [self arrageDotsNeatlyInView:_drawerView.contentView];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds) + CGRectGetHeight(_drawerView.frame));
    _scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(_drawerView.frame));
    //_scrollView.userInteractionEnabled = NO;
    //restore panning
    [self.view addGestureRecognizer:_scrollView.panGestureRecognizer];
    
    
}

- (void)addDots:(NSUInteger)count toView:(UIView*)view {
    for (NSUInteger dot = 0; dot < count; dot++) {
        DotView *dotView = [DotView randomDot];
    
        [view addSubview:dotView];
    }
}

- (void)arrageDotsRandomlyInView:(UIView*)view {
    CGFloat maxX = CGRectGetMaxX(view.frame);
    CGFloat maxY = CGRectGetMaxY(view.frame);
    
    for (DotView* dotView in view.subviews) {
        CGFloat x = arc4random_uniform(maxX);
        CGFloat y = arc4random_uniform(maxY);
        dotView.frame = CGRectMake(x, y, CGRectGetWidth(dotView.frame), CGRectGetHeight(dotView.frame));
    }
}

- (void)arrageDotsNeatlyInView:(UIView*)view {
    CGFloat padding = 30;
    CGFloat spaceOfOneDot = ([DotView maxRadius] * 2) + padding;
    CGFloat maxX = CGRectGetMaxX(view.frame) - (padding*2);
    
    CGFloat x = padding;
    CGFloat y = padding;
    //NSLog(@"spaceOfOneDot %4.0f maxX %4.0f", spaceOfOneDot, maxX);
    for (DotView* dotView in view.subviews) {
        dotView.frame = CGRectMake(x + (spaceOfOneDot/2) - dotView.radius, y+ (spaceOfOneDot/2) - dotView.radius, CGRectGetWidth(dotView.frame), CGRectGetHeight(dotView.frame));
            //NSLog(@"dotview %@ %4.0f", NSStringFromCGRect(dotView.frame),dotView.radius);
        x += spaceOfOneDot;
        if (x >= maxX) {
            x = padding;
            y += spaceOfOneDot;
        }


    }
}


@end
