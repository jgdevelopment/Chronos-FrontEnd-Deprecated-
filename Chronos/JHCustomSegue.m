//
//  JHCustomSegue.m
//  past time
//
//  Created by Jason Ginsberg on 7/9/13.
//  Copyright (c) 2013 Jason Ginsberg. All rights reserved.
//

#import "JHCustomSegue.h"

@implementation JHCustomSegue
- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}

@end
@implementation JHCustomSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}


@end