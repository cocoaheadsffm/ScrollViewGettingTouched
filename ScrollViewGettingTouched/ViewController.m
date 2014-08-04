//
//  ViewController.m
//  ScrollViewGettingTouched
//
//  Created by Flori on 04.08.14.
//  Copyright (c) 2014 CocoaHeadsFFM. All rights reserved.
//

#import "ViewController.h"
#import "DotView.h"

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
    
    [self addDotsRandomly:42 toView:_canvasView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:bounds];
    [self.view addSubview:_scrollView];
    
    _drawerView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _drawerView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 650.0f);
    [_scrollView addSubview:_drawerView];
    
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds) + CGRectGetHeight(_drawerView.frame));
    _scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(_drawerView.frame));
    _scrollView.userInteractionEnabled = NO;
    
}

- (void)addDotsRandomly:(NSUInteger)count toView:(UIView*)view {
    CGFloat maxX = CGRectGetMaxX(view.frame);
    CGFloat maxY = CGRectGetMaxY(view.frame);
    CGSize maxSize = CGSizeMake(maxX, maxY);
    
    for (NSUInteger dot = 0; dot < count; dot++) {
        DotView *dotView = [DotView randomDotViewWithSize:maxSize];
        NSLog(@"dotview %@", NSStringFromCGRect(dotView.frame));
        [view addSubview:dotView];
    }
}


@end
