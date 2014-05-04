//
//  upsideNavViewController.m
//  Chronos
//
//  Created by Jason Ginsberg on 12/21/13.
//  Copyright (c) 2013 Jason Ginsberg. All rights reserved.
//

#import "upsideNavViewController.h"

@interface upsideNavViewController ()

@end

@implementation upsideNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Deprecated in iOS6, still needed for iOS5 support.
// ---

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

// iOS6 support
// ---
- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
@end
