GKLCubeViewController
===================

### Introduction

This project was originally started as a UI proof-of-concept at [GoKart Labs](http://gokartlabs.com/), which is where the `GKL` prefix comes from. The project was scrapped, and I decided to release the code so it wouldn't be wasted.

This is custom container controller that lets you navigate through a series of child view controllers represented as sides of a cube that you swipe/pan to rotate to navigate from one view to another. This is a simplied user interface rendition of the user interface popularized by the [WeatherCube](http://www.weathercube.com) app (except this rotates the entire view, not just a portion of a view).

### How To Use

#### Installation

##### Hard way
Copy `GKLCubeViewController.h` and `GKLCubeViewController.m` to your project. Add `QuartzCore.framework` to your project. See [Linking to a Library or Framework](http://developer.apple.com/library/ios/#recipes/xcode_help-project_editor/Articles/AddingaLibrarytoaTarget.html).

##### Easy way
Use [CocoaPods](http://cocoapods.org/): `pod 'GKLCubeViewController', :git => "https://github.com/pyro2927/GKLCubeViewController.git"`

#### Code

2. Initialize an instance of `GKLCubeViewController`. You could simply create an instance of it in your app delegate:

    	GKLCubeViewController *cubeViewController = [[GKLCubeViewController alloc] initWithNibName:nil bundle:nil];
        
 Or, as this demonstration does, you could create your own subclass of `GKLCubeViewController` and use that in your storyboard/NIB.
	
3. Add the child view controllers representing the four sides of the cube:

        [cubeViewController addCubeSideForChildController:childController];

 For example, this demonstration implementation creates four blank view controllers in `DemonstrationViewController.m`:

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
        
4. If needed, child view controllers can conform to the `GKLCubeViewControllerDelegate` protocol and implement either `cubeViewDidUnhide` or `cubeViewDidHide` to be notified as the view appears. Note, as you start to rotate a controller into view, you may see these methods be called a little before you can actually see the view (because of perspective, the front of the cube will continue to obscure the side for a bit).

And that's it! You can start spinning your view cube (OK, I guess technically it's a rectangular prism) by sliding your finger left/right on the app.

This demonstration project uses four random scenes from a storyboard. In this case, they:

- The first is largely blank;
- The second has a table view populated by `ChildTwoViewController`;
- The third uses a `NSTimer` to update the time (and illustrates the use of `GKLCubeViewControllerDelegate` protocol in `ChildThreeViewController`); and
- The fourth simply draws a circle on the view (in `ChildFourViewController`).

### Change history

23 July 2013. Updating README, adding in Podspec

20 July 2013. Robert M. Ryan. Addressing a number of issues:

1. There was a serious performance penalty resulting from using a `CATransformLayer` in conjunction with views that already had `transform` properties on their layers. When performing gesture, it was very sluggish.

2. Also added the necessary view controller containment calls.

3. Modified to handle "flick".

4. Only perform transforms on the two visible sides of the cube (since only two are visible at any given time) and hide the others.

5. Add `GKLCubeViewControllerDelegate` protocol. If the child controllers implement `cubeViewDidHide` and/or `cubeViewDidUnhide`, that will be called as the view rotates out of view and back into view.

 In the demonstration project, the third child view controller employs this protocol to identify when to start and stop a repeating timer.

28 November 2012. [pyro2927](https://github.com/pyro2927). Created, inspired by [augustjoki](https://github.com/augustjoki)'s original [CubeTabBarController](https://github.com/augustjoki/CubeTabBarController)

### Known limitations

This expects four child view controllers. It won't work if you have more than four, and you'll see a "blank" side of the cube if you have less than that.  We are [working on supporting](https://github.com/pyro2927/GKLCubeViewController/tree/non-cube-support) an arbitrary number of sides.

### Example

![](https://raw.github.com/pyro2927/GKLCubeViewController/master/cube.gif)
