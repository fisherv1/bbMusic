//
//  SongNameViewController.m
//  BabySong
//
//  Created by Matthew Lu on 31/01/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "SongNameViewController.h"
#import "PlaySongViewController.h"
#import "AppDelegate.h"
#import "SongFactory.h"
#import "Song.h"
#import "LibraryAPI.h"
#import "THLabel.h"

#define ITEM_SPACING 200

#define kShadowColor1		[UIColor blackColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowOffset		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)
#define kShadowBlur			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)

#define kStrokeColor		[UIColor blackColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 3.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]


@interface SongNameViewController ()


@end

@implementation SongNameViewController
//@synthesize playBtn;
@synthesize carousel,songNameLabel;

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
    
    //[self getSongList];
   // carousel.delegate = self;
   // carousel.dataSource = self;

 

    [self configUpdateBtn];
    [self configNavigationTitle];
    [self configSongNameLabel];
    carousel.type = iCarouselTypeCoverFlow;
}





-(void)configUpgradeBtn
{
   timer = [NSTimer
                      scheduledTimerWithTimeInterval:(NSTimeInterval)(40.0 / 60.0)
                      target:self
                      selector:@selector(blink)
                      userInfo:nil
                      repeats:TRUE];
     blinkStatus = NO;
}


-(void)blink{
    

    
    if(blinkStatus == NO){

        blinkStatus = YES;
    }else {
        blinkStatus = NO;
    }

        self.navigationItem.rightBarButtonItem = [self addUpdateButton];
}



-(void)configUpdateBtn
{
    self.navigationItem.rightBarButtonItem = [self addUpdateButton];
}




- (UIBarButtonItem *)addUpdateButton {
    
    if (upgradeBtn == Nil) {

    upgradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [upgradeBtn addTarget:self action:@selector(createNewBtnActionTapped) forControlEvents:UIControlEventTouchUpInside];
        [upgradeBtn setShowsTouchWhenHighlighted:YES];
        }
    UIImage *addImage = [LibraryAPI scaleImage:[UIImage imageNamed: blinkStatus ? @"upgradeBtnWhite.png" : @"upgradeBtn.png"] toScale:0.6] ;
    
    UIImage *addPressed = [LibraryAPI scaleImage:[UIImage imageNamed:blinkStatus ? @"upgradeBtnWhite.png" : @"upgradeBtn.png"] toScale:0.6] ;
 

    [upgradeBtn setBackgroundImage:addImage forState:UIControlStateNormal];
    [upgradeBtn setBackgroundImage:addPressed forState:UIControlStateHighlighted];
    const CGFloat BarButtonOffset = 15.0f;
    
    [upgradeBtn setFrame:CGRectMake(BarButtonOffset, 0, addImage.size.width, addImage.size.height)];

        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:upgradeBtn];
        
        return item;
}


-(void)createNewBtnActionTapped
{
   [self performSegueWithIdentifier: @"upgradeSegue" sender: self];
}


-(void)configSongNameLabel
{
  //  songNameLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:25];
    self.songNameLabel.shadowColor = kShadowColor2;
    self.songNameLabel.shadowOffset = kShadowOffset;
    self.songNameLabel.shadowBlur = kShadowBlur;
    self.songNameLabel.strokeColor = kStrokeColor;
    self.songNameLabel.strokeSize = kStrokeSize;
    self.songNameLabel.gradientStartColor = kGradientStartColor;
    self.songNameLabel.gradientEndColor = kGradientEndColor;
    self.songNameLabel.adjustsFontSizeToFitWidth  = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    
            [self configUpgradeBtn];
    [self getSongList];
    [carousel reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}



-(NSString*)logfile
{
 //   NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
  //  return [path stringByAppendingPathComponent:@"AppCommon.plist"];

    AppDelegate *appDelegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSLog(@"%@",[appDelegate logfile]);
    return [appDelegate logfile];
    
   // return  [[NSBundle mainBundle]pathForResource:@"AppCommon" ofType:@"plist"];
}







-(void)getSongList
{
  //  AppDelegate *appDelegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
   // songNameList = appDelegate.songList;
    
//    NSString *filename=[self logfile];
//    
//    NSDictionary *dicta=[NSDictionary dictionaryWithContentsOfFile:filename];
//    
//    NSArray *object = [dicta objectForKey:@"SongsName"];
//    
//    NSLog(@"%@",object);
//
//    songNameList =[[NSMutableArray alloc]initWithArray:object];

    
    songList = [SongFactory getSongs:TRUE];
    
    if ([songList count]==0) {
        [SongFactory createSongs];
        songList = [SongFactory getSongs:TRUE];
    }
    
}

-(void)configNavigationTitle
{
    UILabel *toplab=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 140, 45)];
    toplab.font=[UIFont boldSystemFontOfSize:20];
    //toplab.textColor=[UIColor whiteColor];
    toplab.textColor=[UIColor yellowColor];

  //  toplab.text = @"Baby Songs";
    
      toplab.text = NSLocalizedStringFromTable(@"MusicNavTitle", @"InfoPlist", Nil);
    
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



#pragma mark -

-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return  [songList count];
}


-(UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    // songNameList = [[NSMutableArray alloc]initWithObjects:@"GoodMorning",@"WhiteChrismas",@"Jinglebells",@"LondonBridge", nil];
    //NSLog(@"%@",songNameList);
    
    Song *song = [songList objectAtIndex:index];
    
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

    return  [songList count];
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
    NSLog(@"%d",index);
    songIndex = index;
   [self performSegueWithIdentifier: @"playSegue" sender: self];

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



//
//-(void) getSongList
//{
//    
//    songNameList = [[NSMutableArray alloc]initWithObjects:@"CanonInD",@"Stop Standing There", nil];
//}


//- (IBAction)playSong:(id)sender {
//
//    
//    UIButton *playButton = (UIButton *)sender;
//    
//    switch (playButton.tag) {
//        case 1:
//            songName=@"CanonInD";
//            break;
//        case 2:
//            songName=@"Stop Standing There";
//            break;
//        case 3:
//            songName=@"CanonInD";
//            break;
//        case 4:
//            songName=@"CanonInD";
//            break;
//        case 5:
//            songName=@"CanonInD";
//            break;
//        case 6:
//            songName=@"CanonInD";
//            break;
//        case 7:
//            songName=@"CanonInD";
//            break;
//        default:
//            break;
//    }
//   // songName =@"CanonInD";
//    //[self performSegueWithIdentifier:@"play1Segue" sender:self];
//    
//    
////    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
////    
////    
////    
////    PlaySongViewController *pv = [board instantiateViewControllerWithIdentifier:@"playSongViewControl"];
////    [pv setSongName:songName];
////    [pv setSongList:songNameList];
////    
////    [self.navigationController pushViewController:pv animated:YES];
//}

-(void)carouselDidEndScrollingAnimation:(iCarousel *)this_carousel
{
    Song *song = [songList objectAtIndex: this_carousel.currentItemIndex];
    songNameLabel.text = song.displayName;

    
 //   [self configSongNameLabel];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([[segue identifier] isEqualToString:@"playSegue"])
    {
        PlaySongViewController *pv = [segue destinationViewController];
       
      //  Song *song = [songList objectAtIndex:songIndex];
       // pv.song = song;
        
         pv.songIndex = songIndex;
       [pv setSongList:songList];
        
    }
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
