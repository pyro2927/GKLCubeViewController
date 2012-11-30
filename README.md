GKLCubeViewController
===================

Inspired by augustjoki's [CubeTabBarController](https://github.com/augustjoki/CubeTabBarController), I wanted to create a cube that you could spin around it's Y axis to see different views.

### How To Use

Initialize:

	GKLCubeViewController *viewController = [[GKLCubeViewController alloc] initWithNibName:nil bundle:nil];
	
Add views:

	//adding in 4 views of different colors
    NSArray *colors = [NSArray arrayWithObjects:[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blackColor], nil];
    for (UIColor *color in colors) {
        UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        [vc.view setBackgroundColor:color];
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 50)];
        text.text = [@"View " stringByAppendingFormat:@"%i", [colors indexOfObject:color]];
        [vc.view addSubview:text];
        [self.viewController addView:vc.view];
    }

And that's it! You can start spinning your view cube (OK, I guess technically it's a rectangular prism) by sliding your finger left/right on the app.

### Transparency

By default each view has it's alpha value set to `0.7f` after it's been added for debugging purposes.  To disable this, comment out line 34 in `GKLCubeViewController.m`.
	
	//newView.alpha = 0.7f;

![](https://raw.github.com/pyro2927/GKLCubeViewController/master/cube.gif)