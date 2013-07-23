//
//  ChildThreeViewController.m
//  CubeViewController
//
//  Created by Robert Ryan on 7/20/13.
//  Copyright (c) 2013 GoKart Labs. All rights reserved.
//

#import "ChildThreeViewController.h"
#import "GKLCubeViewController.h"

@interface ChildThreeViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ChildThreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

#pragma mark - Timer methods

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)handleTimer:(NSTimer *)timer
{
    static NSDateFormatter *timeFormat = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeFormat = [[NSDateFormatter alloc] init];
        timeFormat.dateFormat = @"hh:mm:ss.S";
    });
    
    self.timeLabel.text = [timeFormat stringFromDate:[NSDate date]];
}

@end
