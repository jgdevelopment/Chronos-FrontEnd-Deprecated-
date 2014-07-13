//
//  ViewController.m
//  past time
//
//  Created by Jason Ginsberg on 7/8/13.
//  Copyright (c) 2013 Jason Ginsberg. All rights reserved.
//

#import "MultiDialViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "SBJSON.h"
#import "CSAnimation.h"
#import "CSAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize selectedStringLabel, presetStringsView, timer, tap;


- (void)viewDidLoad
{
    [super viewDidLoad];
    _onlyOnce = YES;
    _start = NO;
    
    _newsWeb.hidden = YES;
    _newsWeb.delegate = self;
    _newsWeb.scalesPageToFit = YES;
    
    _pricePageControl.currentPage = 0;
    _pricePageControl.numberOfPages = 2;
    [_pricePageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

    newsTable.dataSource = self;

    _windImage.center=CGPointMake(93,332);
    
    _confirmButton.frame = CGRectMake(_confirmButton.frame.origin.x,self.view.frame.size.height-63, self.view.frame.size.width, self.view.frame.size.height);
    
    _playPressed = YES;
    _animatedHappened = NO;
    _internetView.delegate = self;
    _internetView.scalesPageToFit = YES;
    
    _albumCover.delegate = self;
    _albumCover.scalesPageToFit = YES;
    _albumCover.autoresizesSubviews = YES;
    
    _webProgress.hidden = YES;
    _webProgress.progress =0;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    _webProgress.transform = transform;
    
    _canAnimate = YES;
    _animationsAdded = [[NSMutableArray alloc] init];
    
    _searchBar.delegate = self;
    [_searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    _searchON = NO;
    
    _changeDatePressed = NO;
    _test = NO;
    _loadedSpecificView = NO;
    _pressedSearch = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    multiDialController = [[MultiDialViewController alloc] init];
    multiDialController.delegate = self;
    multiDialController.view.frame = CGRectOffset(multiDialController.view.frame, 0.0, 205.0);
    [self.view addSubview:multiDialController.view];
    [self.view sendSubviewToBack:multiDialController.view];
    //init
    [self switchPresetStrings:nil];
    
    _baseOffset = self.yearPicker.contentOffset.y;
    _offsetStep = 205*2 * floorf(self.yearPicker.bounds.size.height / 205*2);
    
    _goPressed = NO;
    _homeScroll.delegate = self;
    _homeScroll.clipsToBounds = YES;
    _homeScroll.alwaysBounceHorizontal = YES;
    _homeScroll.alwaysBounceVertical = NO;
    
    _priceScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-self.go.frame.size.height)];
    _priceScroll.clipsToBounds = YES;
    _priceScroll.alwaysBounceHorizontal = YES;
    _priceScroll.alwaysBounceVertical = NO;
    _priceScroll.pagingEnabled = YES;
    _priceScroll.hidden = YES;
    _priceScroll.showsHorizontalScrollIndicator = NO;
    ////////////
    _monthLabels = [[NSMutableArray alloc] init];
    _monthObjects = [[NSMutableArray alloc] init];
    _dayObjects = [[NSMutableArray alloc] init];
    _yearObjects = [[NSMutableArray alloc] init];
    
    newsArray = [[NSMutableArray alloc] init];
    
    _monthPicker.delegate = self;
    _dayPicker.delegate = self;
    _yearPicker.delegate = self;
    _yearPicker.clipsToBounds = YES;
    
    _dayPicker.alwaysBounceVertical = YES;
    _yearPicker.alwaysBounceVertical = YES;
    _monthPicker.alwaysBounceVertical = YES;
    
    _dayPicker.pagingEnabled = NO;
    _yearPicker.pagingEnabled = NO;
    _monthPicker.pagingEnabled = NO;
    
    [_monthLabels addObject:@"January"];
    [_monthLabels addObject:@"February"];
    [_monthLabels addObject:@"March"];
    [_monthLabels addObject:@"April"];
    [_monthLabels addObject:@"May"];
    [_monthLabels addObject:@"June"];
    [_monthLabels addObject:@"July"];
    [_monthLabels addObject:@"August"];
    [_monthLabels addObject:@"September"];
    [_monthLabels addObject:@"October"];
    [_monthLabels addObject:@"November"];
    [_monthLabels addObject:@"December"];
    
    [newsArray addObject:@"—"];
    [newsArray addObject:@"—"];
    [newsArray addObject:@"—"];
    [newsArray addObject:@"—"];
    [newsArray addObject:@"—"];
    [newsArray addObject:@"—"];
    
    _appleLabel = [[UILabel alloc]init];
    [_appleLabel setText:[NSString stringWithFormat:@"Apples"]];
    
    _bannanaLabel = [[UILabel alloc]init];
    [_bannanaLabel setText:[NSString stringWithFormat:@"Bannanas"]];
    
    _CoffeeLabel = [[UILabel alloc]init];
    [_CoffeeLabel setText:[NSString stringWithFormat:@"Coffee"]];
    
    _MilkLabel = [[UILabel alloc]init];
    [_MilkLabel setText:[NSString stringWithFormat:@"Milk"]];
    
    _EggLabel = [[UILabel alloc]init];
    [_EggLabel setText:[NSString stringWithFormat:@"Eggs"]];
    
    _OilLabel = [[UILabel alloc]init];
    [_OilLabel setText:[NSString stringWithFormat:@"Fuel Oil"]];
    
    _OJLabel = [[UILabel alloc]init];
    [_OJLabel setText:[NSString stringWithFormat:@"Orange Juice"]];
    
    _JobsLabel = [[UILabel alloc]init];
    [_JobsLabel setText:[NSString stringWithFormat:@"Unemployment"]];
    
    _appleUnit = [[UILabel alloc]init];
    [_appleUnit setText:[NSString stringWithFormat:@"per lb."]];
    
    _bannanaUnit = [[UILabel alloc]init];
    [_bannanaUnit setText:[NSString stringWithFormat:@"per lb."]];
    
    _CoffeeUnit = [[UILabel alloc]init];
    [_CoffeeUnit setText:[NSString stringWithFormat:@"per lb."]];
    
    _MilkUnit = [[UILabel alloc]init];
    [_MilkUnit setText:[NSString stringWithFormat:@"per gallon"]];
    
    _EggUnit = [[UILabel alloc]init];
    [_EggUnit setText:[NSString stringWithFormat:@"per dozen"]];
    
    _OilUnit = [[UILabel alloc]init];
    [_OilUnit setText:[NSString stringWithFormat:@"per gallon"]];
    
    _OJUnit = [[UILabel alloc]init];
    [_OJUnit setText:[NSString stringWithFormat:@"per 16 oz."]];
    
    _JobsUnit = [[UILabel alloc]init];
    [_JobsUnit setText:[NSString stringWithFormat:@"rate"]];
    
    _applesPrice = [[UILabel alloc]init];
    [_applesPrice setText:[NSString stringWithFormat:@"-"]];
    
    _bannanaPrice = [[UILabel alloc]init];
    [_bannanaPrice setText:[NSString stringWithFormat:@"-"]];
    
    _coffeePrice = [[UILabel alloc]init];
    [_coffeePrice setText:[NSString stringWithFormat:@"-"]];
    
    _eggsPrice = [[UILabel alloc]init];
    [_eggsPrice setText:[NSString stringWithFormat:@"-"]];
    
    _milkPrice = [[UILabel alloc]init];
    [_milkPrice setText:[NSString stringWithFormat:@"-"]];
    
    _oilPrice = [[UILabel alloc]init];
    [_oilPrice setText:[NSString stringWithFormat:@"-"]];
    
    _orange_juicePrice = [[UILabel alloc]init];
    [_orange_juicePrice setText:[NSString stringWithFormat:@"$-"]];
    
    _unemploymentPrice= [[UILabel alloc]init];
    [_unemploymentPrice setText:[NSString stringWithFormat:@"-"]];
    
    _priceLabelsL = [[NSMutableArray alloc] init];
    [_priceLabelsL addObject:_appleLabel];
    [_priceLabelsL addObject:_bannanaLabel];
    [_priceLabelsL addObject:_CoffeeLabel];
    [_priceLabelsL addObject:_MilkLabel];
    [_priceLabelsL addObject:_EggLabel];
    [_priceLabelsL addObject:_OilLabel];
    [_priceLabelsL addObject:_OJLabel];
    [_priceLabelsL addObject:_JobsLabel];
    
    _priceLabelsU = [[NSMutableArray alloc] init];
    
    
    [_priceLabelsU addObject:_appleUnit];
    [_priceLabelsU addObject:_bannanaUnit];
    [_priceLabelsU addObject:_CoffeeUnit];
    [_priceLabelsU addObject:_MilkUnit];
    [_priceLabelsU addObject:_EggUnit];
    [_priceLabelsU addObject:_OilUnit];
    [_priceLabelsU addObject:_OJUnit];
    [_priceLabelsU addObject:_JobsUnit];
    
    _priceLabelsP = [[NSMutableArray alloc] init];
    [_priceLabelsP addObject:_applesPrice];
    [_priceLabelsP addObject:_bannanaPrice];
    [_priceLabelsP addObject:_coffeePrice];
    [_priceLabelsP addObject:_milkPrice];
    [_priceLabelsP addObject:_eggsPrice];
    [_priceLabelsP addObject:_oilPrice];
    [_priceLabelsP addObject:_orange_juicePrice];
    [_priceLabelsP addObject:_unemploymentPrice];
    
    for (UILabel *label in _priceLabelsL){
        [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:24]];
        [label setTextColor:[UIColor whiteColor]];
    }
    for (UILabel *label in _priceLabelsU){
        [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:18]];
        [label setTextColor:[UIColor whiteColor]];
    }
    for (UILabel *label in _priceLabelsP){
        [label setFont:[UIFont fontWithName:@"Avenir-Roman" size:24]];
        [label setTextColor:[UIColor whiteColor]];
    }
    
    NSInteger viewcount= 9;
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _homeScroll.contentSize = CGSizeMake(self.view.frame.size.width*viewcount, 214);
    
    _homeScroll.backgroundColor = [UIColor clearColor];
    
    
    for (int i = 0; i< viewcount; i++) {
        
        CGFloat x = i * self.view.frame.size.width;
        
        UIButton *viewButton =[[UIButton alloc]initWithFrame:CGRectMake(x,0, self.view.frame.size.width, 214)];
        [viewButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"priceLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==1){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"sportsLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==2){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"internetLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==3){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"stockLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==4){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"weatherLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==5){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"newsLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==6){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"musicLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==7){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"priceLayer.png"]forState:UIControlStateNormal];
        }
        else if (i==8){
            viewButton.tag = i;
            [viewButton setBackgroundImage:[UIImage imageNamed:@"sportsLayer.png"]forState:UIControlStateNormal];
        }
        
        [_homeScroll addSubview:viewButton];
    }
    [_homeScroll scrollRectToVisible:CGRectMake(self.view.frame.size.width*1,0,self.view.frame.size.width,214) animated:NO];
    
    // Adjust scroll view content size, set background color and turn on paging
    int count = 2;
    
    _priceScroll.contentSize = CGSizeMake(self.view.frame.size.width*count, self.priceScroll.frame.size.height);
    _priceScroll.backgroundColor = [UIColor clearColor];
    
    for (int x = 0; x< count; x++) {
        UIView *views = [[UIView alloc]
                         initWithFrame:CGRectMake(((_priceScroll.frame.size.width)*x), 0, self.priceScroll.frame.size.width, self.priceScroll.frame.size.height)];
        if (x==0){
            for (int space = 0; space<4;space++){
                for (UILabel *label in _priceLabelsL){
                    if ([_priceLabelsL indexOfObject:label]==space){
                        [views addSubview:label];
                        label.frame = CGRectMake(31+_priceScroll.frame.size.width*x, 100+space*70, 160, 38);
                    }
                    
                }
                for (UILabel *label in _priceLabelsU){
                    if ([_priceLabelsU indexOfObject:label]==space){
                        [views addSubview:label];
                        label.frame = CGRectMake(31+_priceScroll.frame.size.width*x, 130+space*70, 160, 38);
                    }
                }
                for (UILabel *label in _priceLabelsP){
                    if ([_priceLabelsP indexOfObject:label]==space){
                        [views addSubview:label];
                        label.frame = CGRectMake(209+_priceScroll.frame.size.width*x, 100+space*70, 160, 38);
                    }
                }
            }
        }
        if (x==1){
            for (int space = 4; space<8;space++){
                for (UILabel *label in _priceLabelsL){
                    if ([_priceLabelsL indexOfObject:label]==space){
                        [views addSubview:label];
                        label.frame = CGRectMake(31, 100+(space-4)*70, 200, 38);
                    }
                }
                for (UILabel *label in _priceLabelsU){
                    if ([_priceLabelsU indexOfObject:label]==space){
                        [views addSubview:label];
                        label.frame = CGRectMake(31, 130+(space-4)*70, 200, 38);
                    }
                }
                for (UILabel *label in _priceLabelsP){
                    if ([_priceLabelsP indexOfObject:label]==space){
                        [views addSubview:label];
                        label.frame = CGRectMake(209, 100+(space-4)*70, 200, 38);
                    }
                }
            }
        }
        [_priceScroll addSubview:views];
    }
    [self.view addSubview:_priceScroll];

}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    NSLog(@"hitte");
    _newsWeb.hidden = NO;
    _urlInt = indexPath.section+1;
    NSURLRequest *myRequest = [self newsStoryRequest];
    [_newsWeb loadRequest:myRequest];
    [self.view bringSubviewToFront:_newsWeb];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Avenir" size:18.0]];
        
    }
    
    cell.textLabel.text = [newsArray objectAtIndex:indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this method is called for each cell and returns height
    NSString * text = @"                                                                      ";
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"Avenir" size:18.0] forWidth:[tableView frame].size.width - 40.0 lineBreakMode:UILineBreakModeWordWrap];
    // return either default height or height to fit the text
    return textSize.height < 44.0 ? 44.0 : textSize.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    [view setAlpha:0.0F];
    return view;
    
}

#pragma mark IBActions
-(UIStatusBarStyle)preferredStatusBarStyle{
    if (_searchON == NO){
        return UIStatusBarStyleLightContent;
    }
    else{
        return UIStatusBarStyleDefault;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{   ///timer for the progress view
    theBool = true;
}

-(void)dealloc
{
    newsTable.delegate=nil;
}

- (void)updateProgress:(NSTimer *)sender
{      //if the progress view is = 100% the progress stop
    if(_webProgress.progress==1.0)
    {
        [timer invalidate];
    }
    else
        //if the progress view is< 100% the progress increases
        _webProgress.progress+=0.5;
}
-(void)timerCallback {
    
    if (theBool) {
        if (_webProgress.progress >= 1) {
            _webProgress.hidden = true;
        }
        else {
            _webProgress.progress += 0.1;
        }
    }
    else {
        _webProgress.progress += 0.05;
        if (_webProgress.progress >= 0.95) {
            _webProgress.progress = 0.95;
        }
    }
}

- (void)switchPresetStrings:(id)sender {
    if ([(UISwitch *)sender isOn]) {
        multiDialController.presetStrings = [[NSArray alloc] initWithObjects:@"000B", @"000B", @"000B", @"000B", @"000B", nil];
    }
    else {
        multiDialController.presetStrings = nil;
        
    }
    self.presetStringsView.text = [NSString stringWithFormat:@"%@", multiDialController.presetStrings];
}
//

- (void)spinToRandom:(id)sender {
    [multiDialController spinToRandomString:NO];
}
-(void)setMyYear:(id)sender{
    //[multiDialController setMyYearLimit:sender];
    
}



//
#pragma mark MultiDialViewControllerDelegate methods

- (void)multiDialViewController:(MultiDialViewController *)controller didSelectString:(NSString *)string {
    self.selectedStringLabel.text = string;
}
//////////
////
///
///
///
//
//
//
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView ==_priceScroll){
    }
    else{
        CGFloat unguidedOffsetY = targetContentOffset->y;
        CGFloat guidedOffsetY;
        
        if (unguidedOffsetY > 250/3) {
            int remainder = lroundf(unguidedOffsetY) % lroundf(205/3);
            if (remainder < (205/3)) {
                guidedOffsetY = unguidedOffsetY - remainder;
            }
            else {
                guidedOffsetY = unguidedOffsetY - remainder + 205/3;
            }
        }
        else {
            guidedOffsetY = 0;
        }
        
        targetContentOffset->y = guidedOffsetY;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)webForward:(id)sender {
    if ([_internetView canGoForward]) {
        [_internetView goForward];
    }
    
}

- (IBAction)webBack:(id)sender {
    if ([_internetView canGoBack]) {
        [_internetView goBack];
    }
}

- (IBAction)forward:(id)sender {
}

- (IBAction)cancel:(id)sender {
    _newsWeb.hidden = YES;
    _cancelButton.hidden = YES;
    
}

- (IBAction)rewind:(id)sender {
}

- (IBAction)play:(id)sender {
    if (_playPressed == YES){
        UIImage * buttonImage = [UIImage imageNamed:@"pause.png"];
        [_playButton setImage:buttonImage forState:UIControlStateNormal];
        _playPressed = NO;
    }
    else{
        UIImage * buttonImage = [UIImage imageNamed:@"playButton.png"];
        [_playButton setImage:buttonImage forState:UIControlStateNormal];
        _playPressed = YES;
    }
}

- (IBAction)reload:(id)sender {
    [_internetView reload];
}

-(void) showAnimation{
    
    if (_goPressed == NO){
        [UIView animateWithDuration:0.5
                         animations:^{
                             _bottomBackground.frame = CGRectMake(0, 418, _bottomBackground.frame.size.width, _bottomBackground.frame.size.height);
                         }];
        _enter.hidden = NO;
        
        _go.hidden = YES;
        _goPressed = YES;
        
    }
    else if (_goPressed==YES){
        [UIView animateWithDuration:0.1
                         animations:^{
                             _bottomBackground.frame = CGRectMake(0, 213, _bottomBackground.frame.size.width, _bottomBackground.frame.size.height);
                         }];
        _enter.hidden = YES;
        _go.hidden = NO;
        _goPressed = NO;
        
        
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    CGFloat pageWidth = sender.frame.size.width;
    _pageNumber= floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if ([sender isEqual:_homeScroll]){
        if (_pageNumber==1){
            [_scrollBackground setImage:[UIImage imageNamed:@"background.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"bot.png"]];
        }
        else if (_pageNumber==2){
            [_scrollBackground setImage:[UIImage imageNamed:@"darkBlueBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"darkBlueBot.png"]];
            _searchBar.keyboardType = UIKeyboardTypeURL;
            _searchBar.placeholder = @"Enter URL e.g. cnn.com";
            
            //            int date = 1996;
            //            [multiDialController setMyYearLimit:date];
        }
        else if (_pageNumber==3){
            [_scrollBackground setImage:[UIImage imageNamed:@"purpleBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"purpleBot.png"]];
            _searchBar.placeholder = @"Enter Symbol e.g. AAPL";
            
            //            int date = 1980;
            //            [multiDialController setMyYearLimit:date];
            
        }
        else if (_pageNumber==4){
            [_scrollBackground setImage:[UIImage imageNamed:@"pinkBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"pinkBot.png"]];
            _searchBar.placeholder = @"Enter Zip Code e.g. 10022";
            
            //            int date = 1945;
            //            [multiDialController setMyYearLimit:date];
            
        }
        else if (_pageNumber==5){
            [_scrollBackground setImage:[UIImage imageNamed:@"greenBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"greenBot.png"]];
            //            int date = 1890;
            //            [multiDialController setMyYearLimit:date];
            
        }
        
        else if (_pageNumber==6){
            [_scrollBackground setImage:[UIImage imageNamed:@"orangeBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"orangeBot.png"]];
            //            int date = 1960;
            //            [multiDialController setMyYearLimit:date];
            
        }
        else if (_pageNumber==7){
            [_scrollBackground setImage:[UIImage imageNamed:@"redBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"redBot.png"]];
            //            int date = 1950;
            //            [multiDialController setMyYearLimit:date];
            
        }
        if (sender.contentOffset.x>=sender.frame.size.width*8-sender.frame.size.width/2){
            [_scrollBackground setImage:[UIImage imageNamed:@"background.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"bot.png"]];
        }
        if (sender.contentOffset.x==sender.frame.size.width*8.0){
            [self.homeScroll scrollRectToVisible:CGRectMake(self.view.frame.size.width*1,0,self.view.frame.size.width,214) animated:NO];
            
        }
        if (sender.contentOffset.x<=sender.frame.size.width/2){
            [_scrollBackground setImage:[UIImage imageNamed:@"redBackground.png"]];
            [_bottomBackground setImage:[UIImage imageNamed:@"redBot.png"]];
        }
        if (sender.contentOffset.x==0.0){
            [self.homeScroll scrollRectToVisible:CGRectMake(self.view.frame.size.width*7,0,self.view.frame.size.width,214) animated:NO];
            
            //            int date = 1960;
            //            [multiDialController setMyYearLimit:date];
            
        }
    }
    else if ([sender isEqual:_homeScroll]){
        _pricePageControl.currentPage = _pageNumber;
    }
}



- (IBAction)goButton:(id)sender {
    if (_start ==NO){
        [self showAnimation];
    }
    else{
        [self loadSearch];
    }
    _start = YES;
}
- (IBAction)enterButton:(id)sender {
    _homeScroll.scrollEnabled = NO;
    _test = YES;
    [self showAnimation];
    [self loadSearch];
}
-(void)loadSearch{
    _homeScroll.userInteractionEnabled = NO;
    _homeScroll.scrollEnabled = NO;
    _arrowLeft.hidden = YES;
    _arrowRight.hidden = YES;
    if (_pageNumber == 1||_pageNumber == 5||_pageNumber == 6|| _pageNumber==7){
        [self disableMainScreen];
        _changeSearchButton.enabled = NO;
        _changeSearchButton.hidden = YES;
        
    }
    else {
        CGRect rect = CGRectMake(0.0, 20.0, 320.0, 44.0);
        CGRect top = CGRectMake(0.0, 0.0, 320.0, 20.0);
        [UIView animateWithDuration:0.2 animations:^ {
            [_searchBar setFrame:rect];
            [_searchBar setNeedsLayout];
            
            [_searchTOp setFrame:top];
            [_searchTOp setNeedsLayout];
        }];
        _changeSearchButton.hidden = YES;
        _changeDateButton.hidden = YES;
        _homeButton.hidden = YES;
        [_searchBar becomeFirstResponder];
        self.homeScroll.alpha = 0.5;
        _searchON = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.homeScroll.alpha = 1.0;
    _pressedSearch = NO;
    _webProgress.progress = 0.0;
    _test = NO;
    CGRect rect = CGRectMake(0.0, -44.0, 320.0, 44.0);
    CGRect top = CGRectMake(0.0, -64.0, 320.0, 20.0);
    [UIView animateWithDuration:0.2 animations:^ {
        [_searchBar setFrame:rect];
        [_searchBar setNeedsLayout];
        
        [_searchTOp setFrame:top];
        [_searchTOp setNeedsLayout];
    }];
    [_searchBar resignFirstResponder];
    if (_loadedSpecificView==NO){
        [self disableMainScreen];
        _changeSearchButton.hidden = NO;
        
    }
    else{
        _go.hidden = YES;
        _arrowRight.hidden = YES;
        _arrowLeft.hidden = YES;
        _homeScroll.userInteractionEnabled = NO;
        _homeScroll.scrollEnabled = NO;
        _homeButton.hidden = NO;
        _changeDateButton.hidden = NO;
        _changeSearchButton.hidden = NO;
        _loadedSpecificView = YES;
        _canAnimate = YES;
    }
    _month = [multiDialController.dial1 selectedString];
    _day = [multiDialController.dial2 selectedString];
    _year = [multiDialController.dial3 selectedString];
    _searchTerm = [NSString stringWithFormat:@"%@",self.searchBar.text];
    _searchON = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [self createLabels];
    
    
    //    //where search term is saved as url to be used
    //    _url =[NSURL URLWithString:@" "];
    //    [self callUrl];
    
    
}
-(void)createLabels{
    //fix height
    [self.view removeGestureRecognizer:tap];
    
    CGRect frame = _bottomBar.frame;
    frame.origin.x = 0;
    frame.origin.y = self.view.frame.size.height-62;
    _bottomBar.frame = frame;
    _bottomBar.hidden = NO;
    
    _topBar.hidden = NO;
    
    _internetView.frame = CGRectMake(_internetView.frame.origin.x, _internetView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-133.0);
    
    
    //_categoryLabel.hidden = NO;
    
    if (_pageNumber==1){
        [_categoryLabel setText:[NSString stringWithFormat:@"Sports"]];
        _sportsBack.hidden = NO;
        [self performAnimationOnViewDown:_sportsBack duration:0.3 delay:0.0];
        _searchON = YES;
        [_homeButton setImage:[UIImage imageNamed:@"homeImageDark.png"] forState:UIControlStateNormal];
        [_changeDateButton setImage:[UIImage imageNamed:@"dateImageDark.png"] forState:UIControlStateNormal];
        [_changeSearchButton setImage:[UIImage imageNamed:@"searchImageDark.png"] forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else if(_pageNumber==2){
        [_categoryLabel setText:[NSString stringWithFormat:@"Internet"]];
        _internetView.hidden = NO;
        _searchBar.keyboardType = UIKeyboardTypeURL;
        _internetForward.hidden = NO;
        _internetBack.hidden = NO;
        _internetReload.hidden = NO;
        _webProgress.hidden = NO;
        NSURLRequest *myRequest = [self theRequest];
        [_internetView loadRequest:myRequest];
        
    }
    else if (_pageNumber==3){
        [_categoryLabel setText:[NSString stringWithFormat:@"Stocks"]];
        [self stockRequest];
        _stocksBack.hidden = NO;
        for (UIImageView *line in _stockLine){
            line.hidden = NO;
            [self performAnimationOnView:line duration:0.3 delay:0.5];
        }
        [self performAnimationOnViewDown:_stocksBack duration:0.3 delay:0.0];
        _stockData.hidden = NO;
        [self performAnimationOnView:_stockData duration:0.3 delay:0.5];
        
        
    }
    else if (_pageNumber==4){
        [_categoryLabel setText:[NSString stringWithFormat:@"Weather"]];
        _weatherBack.hidden = NO;
        [self performAnimationOnViewDown:_weatherBack duration:0.3 delay:0.0];
        
        
        if (_onlyOnce == YES){
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.fromValue = [NSNumber numberWithFloat:0];
            rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
            rotation.duration = 5.0; // Speed
            rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
            [_windImage.layer addAnimation:rotation forKey:@"Spin"];
            _onlyOnce = NO;
        }
        
        _weatherTemperatureHighLabel.hidden=NO;
        _weatherTemperatureLowLabel.hidden=NO;
        [self performAnimationOnViewSlide:_weatherTemperatureHighLabel duration:0.7 delay:0.2];
        [self performAnimationOnViewSlide:_weatherTemperatureLowLabel duration:0.7 delay:0.2];
        
        
        _weatherLocationLabel.hidden=NO;
        [self performAnimationOnViewDown:_weatherLocationLabel duration:0.7 delay:0.2];
        
        
        _weatherWindLabel.hidden = NO;
        _windImage.hidden = NO;
        _windImageBase.hidden = NO;
        [self performAnimationOnViewSlide:_weatherWindLabel duration:0.7 delay:0.2];
        [self performAnimationOnViewSlide:_windImage duration:0.7 delay:0.2];
        [self performAnimationOnViewSlide:_windImageBase duration:0.7 delay:0.2];
        
        
        _weatherTypeImage.hidden = NO;
        [self performAnimationOnView:_weatherTypeImage duration:0.7 delay:0.2];
        
    }
    else if (_pageNumber==5){
        [_categoryLabel setText:[NSString stringWithFormat:@"News"]];
        [self newsRequest];
        [_categoryLabel setTextColor:[UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:49.0f/255.0f alpha:1.0f]];
        _categoryLabel.hidden = NO;
        [_homeButton setImage:[UIImage imageNamed:@"homeImageDark.png"] forState:UIControlStateNormal];
        [_changeDateButton setImage:[UIImage imageNamed:@"dateImageDark.png"] forState:UIControlStateNormal];
        _searchON = YES;
        newsTable.hidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else if (_pageNumber==6){
        [_categoryLabel setText:[NSString stringWithFormat:@"Music"]];
        _musicBack.hidden = NO;
        [self musicRequest];
        [self performAnimationOnViewDown:_musicBack duration:0.3 delay:0.0];
        
        [_homeButton setImage:[UIImage imageNamed:@"homeImageDark.png"] forState:UIControlStateNormal];
        [_changeDateButton setImage:[UIImage imageNamed:@"dateImageDark.png"] forState:UIControlStateNormal];
        
        
        _albumCover.hidden = NO;
        [self performAnimationOnView:_albumCover duration:0.7 delay:0.5];
        [self performAnimationOnView:_circleCover duration:0.7 delay:0.5];
        
        _songName.hidden = NO;
        [self performAnimationOnView:_songName duration:0.7 delay:0.5];
        [self performAnimationOnView:_albumName duration:0.7 delay:0.5];
        
        _artistName.hidden = NO;
        [self performAnimationOnView:_artistName duration:0.7 delay:0.5];
        
        _searchON = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else if (_pageNumber==7){
        [_categoryLabel setText:[NSString stringWithFormat:@"Price Index"]];
        _priceBack.hidden = NO;
        _priceScroll.hidden = NO;
        [self priceRequest];
        [self performAnimationOnViewDown:_priceScroll duration:0.3 delay:0.0];
        [self performAnimationOnViewDown:_priceBack duration:0.3 delay:0.0];
        _priceData.hidden = NO;
        [self performAnimationOnView:_priceData duration:0.3 delay:0.5];
        _priceScroll.scrollEnabled = YES ;
        
    }
    _canAnimate =NO;
    _animatedHappened = YES;
    
    _changeDateButton.center = CGPointMake(_changeDateButton.frame.origin.x+self.changeDateButton.frame.size.width/2, self.view.frame.size.height-52+self.changeDateButton.frame.size.height/2);
    _changeSearchButton.center = CGPointMake(_changeSearchButton.frame.origin.x+self.changeSearchButton.frame.size.width/2, self.view.frame.size.height-52+self.changeSearchButton.frame.size.height/2);
    _homeButton.center = CGPointMake(_homeButton.frame.origin.x+self.homeButton.frame.size.width/2, self.view.frame.size.height-52+self.homeButton.frame.size.height/2);
}
#pragma animations
- (void)performAnimationOnView:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    if (_animatedHappened ==NO){
        // Start
        view.alpha = 0;
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            // End
            view.alpha = 1;
            
        } completion:^(BOOL finished) { }];
    }
    else{
        
    }
}
- (void)performAnimationOnViewSlide:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    if (_animatedHappened ==NO){
        // Start
        CGRect frame = view.frame;
        view.frame = CGRectMake(620, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            // End
            view.frame = frame;
        } completion:^(BOOL finished) { }];
    }
    else{
        
    }
}
- (void)performAnimationOnViewDown:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
    
    if (_animatedHappened ==NO){
        // Start
        CGRect frame = view.frame;
        view.frame = CGRectMake(view.frame.origin.y, -300, view.frame.size.width, view.frame.size.height);
        [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
            // End
            view.frame = frame;
        } completion:^(BOOL finished) { }];
    }
    else{
        
    }
}


-(void)clearLabels{
    [self.view addGestureRecognizer:tap];
    _searchON = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    _sportsBack.hidden = YES;
    _priceData.hidden = YES;
    _priceScroll.hidden = YES;
    _priceBack.hidden = YES;
    for (UIImageView *line in _stockLine){
        line.hidden = YES;
        
    }
    // _priceScroll.scrollEnabled = NO;
    newsTable.hidden = YES;
    _newsWeb.hidden = YES;
    
    _bottomBar.hidden = YES;
    _topBar.hidden = YES;
    _categoryLabel.hidden = YES;
    
    _stockData.hidden = YES;
    _stocksBack.hidden = YES;
    
    _weatherBack.hidden = YES;
    _weatherTemperatureHighLabel.hidden=YES;
    _weatherTemperatureLowLabel.hidden=YES;
    _weatherLocationLabel.hidden=YES;
    _weatherTypeImage.hidden = YES;
    _weatherWindLabel.hidden = YES;
    _windImage.hidden = YES;
    _windImageBase.hidden = YES;
    
    _internetView.hidden = YES;
    _internetForward.hidden = YES;
    _internetBack.hidden = YES;
    _internetReload.hidden = YES;
    _webProgress.hidden = YES;
    
    _musicBack.hidden = YES;
    _playButton.hidden = YES;
    _rewindButton.hidden = YES;
    _fastforwardButton.hidden = YES;
    _albumCover.hidden = YES;
    _songName.hidden = YES;
    _albumName.hidden = YES;
    _circleCover.hidden = YES;
    _artistName.hidden = YES;
    _musicProgress.hidden = YES;
    _cancelButton.hidden = YES;
    [_homeButton setImage:[UIImage imageNamed:@"homeImage.png"] forState:UIControlStateNormal];
    [_changeDateButton setImage:[UIImage imageNamed:@"dateImage.png"] forState:UIControlStateNormal];
    [_changeSearchButton setImage:[UIImage imageNamed:@"searchImage.png"] forState:UIControlStateNormal];
    
    
}

-(void) disableMainScreen{
    [self createLabels];
    UIButton *button;
    for (UIView* view in [self.homeScroll subviews]){
        if ([view isKindOfClass:[UIButton class]]){
            button = (UIButton*)view;
        }
        if (button.tag == _pageNumber){
            [UIView animateWithDuration:0.2 animations:^ {
                button.frame = CGRectMake(button.frame.origin.x, -250.0, button.frame.size.width, button.frame.size.height);
            }];
        }
        else{
            button.hidden = YES;
        }
    }
    [self changeTopTo];
    _go.hidden = YES;
    _arrowRight.hidden = YES;
    _arrowLeft.hidden = YES;
    _homeScroll.userInteractionEnabled = NO;
    _homeScroll.scrollEnabled = NO;
    _homeButton.hidden = NO;
    _changeDateButton.hidden = NO;
    _loadedSpecificView = YES;
    _canAnimate = NO;
}

-(NSURLRequest*)theRequest{
    //internet
    
    NSString *myTerm = self.searchBar.text;
    
    NSString *month = [NSString stringWithFormat:@"%.2d",[_monthLabels indexOfObject:multiDialController.dial1.selectedString]+1];
    
    NSString *year= multiDialController.dial3.selectedString;
    NSString *day = multiDialController.dial2.selectedString;
    
    _urlAddress = [NSString stringWithFormat:@"http://web.archive.org/web/%@%@%@id_/http://www.%@",year,month,day,myTerm];
    NSURL *url = [NSURL URLWithString:_urlAddress];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    ///timer for the progress view
    _webProgress.progress = 0;
    theBool = false;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    return request;
    
}

-(NSURLRequest*)newsStoryRequest{
    NSString *month = [NSString stringWithFormat:@"%.2d",[_monthLabels indexOfObject:multiDialController.dial1.selectedString]+1];
    
    NSString *year= multiDialController.dial3.selectedString;
    NSString *day = multiDialController.dial2.selectedString;
    
    //stocks
    _urlAddress = [NSString stringWithFormat:@"http://chronos-backend.herokuapp.com/news/?month=%@&year=%@&day=%@",month,year,day];
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSURL *url = [NSURL URLWithString:_urlAddress];
    NSData * data=[NSData dataWithContentsOfURL:url];
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *info = [parser objectWithString:json_string error:nil];
    NSLog(@"%@",info);
    NSString *inf = [NSString stringWithFormat:@"%ld",_urlInt];
    NSString *myTerm = [NSString stringWithFormat:@"%@",[[info objectForKey:inf]objectForKey:@"url"]];
    _newsUrl = [NSString stringWithFormat:@"%@",myTerm];
    url = [NSURL URLWithString:_newsUrl];
    _cancelButton.hidden = NO;
    _newsStoryRequest = [[NSURLRequest alloc] initWithURL:url];
    return _newsStoryRequest;
    
}

-(void)stockRequest{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *cDay = [NSString stringWithFormat:@"%i",[components day]-1];
    NSString *cMonth = [NSString stringWithFormat:@"%i",[components month]];
    NSString *cYear = [NSString stringWithFormat:@"%i",[components year]];
    NSString *myTerm = self.searchBar.text;
    
    NSString *month = [NSString stringWithFormat:@"%.2d",[_monthLabels indexOfObject:multiDialController.dial1.selectedString]+1];
    
    NSString *year= multiDialController.dial3.selectedString;
    NSString *day = multiDialController.dial2.selectedString;
    
    //stocks
    _urlAddress = [NSString stringWithFormat:@"http://chronos-backend.herokuapp.com/stocks/%@/quote/?month=%@&year=%@&day=%@",myTerm,month,year,day];
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSLog(@"before request %@", _urlAddress);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]];
    NSLog(@"after request");
    // Perform request and get JSON back as a NSData object'
    _dailyChange.text = @"";
    _changeToday.text = @"";
    _stockTerm.text = @"—";
    _open.text = @"—";
    _close.text = @"—";
    _adjClose.text = @"—";
    _high.text = @"—";
    _low.text = @"—";
    _volume.text = @"—";
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               
                               NSLog(@"before response");
                               NSLog(@"after response");
                               // Get JSON as a NSString from NSData response
                               NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               
                               NSDictionary *info = [parser objectWithString:json_string error:nil];
                               NSLog(@"%@",info);
                               NSLog(@"step");
                               
                               _stockTerm.text = myTerm.uppercaseString;
                               _open.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"Open"]];
                               _close.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"Close"]];
                               _adjClose.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"Adj Close"]];
                               _high.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"High"]];
                               _low.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"Low"]];
                               _volume.text = [NSString stringWithFormat:@"%.2dM",[[NSString stringWithFormat:@"%@",[info objectForKey:@"Volume"]] integerValue]/1000000];
                               
                               float dClose = [[info objectForKey:@"Close"] floatValue];
                               float dOpen = [[info objectForKey:@"Open"] floatValue];
                               float dChange = dClose - dOpen;
                               
                               _dailyChange.text = [NSString stringWithFormat:@" %.2f ",dChange];
                               if (dChange>=0){
                                   [_dailyChange setBackgroundColor:[UIColor colorWithRed:104.0/255.0f green:189.0/255.0f blue:112.0/255.0f alpha:1.0]];
                                   [_dailyChange setText:[NSString stringWithFormat:@" +%.2f ",dChange]];
                                   
                               }
                               else{
                                   dChange=dChange*-1.0;
                                   _dailyChange.text = [NSString stringWithFormat:@" – %.2f ",dChange];
                                   [_dailyChange setBackgroundColor:[UIColor colorWithRed:211.0f/255.0f green:122.0f/255.0f blue:134.0f/255.0f alpha:1.0]];
                               }
                               
                               
                               _urlAddress = [NSString stringWithFormat:@"http://chronos-backend.herokuapp.com/stocks/%@/quote/?month=%@&year=%@&day=%@",myTerm,cMonth,cYear,cDay];
                               SBJsonParser *cParser = [[SBJsonParser alloc]init];
                               NSLog(@"before request2");
                               NSURLRequest *cRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]];
                               // Perform request and get JSON back as a NSData object
                               NSLog(@"after request2");
                               NSLog(@"before response2");
                               NSData *cResponse = [NSURLConnection sendSynchronousRequest:cRequest returningResponse:nil error:nil];
                               NSLog(@"after response2");
                               
                               // Get JSON as a NSString from NSData response
                               NSString *cJson_string = [[NSString alloc] initWithData:cResponse encoding:NSUTF8StringEncoding];
                               NSDictionary *cInfo = [cParser objectWithString:cJson_string error:nil];
                               float close = [[cInfo objectForKey:@"Close"] floatValue];
                               float cChange = (close - [[info objectForKey:@"Adj Close"] floatValue]);
                               _changeToday.text = [NSString stringWithFormat:@" %.2f ",cChange];
                               if (cChange>=0){
                                   [_changeToday setBackgroundColor:[UIColor colorWithRed:104.0/255.0f green:189.0/255.0f blue:112.0/255.0f  alpha:1.0]];
                                   [_changeToday setText:[NSString stringWithFormat:@" +%.2f ",cChange]];
                               }
                               else{
                                   cChange = cChange*-1.0;
                                   _changeToday.text = [NSString stringWithFormat:@" – %.2f ",cChange];
                                   [_changeToday setBackgroundColor:[UIColor colorWithRed:211.0f/255.0f green:122.0f/255.0f blue:134.0f/255.0f alpha:1.0]];
                               }
                               _dailyChange.hidden=NO;
                               
                               
                           }];
}

-(void)priceRequest{
    NSString *month = [NSString stringWithFormat:@"%.2d",[_monthLabels indexOfObject:multiDialController.dial1.selectedString]+1];
    NSString *year= multiDialController.dial3.selectedString;
    NSArray * products = [[NSArray alloc] initWithObjects: @"apples",@"bannanas",@"coffee",@"eggs",@"milk",@"oil",@"orange_juice",@"unemployment", nil];
    int iteratingNum = 0;
    for (NSString *product in products){
        _urlAddress = [NSString stringWithFormat:@"http://chronos-backend.herokuapp.com/bls/%@/price/?month=%@&year=%@",product, month,year];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSLog(@"before request %@", _urlAddress);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   NSDictionary *info = [parser objectWithString:json_string error:nil];
                                   NSLog(@"%@",info);
                                   for (UILabel *label in _priceLabelsP){
                                       if ([_priceLabelsP indexOfObject: label] == iteratingNum){
                                           NSString *value = [NSString stringWithFormat:@"%@",[info objectForKey:@"averagePrice"]];
                                           float val = [value floatValue];
                                           if (iteratingNum<7){
                                               value = [NSString stringWithFormat:@"$%.02f",val];
                                           }
                                           else{
                                               value = [NSString stringWithFormat:@" %.02f",val];
                                           }
                                           label.text = value;
                                           if (label.text ==(id)[NSNull null]||label.text.length == 0) label.text =@"Unavailble";
                                       }
                                       
                                   }
                               }];
        iteratingNum+=1;
    }
}
-(void)newsRequest{
    NSString *month = [NSString stringWithFormat:@"%.2d",[_monthLabels indexOfObject:multiDialController.dial1.selectedString]+1];
    
    NSString *year= multiDialController.dial3.selectedString;
    NSString *day = multiDialController.dial2.selectedString;
    
    //stocks
    _urlAddress = [NSString stringWithFormat:@"http://chronos-backend.herokuapp.com/news/?month=%@&year=%@&day=%@",month,year,day];
    NSLog(@"%@", _urlAddress);
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSDictionary *info = [parser objectWithString:json_string error:nil];
                               NSLog(@"%@",info);
                               NSLog(@"sections: %i",[newsTable numberOfSections]);
                               NSLog(@"rows in section 0: %i",[newsTable numberOfRowsInSection:0]);
                               NSLog(@"cell: %@",[newsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]);
                               for (NSInteger i = 0; i <= 7; ++i)
                               {
                                   NSString *inf = [NSString stringWithFormat:@"%i",i+1];
                                   [newsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]].textLabel.text = [NSString stringWithFormat:@"%@",[[info objectForKey:inf]objectForKey:@"title"]];
                                   
                                   newsArray[i]=[NSString stringWithFormat:@"%@",[[info objectForKey:inf]objectForKey:@"title"]];
                                   NSLog(@"cell text: %@",[newsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]].textLabel.text);
                               }
                               
                           }];
}
-(void)musicRequest{
    
    NSString *month = [NSString stringWithFormat:@"%.2d",[_monthLabels indexOfObject:multiDialController.dial1.selectedString]+1];
    
    NSString *year= multiDialController.dial3.selectedString;
    NSString *day = multiDialController.dial2.selectedString;
    
    //stocks
    _urlAddress = [NSString stringWithFormat:@"http://chronos-backend.herokuapp.com/music/?month=%@&year=%@&day=%@",month,year,day];
    NSLog(@"%@", _urlAddress);
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlAddress]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               
                               NSDictionary *info = [parser objectWithString:json_string error:nil];
                               
                               _artistName.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"artist"]];
                               _songName.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"song"]];
                               
                               NSString* artistTerm = [_artistName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                               NSString* songTerm = [_songName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                               NSError *err = [[NSError alloc] init];
                               NSString *myRequest = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@%@&max-results=1&alt=json&format=5",songTerm, artistTerm];
                               NSURL *url = [NSURL URLWithString:myRequest];
                               NSString *myYouTubeData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
                               
                               
                               
                               NSDictionary *infoVideo = [parser objectWithString:myYouTubeData error:nil];
                               NSString* videoUrl = [[[[[[[infoVideo objectForKey:@"feed"]
                                                          objectForKey:@"entry"] objectAtIndex:0] objectForKey:@"media$group"]objectForKey:@"media$content"]objectAtIndex:0]objectForKey:@"url"];
                               NSArray *array = [videoUrl componentsSeparatedByString:@"v"];
                               videoUrl= [NSString stringWithFormat:@"%@embed%@",array[0],array[1]];
                               NSURL *youtubeUrl = [NSURL URLWithString:videoUrl];
                               _youtubeRequest = [[NSURLRequest alloc] initWithURL:youtubeUrl];
                               NSLog(@"beforeUrl %@", _youtubeRequest);
                               [_albumCover loadRequest:_youtubeRequest];
                               
                               if(err.code != 0) {
                                   //HANDLE ERROR HERE
                               }
                               
                               //Do Something with myYouTubeData here
                           }];
}

-(void) enableMainScreen{
    [self clearLabels];
    UIButton *button;
    for (UIView* view in [self.homeScroll subviews]){
        if ([view isKindOfClass:[UIButton class]]){
            button = (UIButton*)view;
            
        }
        if (button.tag == _pageNumber){
            
            [UIView animateWithDuration:0.2 animations:^ {
                button.frame = CGRectMake(button.frame.origin.x, 0.0, button.frame.size.width, button.frame.size.height);
                
            }];
            
        }
        else{
            button.hidden = NO;
        }
        
    }
    for (CSAnimationView *animation in _animationsAdded){
        animation.hidden = YES;
    }
    [_animationsAdded removeAllObjects];
    
    [self changeTopFrom];
    _go.hidden = NO;
    _arrowRight.hidden = NO;
    _arrowLeft.hidden = NO;
    _homeScroll.userInteractionEnabled = YES;
    _homeScroll.scrollEnabled = YES;
    _homeButton.hidden = YES;
    _changeSearchButton.hidden = YES;
    _changeDateButton.hidden = YES;
    _loadedSpecificView = NO;
}



-(void)changeTopTo{
    if (_pageNumber == 2){
        [_scrollBackground setImage:[UIImage imageNamed:@"darkBlue.png"]];
        
    }  else if (_pageNumber == 3){
        [_scrollBackground setImage:[UIImage imageNamed:@"purple.png"]];
        
        
    }  else if (_pageNumber == 4){
        [_scrollBackground setImage:[UIImage imageNamed:@"pink.png"]];
        
        
    }  else if (_pageNumber == 5){
        [_scrollBackground setImage:[UIImage imageNamed:@"green.png"]];
        
        
    }  else if (_pageNumber == 6){
        [_scrollBackground setImage:[UIImage imageNamed:@"orange.png"]];
        
    }  else if (_pageNumber == 7){
        [_scrollBackground setImage:[UIImage imageNamed:@"red.png"]];
        
        
    }  else if (_pageNumber == 0){
        [_scrollBackground setImage:[UIImage imageNamed:@"blue.png"]];
        
    }
    else if (_pageNumber == 1){
        [_scrollBackground setImage:[UIImage imageNamed:@"blue.png"]];
        
    }
    
    
}
-(void)changeTopFrom{
    if (_pageNumber == 2){
        [_scrollBackground setImage:[UIImage imageNamed:@"darkBlueBackground.png"]];
        
    }  else if (_pageNumber == 3){
        [_scrollBackground setImage:[UIImage imageNamed:@"purpleBackground.png"]];
        
        
    }  else if (_pageNumber == 4){
        [_scrollBackground setImage:[UIImage imageNamed:@"pinkBackground.png"]];
        
        
    }  else if (_pageNumber == 5){
        [_scrollBackground setImage:[UIImage imageNamed:@"greenBackground.png"]];
        
        
    }  else if (_pageNumber == 6){
        [_scrollBackground setImage:[UIImage imageNamed:@"orangeBackground.png"]];
        
    }  else if (_pageNumber == 7){
        [_scrollBackground setImage:[UIImage imageNamed:@"redBackground.png"]];
        
    }  else if (_pageNumber == 1){
        [_scrollBackground setImage:[UIImage imageNamed:@"background.png"]];
        
    }  else if (_pageNumber == 0){
        [_scrollBackground setImage:[UIImage imageNamed:@"redbackground.png"]];
        
        
        
    }
}
- (void)didTapButton:(UIButton *)button{
    if (_test==NO){
        [self showAnimation];
    }
    
}

-(void)dismissKeyboard{
    _searchON = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    if (_loadedSpecificView == NO){
        _arrowRight.hidden = NO;
        _arrowLeft.hidden = NO;
        _changeSearchButton.hidden = YES;
        _changeDateButton.hidden = YES;
        _homeButton.hidden = YES;
        _homeScroll.userInteractionEnabled = YES;
        _homeScroll.scrollEnabled = YES;
    }
    _test =NO;
    self.homeScroll.alpha = 1.0;
    [_searchBar resignFirstResponder];
    CGRect rect = CGRectMake(0.0, -44.0, 320.0, 44.0);
    CGRect top = CGRectMake(0.0, -64.0, 320.0, 20.0);
    [UIView animateWithDuration:0.2 animations:^ {
        [_searchBar setFrame:rect];
        [_searchBar setNeedsLayout];
        
        [_searchTOp setFrame:top];
        [_searchTOp setNeedsLayout];
    }];
    if (_loadedSpecificView == YES && (_pageNumber == 1||_pageNumber == 2||_pageNumber == 3||_pageNumber == 4)){
        [self createLabels];
        if (_changeDatePressed == YES){
            _changeSearchButton.hidden = YES;
            _changeDateButton.hidden = YES;
            _homeButton.hidden = YES;
            [self clearLabels];
        }
        else{
            _changeSearchButton.hidden = NO;
            _changeDateButton.hidden = NO;
            _homeButton.hidden = NO;
        }
    }
}


- (IBAction)arrowRight:(id)sender {
    
    if (_homeScroll.contentOffset.x/_pageNumber ==_homeScroll.frame.size.width||_homeScroll.contentOffset.x==0){
        
        [_homeScroll setContentOffset:CGPointMake(_homeScroll.contentOffset.x+_homeScroll.frame.size.width, _homeScroll.contentOffset.y) animated:YES];
    }
    
}
- (IBAction)arrowLeft:(id)sender {
    
    if (_homeScroll.contentOffset.x/_pageNumber ==_homeScroll.frame.size.width){
        [_homeScroll setContentOffset:CGPointMake(_homeScroll.contentOffset.x-_homeScroll.frame.size.width, _homeScroll.contentOffset.y) animated:YES];
    }
}
- (IBAction)goHome:(id)sender {
    if (_changeDatePressed==NO){
        [self clearLabels];
        _searchBar.text = @"";
        [self enableMainScreen];
        _changeSearchButton.enabled = YES;
        _canAnimate = YES;
        _animatedHappened = NO;
    }
    
}

- (IBAction)changeSearch:(id)sender {
    [self clearLabels];
    _pressedSearch = YES;
    _changeSearchButton.hidden = YES;
    _changeDateButton.hidden = YES;
    _cancelButton.hidden = YES;
    _homeButton.hidden = YES;
    _homeScroll.userInteractionEnabled = NO;
    _homeScroll.scrollEnabled = NO;
    _canAnimate = YES;
    _animatedHappened = NO;
    [self loadSearch];
}

- (IBAction)changeDate:(id)sender {
    _searchON = YES;
    if (_loadedSpecificView == YES){
        _confirmButton.hidden = NO;
        _changeDateImage.hidden = NO;
        _clockHand.hidden = NO;
        [self clearLabels];
        _changeSearchButton.hidden = YES;
        _changeDateButton.hidden = YES;
        _homeButton.hidden = YES;
        _changeDatePressed = YES;
        _canAnimate = YES;
        _cancelButton.hidden = YES;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _bottomBackground.frame = CGRectMake(0, 418, _bottomBackground.frame.size.width, _bottomBackground.frame.size.height);
                         }];
        NSLog(@"confirm presssed");
        
        _clockHand.center=CGPointMake(164,114);
        CABasicAnimation *rotation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation2.fromValue = [NSNumber numberWithFloat:0];
        rotation2.toValue = [NSNumber numberWithFloat:(2*M_PI)];
        rotation2.duration = 3.0; // Speed
        rotation2.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
        [_clockHand.layer addAnimation:rotation2 forKey:@"Spin"];
        _animatedHappened = NO;
        
    }
}

- (IBAction)confirm:(id)sender {
    [self createLabels];
    _changeDateImage.hidden = YES;
    _clockHand.hidden = YES;
    _changeDatePressed = NO;
    _confirmButton.hidden = YES;
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         _bottomBackground.frame = CGRectMake(0, 213, _bottomBackground.frame.size.width, _bottomBackground.frame.size.height);
                     }];
    if (_pageNumber == 5||_pageNumber==6||_pageNumber==7){
        _changeSearchButton.hidden = YES;
        [self createLabels];
    }
    else{
        _changeSearchButton.hidden = NO;
    }
    _changeDateButton.hidden = NO;
    _homeButton.hidden = NO;
    _start = YES;
    
    
}
@end
