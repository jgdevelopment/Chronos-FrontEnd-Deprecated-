//
//  ViewController.h
//  past time
//
//  Created by Jason Ginsberg on 7/8/13.
//  Copyright (c) 2013 Jason Ginsberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiDialViewController.h"
#import "AFNetworking.h"
#import "SBJSON.h"
#import "CSAnimation.h"
#import "CSAnimationView.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, UISearchBarDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, MultiDialViewControllerDelegate>{
    MultiDialViewController *multiDialController;
    BOOL theBool;
    NSTimer *myTimer;
    NSMutableArray *newsArray;
    IBOutlet UITableView *newsTable;

}
@property  NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *allPickView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *stocksBack;
@property (weak, nonatomic) IBOutlet UIImageView *priceBack;
@property (weak, nonatomic) IBOutlet UIImageView *sportsBack;
@property (weak, nonatomic) IBOutlet UIImageView *weatherBack;
@property (weak, nonatomic) IBOutlet UIImageView *musicBack;
@property (weak, nonatomic) IBOutlet UIScrollView *monthPicker;
@property (weak, nonatomic) IBOutlet UIScrollView *dayPicker;
@property (weak, nonatomic) IBOutlet UIScrollView *yearPicker;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBackground;
@property (weak, nonatomic) IBOutlet UIScrollView *homeScroll;
@property (nonatomic) IBOutlet NSMutableArray *monthLabels;
@property (nonatomic) IBOutlet NSMutableArray *monthObjects;
@property (nonatomic) IBOutlet NSMutableArray *dayObjects;
@property (nonatomic) IBOutlet NSMutableArray *yearObjects;
@property (nonatomic) IBOutlet NSMutableArray *animationsAdded;
@property (nonatomic) IBOutlet NSMutableArray *priceLabelsL;
@property (nonatomic) IBOutlet NSMutableArray *priceLabelsP;
@property (nonatomic) IBOutlet NSMutableArray *priceLabelsU;
@property (weak, nonatomic) IBOutlet UIWebView *newsWeb;

@property (nonatomic, retain) IBOutlet UITableView *monthTable;

@property (weak, nonatomic) IBOutlet UIImageView *scrollBackground;
@property (weak, nonatomic) IBOutlet UIImageView *searchTOp;
@property (nonatomic, retain) IBOutlet UITextView *presetStringsView;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (nonatomic, retain) IBOutlet UILabel *selectedStringLabel;
@property (nonatomic, retain) IBOutlet UILabel *weatherLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *weatherTemperatureHighLabel;
@property (nonatomic, retain) IBOutlet UILabel *weatherTemperatureLowLabel;
@property (nonatomic, retain) IBOutlet UIImageView *weatherTypeImage;
@property (nonatomic, retain) IBOutlet UILabel *weatherWindLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windImage;
@property (weak, nonatomic) IBOutlet UIImageView *windImageBase;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *changeDateImage;
@property (weak, nonatomic) IBOutlet UIImageView *clockHand;
@property (weak, nonatomic) IBOutlet UIButton *enter;
@property (weak, nonatomic) IBOutlet UIButton *go;

@property (weak, nonatomic) IBOutlet UIButton *arrowRight;
@property (weak, nonatomic) IBOutlet UIButton *arrowLeft;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *changeSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *changeDateButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *fastforwardButton;
@property (weak, nonatomic) IBOutlet UIButton *rewindButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *internetBack;
@property (weak, nonatomic) IBOutlet UIButton *internetForward;
@property (weak, nonatomic) IBOutlet UIButton *internetReload;
@property (weak, nonatomic) IBOutlet NSURL *url;
@property (weak, nonatomic) IBOutlet NSString *searchTerm;
@property (weak, nonatomic) IBOutlet NSString *month;
@property (weak, nonatomic) IBOutlet NSString *newsUrl;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stockLine;
@property (weak, nonatomic) IBOutlet NSString *day;
@property (weak, nonatomic) IBOutlet NSString *year;
@property (weak, nonatomic) IBOutlet NSString *urlAddress;
@property (weak, nonatomic) IBOutlet UIWebView *internetView;
@property (nonatomic) IBOutlet NSURLRequest *newsStoryRequest;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBar;
@property long *urlInt;
@property (weak, nonatomic) IBOutlet UIImageView *topBar;
@property (weak, nonatomic) IBOutlet UIWebView *albumCover;
@property (weak, nonatomic) IBOutlet UIImageView *circleCover;
@property (weak, nonatomic) IBOutlet UIView *stockData;
@property (weak, nonatomic) IBOutlet UIView *priceData;
@property (weak, nonatomic) IBOutlet UIProgressView *musicProgress;
@property IBOutlet UIProgressView *webProgress;
@property (nonatomic) IBOutlet NSURLRequest *youtubeRequest;
@property  (nonatomic) IBOutlet UILabel *appleLabel;
@property (nonatomic) IBOutlet UILabel *appleUnit;
@property (nonatomic) IBOutlet UILabel *applesPrice;
@property (nonatomic) IBOutlet UILabel *bannanaLabel;
@property (nonatomic) IBOutlet UILabel *bannanaUnit;
@property (nonatomic) IBOutlet UILabel *bannanaPrice;
@property (nonatomic) IBOutlet UILabel *CoffeeLabel;
@property (nonatomic) IBOutlet UILabel *CoffeeUnit;
@property (nonatomic) IBOutlet UILabel *coffeePrice;
@property (nonatomic) IBOutlet UILabel *MilkLabel;
@property (nonatomic) IBOutlet UILabel *MilkUnit;
@property (nonatomic) IBOutlet UILabel *milkPrice;
@property (nonatomic) IBOutlet UILabel *EggLabel;
@property (nonatomic) IBOutlet UILabel *EggUnit;
@property (nonatomic) IBOutlet UILabel *eggsPrice;
@property (nonatomic) IBOutlet UILabel *OilLabel;
@property (nonatomic) IBOutlet UILabel *OilUnit;
@property (nonatomic) IBOutlet UILabel *oilPrice;
@property (nonatomic) IBOutlet UILabel *OJLabel;
@property (nonatomic) IBOutlet UILabel *OJUnit;
@property (nonatomic) IBOutlet UILabel *orange_juicePrice;
@property (nonatomic) IBOutlet UILabel *JobsLabel;
@property (nonatomic) IBOutlet UILabel *JobsUnit;
@property (nonatomic) IBOutlet UILabel *unemploymentPrice;
@property (weak, nonatomic) IBOutlet UILabel *stockTerm;
@property (weak, nonatomic) IBOutlet UILabel *dailyChange;
@property (weak, nonatomic) IBOutlet UILabel *changeToday;
@property (weak, nonatomic) IBOutlet UILabel *open;
@property (weak, nonatomic) IBOutlet UILabel *close;
@property (weak, nonatomic) IBOutlet UILabel *adjClose;
@property (weak, nonatomic) IBOutlet UILabel *high;
@property (weak, nonatomic) IBOutlet UILabel *low;
@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (nonatomic) IBOutlet UIScrollView *priceScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pricePageControl;
@property (nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property BOOL start;
@property int pageNumber;
@property float baseOffset;
@property float offsetStep;
@property (nonatomic) BOOL goPressed;
@property (nonatomic) BOOL canAnimate;
@property (nonatomic) BOOL playPressed;
@property (nonatomic) BOOL searchON;
@property (nonatomic) BOOL onlyOnce;
@property (nonatomic) BOOL test;
@property (nonatomic) BOOL pressedSearch;
@property (nonatomic) BOOL loadedSpecificView;
@property (nonatomic) BOOL changeDatePressed;
@property (nonatomic) BOOL animatedHappened;
- (IBAction)reload:(id)sender;
- (IBAction)switchPresetStrings:(id)sender;
- (IBAction)goButton:(id)sender;
- (IBAction)enterButton:(id)sender;
- (IBAction)arrowRight:(id)sender;
- (IBAction)arrowLeft:(id)sender;
- (IBAction)goHome:(id)sender;
- (IBAction)changeSearch:(id)sender;
- (IBAction)changeDate:(id)sender;
- (IBAction)confirm:(id)sender;
- (IBAction)webForward:(id)sender;
- (IBAction)webBack:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)rewind:(id)sender;
- (IBAction)play:(id)sender;
@end
