//
//  ViewController.m
//  ScrollViewGettingTouched
//
//  Copyright (c) 2014 CocoaHeadsFFM. All rights reserved.
//

#import "ViewController.h"
#import "DotView.h"
#import "OverlayScrollView.h"
#import "TouchDelayGestureRecognizer.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
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
    
    TouchDelayGestureRecognizer *touchDelay = [[TouchDelayGestureRecognizer alloc] initWithTarget:nil action:nil];
    [_canvasView addGestureRecognizer:touchDelay];
    
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
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.cancelsTouchesInView = NO;
        longPress.delegate = self;
        [dotView addGestureRecognizer:longPress];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture {
    UIView *dot = gesture.view;
    
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dotGrab:dot withGesture:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self dotMove:dot withGesture:gesture];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self dotDrop:dot withGesture:gesture];
            break;

        default:
            break;
    }
}

- (void)dotGrab:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture {
    dot.center = [self.view convertPoint:dot.center fromView:dot.superview];
    [self.view addSubview:dot];
    
    [UIView animateWithDuration:0.2 animations:^{
        dot.transform = CGAffineTransformMakeScale(1.2, 1.2);
        dot.alpha = 0.8f;
        //beware of finger jump
        [self dotMove:dot withGesture:gesture];
    }];
    
    _scrollView.panGestureRecognizer.enabled = NO;
    _scrollView.panGestureRecognizer.enabled = YES;
    
    
    [self arrageDotsNeatlyInView:_drawerView.contentView];
    
}

- (void)dotMove:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture {
    dot.center = [gesture locationInView:self.view];
    
}

- (void)dotDrop:(UIView*)dot withGesture:(UIGestureRecognizer*)gesture {
    [UIView animateWithDuration:0.2 animations:^{
        dot.transform = CGAffineTransformIdentity;
        dot.alpha = 1.0f;
    }];
    
    CGPoint locationInDrawer = [gesture locationInView:_drawerView];
    if (CGRectContainsPoint([_drawerView bounds], locationInDrawer)) {
        [_drawerView.contentView addSubview:dot];
    } else {
        [_canvasView addSubview:dot];
    }
    
    dot.center = [self.view convertPoint:dot.center fromView:dot.superview];

    [self arrageDotsNeatlyInView:_drawerView.contentView];

}

- (void)arrageDotsRandomlyInView:(UIView*)view {
    CGFloat maxX = CGRectGetMaxX(view.frame);
    CGFloat maxY = CGRectGetMaxY(view.frame);
    
    for (DotView* dotView in view.subviews) {
        CGFloat x = arc4random_uniform(maxX);
        CGFloat y = arc4random_uniform(maxY);
        dotView.center = CGPointMake(x, y);
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //just for the demo, better to be more specific
    return YES;
}
@end
