//
//  NCViewController.m
//  past time
//
//  Created by Jason Ginsberg on 7/8/13.
//  Copyright (c) 2013 Jason Ginsberg. All rights reserved.
//

#import "NCViewController.h"
#import "ViewController.h"
@interface NCViewController : UINavigationBar
@end

@implementation NCViewController

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"CustomNavBG.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end