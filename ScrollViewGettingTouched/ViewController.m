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
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    _canvasView = [[UIView alloc] initWithFrame:bounds];
    _canvasView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_canvasView];
    
    [self addDotsRandomly:42 toView:_canvasView];
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
