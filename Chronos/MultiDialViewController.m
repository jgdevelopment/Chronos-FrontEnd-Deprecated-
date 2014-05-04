//
//  Created by Dimitris Doukas on 25/03/2011.
//  Copyright 2011 doukasd.com. All rights reserved.
//

#import "MultiDialViewController.h"
#import "GlowLabel.h"
#import "DialController.h"

#define DIAL_OFFSET_X               0
#define DIAL_OFFSET_Y               0
#define DIAL_WIDTH                  80
#define DIAL_HEIGHT                 205


@implementation MultiDialViewController


@synthesize presetStrings, delegate;
@synthesize dial1, dial2, dial3;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    _year = [yearString integerValue];

    //subscribe to accelerometer calls
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/60.0];
        
    //add dials and populate with these values...
    NSArray *numbers = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    NSArray *months = [NSArray arrayWithObjects:@"January", @"February", @"March", @"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    _years = [[NSMutableArray alloc]init];
    delimit = 1947;
    for  (int x = 0;x<_year-delimit;x++){
        [_years addObject:[NSString stringWithFormat:@"%i",_year-x]];
    }
    int dialCount = 0;
    self.dial1 = [[DialController alloc] initWithDialFrame:CGRectMake(DIAL_OFFSET_X + dialCount++ * DIAL_WIDTH-20, DIAL_OFFSET_Y, 2*DIAL_WIDTH, DIAL_HEIGHT) strings:months] ;
    self.dial1.delegate = self;
    [self.view addSubview:self.dial1.view];
    
    self.dial2 = [[DialController alloc] initWithDialFrame:CGRectMake(DIAL_OFFSET_X + 2*dialCount++ * DIAL_WIDTH-35, DIAL_OFFSET_Y, DIAL_WIDTH, DIAL_HEIGHT) strings:numbers];
    self.dial2.delegate = self;
    [self.view addSubview:self.dial2.view];
    
    self.dial3 = [[DialController alloc] initWithDialFrame:CGRectMake(DIAL_OFFSET_X + 1.5*dialCount++ * DIAL_WIDTH-35, DIAL_OFFSET_Y, DIAL_WIDTH+35, DIAL_HEIGHT) strings:_years];
    self.dial3.delegate = self;
    [self.view addSubview:self.dial3.view];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(spinToRandomYear) object:nil];
    [self performSelector:@selector(spinToRandomString:) withObject:nil afterDelay:0.5];

}

- (void)viewDidUnload {
    self.presetStrings = nil;
    self.delegate = nil;
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [super viewDidUnload];
}


#pragma mark DialControllerDelegate methods

- (void)dialControllerDidSpin:(DialController *)dial {
    //...
}

- (void)dialController:(DialController *)dial didSnapToString:(NSString *)value {
    NSLog(@"%@>%@", [self class], NSStringFromSelector(_cmd));
    
    if (!self.dial1.isSpinning && !self.dial2.isSpinning && !self.dial3.isSpinning && !self.dial4.isSpinning) {
        NSString *selectedString = [NSString stringWithFormat:@"%@%@%@%@", self.dial1.selectedString, self.dial2.selectedString, self.dial3.selectedString, self.dial4.selectedString];
        
        NSLog(@"selected string = %@", selectedString);
        
        //if our preset strings are not nil, we want to snap to those
        if (self.presetStrings != nil) {
            //check if the string is part of our strings
            int stringIndex = -1;
            for (int i=0; i<[self.presetStrings count]; i++) {
                if ([(NSString *)[self.presetStrings objectAtIndex:i] isEqualToString:selectedString]) {
                    stringIndex = i;
                    break;
                }
            }
            if (stringIndex > -1) {
                //if the selected string was in the presets, select it
                [[self delegate] multiDialViewController:self didSelectString:selectedString];
            }
            else {
                //if it wasn't, spin to one of the presets
                [self spinToRandomString:YES];
            }
        }
        else {
            //select that string
            [[self delegate] multiDialViewController:self didSelectString:selectedString];
        }
    }
}
-(void)setMyYearLimit:(int)limit{
    if (delimit>limit){
        for  (int x = _year-(delimit);x<_year-limit;x++){
            [_years addObject:[NSString stringWithFormat:@"%i",_year-x]];
        }
        
    }
    else if (delimit<limit){
        for  (int x = _year-delimit;x>_year-limit;x=x-1){
            [_years removeLastObject];
        }
    }
    delimit = limit;

    //[self.dial3.view removeFromSuperview];
    self.dial3.strings = _years;

}

//spin to random string
//is "preset" is true, spin to random preset string
- (void)spinToRandomString:(BOOL)preset {
    if (preset && self.presetStrings != nil) {
        //spin to preset
        int selectedStringIndex = 10 % [self.presetStrings count];
        NSString *selectedString = [self.presetStrings objectAtIndex:selectedStringIndex];
        NSLog(@"autoselecting string %@", selectedString);
        
        //call all the dials
        [self.dial1 spinToString:[selectedString substringWithRange:NSMakeRange(10, 21)]];
        [self.dial2 spinToString:[selectedString substringWithRange:NSMakeRange(10, 21)]];
        [self.dial3 spinToString:[selectedString substringWithRange:NSMakeRange(10, 21)]];
    }
    else {
        //spin to random
        [self.dial1 spinToRandomString];
        [self.dial2 spinToRandomString];
        [self.dial3 spinToRandomString];
    }
}

#pragma mark -

//add shake to spin to random value
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	if (fabs(acceleration.x) + fabs(acceleration.y) + fabs(acceleration.z) > 4.0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(spinToRandomYear) object:nil];
        [self performSelector:@selector(spinToRandomString:) withObject:nil afterDelay:0.5];
    }
}

#pragma -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.presetStrings = nil;
    self.dial1 = self.dial2 = self.dial3 = nil;
}

@end