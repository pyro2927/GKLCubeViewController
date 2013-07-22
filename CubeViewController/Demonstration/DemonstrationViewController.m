//
//  DemonstrationViewController.m
//  CubeViewController
//
//  Created by Robert Ryan on 7/20/13.
//  Copyright (c) 2013 GoKart Labs. All rights reserved.
//

#import "DemonstrationViewController.h"

@interface DemonstrationViewController ()

@end

@implementation DemonstrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureDemonstrationChildViewControllers];
}

- (void)configureDemonstrationChildViewControllers
{
    UIViewController *controller;
    
    controller = [self.storyboard instantiateViewControllerWithIdentifier:@"child1"];
    [self addCubeSideForChildController:controller];
    
    controller = [self.storyboard instantiateViewControllerWithIdentifier:@"child2"];
    [self addCubeSideForChildController:controller];
    
    controller = [self.storyboard instantiateViewControllerWithIdentifier:@"child3"];
    [self addCubeSideForChildController:controller];
    
    controller = [self.storyboard instantiateViewControllerWithIdentifier:@"child4"];
    [self addCubeSideForChildController:controller];
}


@end
