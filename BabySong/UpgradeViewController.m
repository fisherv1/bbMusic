//
//  UpgradeViewController.m
//  BabySong
//
//  Created by Matthew Lu on 31/03/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "UpgradeViewController.h"
#import "InAppPurchaseManager.h"

#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "ASIHTTPRequest.h"
#import "KKProgressToolbar.h"
#import "AppDelegate.h"
#import "LibraryAPI.h"

#define ITEM_SPACING 200



#define kShadowColor1		[UIColor blackColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowOffset		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)
#define kShadowBlur			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)

#define kStrokeColor		[UIColor blackColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 3.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]


@interface UpgradeViewController()
{
    NSArray *_products;
}

@end
@interface UpgradeViewController ()

@end

@implementation UpgradeViewController
@synthesize upgradeBtn,songsTableView,downloadBtn,restoreBtn,carousel,allSongDownloadedLabel;




- (IBAction)downloadAction:(id)sender {
        
    NSMutableArray *newMusic = [NSMutableArray arrayWithArray:[SongFactory getSongs:FALSE]];
    
    NSLog(@"new song %d",[newMusic count]);

    [self saveSong:newMusic];
    
}

-(BOOL)checkSongExist:(NSString*)songName
{
    
    return  false;
}


-(void)saveSong:(NSMutableArray*)songArray
{
 
    if ([songArray count]>0) {

    __block NSMutableArray *_songArray = songArray;
    
        int arrayLength = [songArray count];
        
        Song *song = [_songArray objectAtIndex:arrayLength -1];
        
        NSString *musicName = song.fileName;
    
        
        
    self.statusToolbar.statusLabel.text =  [@"Loading " stringByAppendingFormat:@"%@",song.displayName];
    
        self.statusToolbar.statusLabel.adjustsFontSizeToFitWidth = YES;
    [self.statusToolbar show:YES completion:^(BOOL finished) {
        
      //  NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString *stringURL = [NSString stringWithFormat:@"%@%@.mp3",@"http://www.ihelloworld.net/songs/",musicName];
        
        NSLog(@"%@",stringURL);
        
        NSURL  *url = [NSURL URLWithString:stringURL];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[NSString stringWithFormat:@"%@.mp3",musicName]];
        
        NSLog(@"file path: %@",filePath);
        
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request setDownloadProgressDelegate: self.statusToolbar.progressBar];
        
        [request setDownloadDestinationPath:filePath];
        
        
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error) {
            
            
            
            [self.statusToolbar hide:YES completion:^(BOOL finished) {
                
           //     NSBundle *mainBundle = [NSBundle mainBundle];
                
             //   NSString *filePath =[mainBundle pathForResource:musicName ofType:@"mp3"];

                NSLog(@"%@",filePath);
                NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
                
                if (data != nil) {
                    
                    
                    
                    [self addSong:song];
                
        
                    NSLog(@"%d",[_songArray count]);
                    [_songArray removeLastObject];
                    NSLog(@"%d",[_songArray count]);
                    
                    [self saveSong:_songArray];
                }
                else
                {
                    NSLog(@"Data nil");
                }
            }];
            
        }
        
    }];
        
     
    }
    else
    {
        downloadBtn.hidden = YES;
        
        UIAlertView *alertview= [[UIAlertView alloc]initWithTitle:@"All songs are downloaded!Enjoy!" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertview show];
  
    }
}



-(void)addSong:(Song*)newSong
{
    [SongFactory updateSong:[newSong.songId intValue]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)upgradeToPro:(id)sender {
    
    NSLog(@"%d",[_products count]);
    
    if ([_products count]>0) {
        SKProduct *product = [_products objectAtIndex:0];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        
        [[RageIAPHelper sharedInstance] buyProduct:product];
        
    }
}


- (BOOL)isIPHONE5
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if(pixelHeight == 1136.0f)
    {
        return TRUE;
    }
    return FALSE;
}



-(void)viewWillAppear:(BOOL)animated
{
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    
    [self getNewSongList];
    [carousel reloadData];
}

-(void)getNewSongList
{
 
    allSongDownloadedLabel.hidden = YES;
    newMusicArray = [NSMutableArray arrayWithArray:[SongFactory getSongs:FALSE]];
    
    
    if ([newMusicArray count]== 0) {
        allSongDownloadedLabel.hidden = NO;
        allSongDownloadedLabel.adjustsFontSizeToFitWidth = YES;
        [self cogfigSuccessLabel];
        allSongDownloadedLabel.text = NSLocalizedStringFromTable(@"SongDownloadedMsg", @"InfoPlist", Nil);
        
    }
}

-(void)cogfigSuccessLabel
{

        //  songNameLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:25];
        allSongDownloadedLabel.shadowColor = kShadowColor2;
        allSongDownloadedLabel.shadowOffset = kShadowOffset;
        allSongDownloadedLabel.shadowBlur = kShadowBlur;
        allSongDownloadedLabel.strokeColor = kStrokeColor;
        allSongDownloadedLabel.strokeSize = kStrokeSize;
        allSongDownloadedLabel.gradientStartColor = kGradientStartColor;
        allSongDownloadedLabel.gradientEndColor = kGradientEndColor;
        allSongDownloadedLabel.adjustsFontSizeToFitWidth  = YES;
        
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            
            
//            NSArray *array=[NSArray arrayWithObjects:@"1",nil];
//            
//            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,@"Purchased", nil];
//            
//            [dict writeToFile:[self logfile] atomically:YES ];
            
            [upgradeBtn setTitle:@"Upgraded. Thanks" forState:UIControlStateNormal];
            
            upgradeBtn.userInteractionEnabled = false;
            
            downloadBtn.hidden = NO;
            
            downloadBtn.frame = CGRectMake(downloadBtn.frame.origin.x, upgradeBtn.frame.origin.y+upgradeBtn.frame.size.height +10, downloadBtn.frame.size.width, downloadBtn.frame.size.height);
            
              downloadBtn.frame = CGRectMake(downloadBtn.frame.origin.x, carousel.frame.origin.y+carousel.frame.size.height +10, downloadBtn.frame.size.width, downloadBtn.frame.size.height);
            
            *stop = YES;
        }
        else
        {
            [upgradeBtn setTitle:@"Upgrade to get more songs" forState:UIControlStateNormal];
            
            upgradeBtn.userInteractionEnabled = TRUE;
            
            downloadBtn.hidden = YES;

            
        }
        
    }];
    
}


-(void)configRestoreBtn
{
     [restoreBtn setShowsTouchWhenHighlighted:YES];
  
    UIImage *addImage = [LibraryAPI scaleImage:[UIImage imageNamed: @"restore.png"] toScale:0.7] ;
    
    UIImage *addPressed = [LibraryAPI scaleImage:[UIImage imageNamed:@"restore.png"] toScale:0.7] ;
    
    
    [restoreBtn setBackgroundImage:addImage forState:UIControlStateNormal];
    [restoreBtn setBackgroundImage:addPressed forState:UIControlStateHighlighted];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:restoreBtn];
     self.navigationItem.rightBarButtonItem = item;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self configRestoreBtn];
    [self configNavigationTitle];
    
    [self reload];
    [self configProgressBar];
    
    
    carousel.type = iCarouselTypeCoverFlow;
    
    if (![self isIPHONE5]) {
        CGRect rect = upgradeBtn.frame;
        upgradeBtn.frame = CGRectMake(rect.origin.x, rect.origin.y -20, rect.size.width, rect.size.height);
        
        downloadBtn.frame = CGRectMake(rect.origin.x, carousel.frame.origin.y +15, rect.size.width, rect.size.height);
    }

    
    
    SKProduct *product = [_products objectAtIndex:0];
    
    if ([[RageIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
        
        upgradeBtn.userInteractionEnabled = false;
    } else {
        
    }
}

-(void)configNavigationTitle
{
    UILabel *toplab=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 140, 45)];
    toplab.font=[UIFont boldSystemFontOfSize:20];
    //toplab.textColor=[UIColor whiteColor];
    toplab.textColor=[UIColor yellowColor];
    
    //  toplab.text = @"Baby Songs";
    
    toplab.text = NSLocalizedStringFromTable(@"UpgradeNavTitle", @"InfoPlist", Nil);
    
    [toplab setShadowColor:[UIColor blackColor]];
    [toplab setShadowOffset:CGSizeMake(-2, 3)];
    
    //toplab.highlighted = YES;
    //toplab.highlightedTextColor = [UIColor yellowColor];
    
    
    toplab.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    [toplab setBackgroundColor:[UIColor clearColor]];
    [toplab setTextAlignment:UITextAlignmentCenter];
    [toplab setBaselineAdjustment:UIBaselineAdjustmentNone];
    [toplab setLineBreakMode:UILineBreakModeTailTruncation];
    self.navigationItem.titleView=toplab;
}




-(void)configProgressBar
{
	CGRect statusToolbarFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44);
	self.statusToolbar = [[KKProgressToolbar alloc] initWithFrame:statusToolbarFrame];
	self.statusToolbar.actionDelegate = self;
	[self.view addSubview:self.statusToolbar];
}

- (void)didCancelButtonPressed:(KKProgressToolbar *)toolbar {
    [self stopUILoading];
}


- (IBAction)stopUILoading {
    [self.statusToolbar hide:YES completion:^(BOOL finished) {
        
    }];
    
}

-(NSString*)logfile
{
    //  NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    //  return [path stringByAppendingPathComponent:@"AppCommon.plist"];
    
   // return  [[NSBundle mainBundle]pathForResource:@"AppCommon" ofType:@"plist"];

    AppDelegate *appDelegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    // /var/mobile/Applications/A942A30D-52EF-46E0-8723-BAD941426E1F/Documents/AppCommon.plist
    // /var/mobile/Applications/A942A30D-52EF-46E0-8723-BAD941426E1F/BabySong.app/AppCommon.plist
    NSLog(@"%@",[appDelegate logfile]);
    
    return [appDelegate logfile];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *plistLocation = [documentsDirectory stringByAppendingPathComponent:@"AppCommon.plist"];
//    
//    NSLog(@"%@",plistLocation);
//    return plistLocation;
    
}

-(void)reload
{
    _products = nil;
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if(success)
        {
            _products = products;
            
            NSLog(@"%d",[_products count]);
            if([products count]>0)
            {  SKProduct *proUpgradeProduct = [products objectAtIndex:0];
                NSLog(@"Product title: %@",proUpgradeProduct.localizedTitle);
                NSLog(@"Product description: %@",proUpgradeProduct.localizedDescription);
                NSLog(@"Product price: %@",proUpgradeProduct.price);
                NSLog(@"Product id:%@",proUpgradeProduct.productIdentifier);
            }
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUpgradeBtn:nil];
    [self setDownloadAction:nil];
    [self setSongsTableView:nil];
    [self setDownloadBtn:nil];
    [super viewDidUnload];
}
- (IBAction)restoreAction:(id)sender {
    
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}



#pragma mark -

-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  [newMusicArray count];
}


-(UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    // songNameList = [[NSMutableArray alloc]initWithObjects:@"GoodMorning",@"WhiteChrismas",@"Jinglebells",@"LondonBridge", nil];
    //NSLog(@"%@",songNameList);
    
    Song *song = [newMusicArray objectAtIndex:index];
    
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",song.imgName]]];
    
    // songNameLabel.text = song.displayName;
    //  songNameLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
    
    
    // view.frame = CGRectMake(70, 80, 180, 260);
    view.frame = CGRectMake(70, 80, 90, 130);
    return view;
    
}

-(NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return  0 ;
}

-(NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    
    return  [newMusicArray count];
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
        if (downloadBtn.hidden == YES && [_products count]>0) {
            SKProduct *product = [_products objectAtIndex:0];
            
            NSLog(@"Buying %@...", product.productIdentifier);
            
            [[RageIAPHelper sharedInstance] buyProduct:product];
        }
}

-(CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}


-(CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0- fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI /8.0, 0, 1.0, 0);
    
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}


-(void)carouselDidEndScrollingAnimation:(iCarousel *)this_carousel
{
    }






@end
