//
//  ChildFourViewController.m
//  CubeViewController
//
//  Created by Robert Ryan on 7/20/13.
//  Copyright (c) 2013 GoKart Labs. All rights reserved.
//

#import "ChildFourViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ChildFourViewController ()

@end

@implementation ChildFourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:self.view.center radius:self.view.bounds.size.width * 0.4 startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [path CGPath];
    layer.fillColor = [[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.8] CGColor];
    
    [self.view.layer addSublayer:layer];
}

@end
