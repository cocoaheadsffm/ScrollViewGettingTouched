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

@interface ViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>
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
    _scrollView.bounces = NO; //switch back to YES, if u like bounces
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _drawerView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _drawerView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 650.0f);
    [_scrollView addSubview:_drawerView];
    
    [self addDots:20 toView:_drawerView.contentView];
    [self arrageDotsNeatlyInView:_drawerView.contentView animated:NO];
    
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
    
    
    [self arrageDotsNeatlyInView:_drawerView.contentView animated:YES];
    
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

    [self arrageDotsNeatlyInView:_drawerView.contentView animated:YES];

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

- (void)arrageDotsNeatlyInView:(UIView*)view animated:(BOOL)animated {
    CGFloat padding = 30;
    CGFloat spaceOfOneDot = ([DotView maxRadius] * 2) + padding;
    CGFloat maxX = CGRectGetMaxX(view.frame) - (padding*2);
    
    CGFloat x = padding + spaceOfOneDot/2.0f;
    CGFloat y = padding + spaceOfOneDot/2.0f;
    //NSLog(@"spaceOfOneDot %4.0f maxX %4.0f", spaceOfOneDot, maxX);
    
    NSTimeInterval duration = (animated) ? 0.2 : 0.0;
    NSTimeInterval delay = 0.0;
    for (DotView* dotView in view.subviews) {
        [UIView animateWithDuration:duration delay:delay options:0 animations:^{
            dotView.center = CGPointMake(x, y);
        } completion:nil];
        
        delay += (animated) ? 0.02 : 0.0;
        
        x += spaceOfOneDot;
        if (x >= maxX) {
            x = padding + spaceOfOneDot/2.0;
            y += spaceOfOneDot;
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //just for the demo, better to be more specific
    return YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"velocity=%@", NSStringFromCGPoint(velocity));
    if (velocity.y > 0.0) {
        *targetContentOffset = CGPointMake(targetContentOffset->x, 650.0);
    } else {
        *targetContentOffset = CGPointMake(targetContentOffset->x, 0.0);
    }
    //    [scrollView scrollRectToVisible: animated:<#(BOOL)#>]
}

@end
