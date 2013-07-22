//
//  GKLViewController.h
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/* Delegate protocol for GKLCubViewController to inform child controllers that they have been hidden or unhidden */

@protocol GKLCubeViewControllerDelegate <NSObject>

@optional

/** Notification that view was hidden */

- (void)cubeViewDidHide;

/** Notification that view was unhidden (or was presented first time) */

- (void)cubeViewDidUnhide;

@end

/** Custom container class for rotating cube of four view controllers. */

@interface GKLCubeViewController : UIViewController

/** Add child view controller to the `GKLCubeViewController`

 @param controller The child view controller being added

 */

- (void)addCubeSideForChildController:(UIViewController *)controller;

@end
