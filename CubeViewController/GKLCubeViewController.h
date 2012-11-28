//
//  GKLViewController.h
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GKLCubeViewController : UIViewController{
    NSMutableArray *views;
    double startingX, startingAngle, finishingAngle;
    int facingSide;
    CATransformLayer *transformLayer;
    UIView *currentView;
}
-(void)addView:(UIView*)newView;
@end
