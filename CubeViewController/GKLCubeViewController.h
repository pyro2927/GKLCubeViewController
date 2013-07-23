//
//  GKLViewController.h
//  CubeViewController
//
//  Created by Joseph Pintozzi on 11/28/12.
//  Copyright (c) 2012 GoKart Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/** Delegate protocol for GKLCubViewController to inform child controllers that they have been hidden or unhidden */

@protocol GKLCubeViewControllerDelegate <NSObject>

@optional

/** Notification that view was hidden */

- (void)cubeViewDidHide;

/** Notification that view was unhidden (or was presented first time) */

- (void)cubeViewDidUnhide;

@end

/** Custom container class for rotating cube of four view controllers. */

@interface GKLCubeViewController : UIViewController

/*****************************
 * @name Add child controllers
 *****************************/

/** Add child view controller to the `GKLCubeViewController`

 @param controller The child view controller being added

 */

- (void)addCubeSideForChildController:(UIViewController *)controller;


/*****************************
 * @name Properties
 *****************************/

/** Duration of full animation (animation is pro-rated based upon how far the user panned before animation started
 
 Default value is `0.3f`.
 */

@property (nonatomic) CGFloat animationDuration;

/** Perspective factor for the `m34` value of the 3D transformation
 
 Default value is `-0.001`. Values like `-0.002` lend a more pronounced 3D feel. Values such as `0.0005` lend a less pronounced 3D feel.
 */

@property (nonatomic) CGFloat perspective;

@end
