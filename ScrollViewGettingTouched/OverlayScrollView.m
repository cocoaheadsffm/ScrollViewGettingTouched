//
//  OverlayScrollView.m
//  ScrollViewGettingTouched
//
//  Created by Flori on 04.08.14.
//  Copyright (c) 2014 CocoaHeadsFFM. All rights reserved.
//

#import "OverlayScrollView.h"

@implementation OverlayScrollView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

@end
