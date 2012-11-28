//
//  GKLViewController.m
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import "GKLCubeViewController.h"

#define kPerspective    -1/1000.0f
#define kDuration       0.7f

@interface GKLCubeViewController ()

@end

@implementation GKLCubeViewController

-(void)addView:(UIView*)newView{
    newView.frame = CGRectMake(0, 0, newView.frame.size.width, newView.frame.size.height);
    double halfWidth = self.view.bounds.size.width / 2.0;
//    CGFloat perspective = kPerspective;
    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = perspective;
    double rotationDistance = [views count] * M_PI_2;
    transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
    transform = CATransform3DRotate(transform, rotationDistance - 0., 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
    newView.layer.transform = transform;
    [self.view addSubview:newView];
    newView.alpha = 0.5f;
    [views addObject:newView];
    [newView setNeedsDisplay];
//    [self.view setNeedsLayout];
}

- (void)viewDidLoad{
    views = [[NSMutableArray alloc] init];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.view addGestureRecognizer:panner];
    facingSide = 0;
}

-(void)panHandler:(UIPanGestureRecognizer*)panner{
    CGPoint translatedPoint = [panner translationInView:self.view.window];
    CGFloat halfWidth = self.view.bounds.size.width / 2.0;
    //    save our starting points
    if([panner state] == UIGestureRecognizerStateBegan) {
        startingX = translatedPoint.x;
        if (!transformLayer) {
            transformLayer = [[CATransformLayer alloc] init];
            transformLayer.frame = self.view.layer.bounds;
            
            for (UIView *viewToTranslate in views) {
                [viewToTranslate removeFromSuperview];
                [transformLayer addSublayer:viewToTranslate.layer];
            }
            //        add in this new layer
            [self.view.layer addSublayer:transformLayer];
        }
    } else if([panner state] == UIGestureRecognizerStateEnded) {
//        add in half a pi to "round" the integer up
        double face = (((finishingAngle * 180.0f)/ M_PI)/90.0f) + 4;
        int side = (int)(face + 0.5) % 4;
        NSLog(@"Finishing Angle: %f\nStopped on face: %f, side: %i", finishingAngle, face, side);
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = kPerspective;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
//            put our views back
            facingSide += side;
            for (UIView *view in views) {
                CATransform3D transform = CATransform3DIdentity;
                double rotationDistance = (([views indexOfObject:view] + facingSide) % 4) * M_PI_2;
                NSLog(@"View %i being rotated %f", [views indexOfObject:view], rotationDistance);
                transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
                transform = CATransform3DRotate(transform, rotationDistance - 0., 0, 1, 0);
                transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
                view.layer.transform = transform;
                [self.view addSubview:view];
            }
            [transformLayer removeFromSuperlayer];
            transformLayer = nil;
            startingAngle = 0.0f;
        }];
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:transformLayer.transform];
        transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
        double adjustmentAngle = fmod(side * M_PI_2, M_PI * 2);
        transform = CATransform3DRotate(transform, adjustmentAngle, 0, 1, 0);
        transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
        transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
        transformAnimation.duration = kDuration;
        [transformLayer addAnimation:transformAnimation forKey:@"rotate"];
        transformLayer.transform = transform;
        [CATransaction commit];
        startingAngle = adjustmentAngle;
    } else {
//        instantly adjust our transformation layer
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = kPerspective;
        double percentageOfWidth = (translatedPoint.x - startingX) / self.view.frame.size.width;
        transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
        double adjustmentAngle = percentageOfWidth * M_PI_2 + startingAngle;
        transform = CATransform3DRotate(transform, adjustmentAngle, 0, 1, 0);
        transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
        transformLayer.transform = transform;
        finishingAngle = adjustmentAngle;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
