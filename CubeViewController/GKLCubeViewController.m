//
//  GKLViewController.m
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import "GKLCubeViewController.h"

CGFloat const kPerspective = -0.001f;
CGFloat const kDuration    =  0.3f;

@interface GKLCubeViewController ()

// basic cube state properties

@property (nonatomic)         NSInteger       facingSide;

// basic CADisplayLink properties

@property (nonatomic, strong) CADisplayLink  *displayLink;
@property (nonatomic)         CFTimeInterval  startTime;

// display link state properties

@property (nonatomic)         CFTimeInterval  remainingAnimationDuration;
@property (nonatomic)         CGFloat         startAngle;
@property (nonatomic)         CGFloat         targetAngle;

// views for dimming the sides as the cube is rotated

@property (nonatomic, strong) UIView *leftDimmingView;
@property (nonatomic, strong) UIView *rightDimmingView;

@end


@implementation GKLCubeViewController

- (void)configureProperties
{
    _animationDuration = kDuration;
    _perspective = kPerspective;
    _facingSide = 0;

    _leftDimmingView = [[UIView alloc] init];
    _leftDimmingView.userInteractionEnabled = NO;
    _leftDimmingView.backgroundColor = [UIColor blackColor];

    _rightDimmingView = [[UIView alloc] init];
    _rightDimmingView.userInteractionEnabled = NO;
    _rightDimmingView.backgroundColor = [UIColor blackColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureProperties];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configureProperties];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Add gesture recognizer

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self rotateAllSidesBy:0.0f];
}

#pragma mark - Management of cube sides

- (void)addCubeSideForChildController:(UIViewController *)controller
{
    [self addChildViewController:controller];          // necessary custom container call

    controller.view.frame = self.view.bounds;
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    NSInteger numberOfSides = [self sides];
    CGFloat angle = (numberOfSides == 1 ? 0.0f : M_PI);

    [self rotateCubeSideForViewController:controller
                                  byAngle:angle
                         applyPerspective:YES];

    [controller didMoveToParentViewController:self];   // necessary custom container call
}

- (void)rotateCubeSideForViewController:(UIViewController *)controller byAngle:(CGFloat)angle applyPerspective:(BOOL)applyPerspective
{
    // make sure angle is within reasonable range of values

    while (angle > M_PI)  angle -= (M_PI * 2.0);
    while (angle < -M_PI) angle += (M_PI * 2.0);

    // see if the side of the cube is even visible

    CGFloat minAngle = MIN(M_PI_2, M_PI * 2.0 / [self sides]);

    if (angle <= -minAngle || angle >= minAngle)
    {
        // if not, hide if (if not already) and then quit

        if (controller.view.superview)
        {
            [controller.view removeFromSuperview];
        }
        return;
    }

    // otherwise if the view is hidden, show it

    if (!controller.view.superview)
    {
        [self.view addSubview:controller.view];
        controller.view.frame = self.view.bounds;
    }

    if (angle != 0.0f)
    {
        // if the angle is non-zero, then do all the complicated 3D transform stuff ...

        CGFloat halfWidth = self.view.bounds.size.width / 2.0;
        NSInteger sides = [self.childViewControllers count];
        CGFloat theta = M_PI / sides;
        CGFloat z = halfWidth / tan(theta);

        CATransform3D transform = CATransform3DIdentity;
        if (applyPerspective) transform.m34 = self.perspective;
        transform = CATransform3DTranslate(transform, 0, 0, -z);
        transform = CATransform3DRotate(transform, angle, 0, 1, 0);
        transform = CATransform3DTranslate(transform, 0, 0, z);
        controller.view.layer.transform = transform;

        // ... and then set up the appropriate dimming views
        
        UIView *fadingView = (angle < 0.0 ? _leftDimmingView : _rightDimmingView);
        if ([fadingView superview] != controller.view)
        {
            [controller.view addSubview:fadingView];
            fadingView.frame = controller.view.bounds;
        }
        fadingView.alpha = MIN(fabs(angle / M_PI), 0.5);
    }
    else
    {
        // if the angle is zero, then we can just set the transform to identity ...

        controller.view.layer.transform = CATransform3DIdentity;

        // ... and also get rid of the dimming views
        
        if (_leftDimmingView.superview)  [_leftDimmingView  removeFromSuperview];

        if (_rightDimmingView.superview) [_rightDimmingView removeFromSuperview];
    }
}

- (NSInteger)sides
{
    return [self.childViewControllers count];
}

- (void)rotateAllSidesBy:(CGFloat)rotation
{
    NSInteger sides = [self.childViewControllers count];

    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        CGFloat startingAngle = ((idx + _facingSide) % sides) * M_PI * 2.0f / sides;

        [self rotateCubeSideForViewController:controller byAngle:startingAngle+rotation applyPerspective:YES];
    }];
}

#pragma mark - Gesture Recognizer

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    double percentageOfWidth = translation.x / self.view.frame.size.width;

    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateChanged)
    {
        // iterate through the child controllers, adjusting their views

        double rotation = percentageOfWidth * M_PI * 2.0f / [self sides];
        [self rotateAllSidesBy:rotation];
    }

    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint velocity = [gesture velocityInView:gesture.view];

        // factor in velocity to capture a "flick"

        double percentageOfWidthIncludingVelocity = (translation.x + 0.25 * velocity.x) / self.view.frame.size.width;

        self.startAngle = percentageOfWidth * M_PI * 2.0f / [self sides];

        // if moved left (and/or flicked left)
        if (translation.x < 0 && percentageOfWidthIncludingVelocity < -0.5)
            self.targetAngle = -M_PI * 2.0f / [self sides];

        // if moved right (and/or flicked right)
        else if (translation.x > 0 && percentageOfWidthIncludingVelocity > 0.5)
            self.targetAngle = M_PI * 2.0f / [self sides];

        // otherwise, move back to zero
        else
            self.targetAngle = 0.0;

        [self startDisplayLink];
    }
}

#pragma mark - CADisplayLink

/*
 Using display link is probably overkill here, but it

 (a) keeps the sides of the cube synchronized during rotation;
 (b) avoids the performance hit of putting transformed sides of a cube within a layer/view with its own transform

 The end result should be a more responsive rotation animation. The downside is that I'm employing a simplistic linear animation.
 */

- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.startTime = CACurrentMediaTime();
    self.remainingAnimationDuration = fabsf(self.targetAngle - self.startAngle) / (M_PI * 2.0 / [self sides]) * self.animationDuration;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    CFTimeInterval elapsed = CACurrentMediaTime() - self.startTime;
    CGFloat percentComplete = (elapsed / self.remainingAnimationDuration);

    if (percentComplete >= 0.0 && percentComplete < 1.0)
    {
        // if animation is still in progress, then update to show progress

        CGFloat rotation = (self.targetAngle - self.startAngle) * percentComplete + self.startAngle;

        [self rotateAllSidesBy:rotation];
    }
    else
    {
        // we are done

        [self stopDisplayLink];

        CGFloat faceAdjustment = self.targetAngle / (M_PI * 2.0f / [self sides]);
        self.facingSide = (int)floorf(faceAdjustment + self.facingSide + [self sides] + 0.5) % [self sides];
        
        [self rotateAllSidesBy:0.0];
    }
}

@end
