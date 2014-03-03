//
//  PlaySongViewController.m
//  BabySong
//
//  Created by Matthew Lu on 1/02/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "PlaySongViewController.h"
#import "Song.h"
#import "LibraryAPI.h"
@interface PlaySongViewController ()

@end

@implementation PlaySongViewController

@synthesize audioPlayer,songIndex,songList,songName,bgImgView;

-(void)setupBGimg :(NSString *)imgPath
{
    NSLog(@"%@",imgPath);
    bgImgView.image = [UIImage imageNamed:imgPath];
}

-(void)playSound
{
    // dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // dispatch_async(dispatchQueue , ^(void)
    //     {
    //
    NSLog(@"%d",songIndex);
    Song *song = [songList objectAtIndex:songIndex];
    
    [self setupBGimg:song.imgName];
    
    [self configNavigationTitle];
    
    NSLog(@"%@",song.fileName);
    
   // NSString *filePath =[mainBundle pathForResource:song.fileName ofType:@"mp3"];
    
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
   NSString* filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[NSString stringWithFormat:@"%@.mp3",song.fileName]];
    


    
  //  NSLog(@"%@ 111 ",filePath);
   NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    if (fileData == nil) {
      //  NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       // NSString  *documentsDirectory = [paths objectAtIndex:0];
        //filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[NSString stringWithFormat:@"%@.mp3",song.fileName]];
        NSBundle *mainBundle = [NSBundle mainBundle];
        filePath =[mainBundle pathForResource:song.fileName ofType:@"mp3"];
        fileData = [NSData dataWithContentsOfFile:filePath];
    }
    
   // NSLog(@"%@ 222 ",filePath);

    
    
   // NSLog(@"%@",fileData == nil? @"Nil":@"Not nil");
    NSError *error = nil;
    
  //  self.audioPlayer = [[AVAudioPlayer alloc]initWithData:fileData error:&error];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
      self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    if (error==nil) {
        if(self.audioPlayer !=nil)
        {
            self.audioPlayer.delegate = self;
            if([self.audioPlayer prepareToPlay] && [self.audioPlayer play])
            {
                
            }
            else{
            }
        }
        else
        {
        }
        
    }
    else
    {
        NSLog(@"%@",error);
    }
    
    
    //        });
    
    
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
}


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    // Audio Session is interrupted. The player will be paused here
    [player pause];
}


-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if(flags == AVAudioSessionInterruptionOptionShouldResume && player !=nil)
    {
        [player play];
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(BOOL)hidesBottomBarWhenPushed
{
    return true;
}
-(void)viewWillAppear:(BOOL)animated
{
    //self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.tabBarController.tabBar.hidden = YES;
    //self.view.backgroundColor = [UIColor redColor];
    
    Song *song = [songList objectAtIndex:songIndex];
    
    songName = song.displayName;
    
    [self configNavigationTitle];
    
    duration.adjustsFontSizeToFitWidth = YES;
	currentTime.adjustsFontSizeToFitWidth = YES;
	progressSlider.minimumValue = 0.0;
    

    artworkView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];

    
	//[artworkView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNoArtwork" ofType:@"png"]] forState:UIControlStateNormal];
	
    //[artworkView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background1" ofType:@"jpg"]] forState:UIControlStateNormal];
    
    [artworkView addTarget:self action:@selector(showOverlayView) forControlEvents:UIControlEventTouchUpInside];
	artworkView.showsTouchWhenHighlighted = NO;
	artworkView.adjustsImageWhenHighlighted = NO;
	artworkView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:artworkView];
    
    [self initPlayPanel];
    [self playSound];
}

-(void)configNavigationTitle
{
    UILabel *toplab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 45)];
    toplab.font=[UIFont boldSystemFontOfSize:20];
    toplab.textColor=[UIColor yellowColor];
    toplab.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
    toplab.text = songName;
    [toplab setShadowColor:[UIColor blackColor]];
    [toplab setShadowOffset:CGSizeMake(-2, 3)];
    [toplab setBackgroundColor:[UIColor clearColor]];
    [toplab setTextAlignment:UITextAlignmentCenter];
    [toplab setBaselineAdjustment:UIBaselineAdjustmentNone];
    [toplab setLineBreakMode:UILineBreakModeTailTruncation];
    toplab.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.titleView=toplab;
    
}


-(void)showOverlayView
{
    
    if(overlayView ==nil)
    {
        overlayView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 76)];
        
        if ([LibraryAPI isIOS7]) {
            overlayView.frame = CGRectMake(0, 38, overlayView.frame.size.width,overlayView.frame.size.height);
        }
        overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        overlayView.opaque = NO;
        
        progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(54,24, 212, 23)];
        
        //[progressSlider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberKnob" ofType:@"png"]] forState:UIControlStateNormal];
        
        
        
        //  [progressSlider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]forState:UIControlStateNormal];
        
        
        //[progressSlider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]forState:UIControlStateNormal];
        
        UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
        UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];
        
        
        [progressSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [progressSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
        [progressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
        [progressSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
       
        
        
        [progressSlider addTarget:self action:@selector(progressSliderMoved:) forControlEvents:UIControlEventValueChanged];
        
        
        NSLog(@"%f",audioPlayer.duration);
        
        progressSlider.maximumValue = audioPlayer.duration;
        progressSlider.minimumValue =0.0;
        
        [overlayView addSubview:progressSlider];
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 195, 12)];
        titleLabel.text = songName;
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(0, -1);
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [overlayView addSubview:titleLabel];
        
        duration = [[UILabel alloc] initWithFrame:CGRectMake(272, 21, 48, 21)];
        duration.font = [UIFont boldSystemFontOfSize:14];
        duration.shadowOffset = CGSizeMake(0, -1);
        duration.shadowColor =[UIColor blackColor];
        duration.backgroundColor  =[UIColor clearColor];
        duration.textColor = [UIColor whiteColor];
        [overlayView addSubview:duration];
        
        
        
        currentTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 48, 21)];
        currentTime.font = [UIFont boldSystemFontOfSize:14];
        currentTime.shadowOffset = CGSizeMake(0, -1);
        currentTime.shadowColor =[UIColor blackColor];
        currentTime.backgroundColor  =[UIColor clearColor];
        currentTime.textColor = [UIColor whiteColor];
        currentTime.textAlignment = NSTextAlignmentRight;
        [overlayView addSubview:currentTime];
        
        duration.adjustsFontSizeToFitWidth = YES;
        currentTime.adjustsFontSizeToFitWidth = YES;
        
        repeatButton =[[UIButton alloc] initWithFrame:CGRectMake(10, 45, 32, 28)];
        
        [repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOff" ofType:@"png"]] forState:UIControlStateNormal];
        
        [repeatButton addTarget:self action:@selector(toggleRepeat) forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:repeatButton];
        
        shuffleButton =[[UIButton alloc] initWithFrame:CGRectMake(280, 45, 32, 28)];
        
        [shuffleButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerShuffleOff" ofType:@"png"]] forState:UIControlStateNormal];
        
        [shuffleButton addTarget:self action:@selector(toggleShuffle) forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:shuffleButton];
        
        
    }
    
    [self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	if ([overlayView superview])
		[overlayView removeFromSuperview];
	else
		[self.view addSubview:overlayView];
	
	[UIView commitAnimations];
}

- (void)toggleShuffle
{
	if (shuffle)
	{
		shuffle = NO;
		[shuffleButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerShuffleOff" ofType:@"png"]] forState:UIControlStateNormal];
	}
	else
	{
		shuffle = YES;
		[shuffleButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerShuffleOn" ofType:@"png"]] forState:UIControlStateNormal];
	}
	
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
}

- (void)toggleRepeat
{
	if (repeatOne)
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOff" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = NO;
		repeatAll = NO;
	}
	else if (repeatAll)
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOneOn" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = YES;
		repeatAll = NO;
	}
	else
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOn" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = NO;
		repeatAll = YES;
	}
	
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
}



- (IBAction)progressSliderMoved:(UISlider *)sender
{
    
	audioPlayer.currentTime = sender.value;
	[self updateCurrentTimeForPlayer:audioPlayer];
}


- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:audioPlayer];
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	//titleLabel.text = [songList objectAtIndex:songIndex];
    //	artistLabel.text = [[soundFiles objectAtIndex:selectedIndex] artist];
	//albumLabel.text = [[soundFiles objectAtIndex:selectedIndex] album];
	
	[self updateCurrentTimeForPlayer:p];
	
	if (updateTimer)
		[updateTimer invalidate];
	
    //  NSLog(@"%@",p.playing == YES ? @"T":@"F");
    //     NSLog(@"--- %@",p.play == YES ? @"T":@"F");
    if (p.playing)
	{
		[playButton removeFromSuperview];
		[self.view addSubview:pauseButton];
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}
	else
	{
		[pauseButton removeFromSuperview];
		[self.view addSubview:playButton];
		updateTimer = nil;
	}
	
    //	if (![songTableView superview])
    //	{
    //		[artworkView setImage:[[soundFiles objectAtIndex:selectedIndex] coverImage] forState:UIControlStateNormal];
    //		reflectionView.image = [self reflectedImage:artworkView withHeight:artworkView.bounds.size.height * kDefaultReflectionFraction];
    //	}
    //
	if (repeatOne || repeatAll || shuffle)
		nextButton.enabled = YES;
	else
		nextButton.enabled = [self canGoToNextTrack];
	previousButton.enabled = [self canGoToPreviousTrack];
}

-(void)initPlayPanel
{
    
    //bool isIphone5 = self.view.window.bounds.size.height == 1136.0f ? TRUE :FALSE;
    bool isIphone5 = [self isIPHONE5];
    
    int yPostistion = isIphone5 == TRUE ? 410 : 320 ;
    
    if ([LibraryAPI isIOS7]) {
        yPostistion += 44;
    }
    
    UIImageView *buttonBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, yPostistion, self.view.bounds.size.width, 96)];
    
	buttonBackground.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerBarBackground" ofType:@"png"]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    
    playButton = [[UIButton alloc]initWithFrame:CGRectMake(144, yPostistion+10, 40, 40)];
    
    [playButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPlay" ofType:@"png"]] forState:UIControlStateNormal];
    playButton.tag =1;
    
    [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    playButton.showsTouchWhenHighlighted = YES;
    
    
    pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(140, yPostistion+10, 40, 40)];
	[pauseButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPause" ofType:@"png"]] forState:UIControlStateNormal];
	[pauseButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.showsTouchWhenHighlighted = YES;
    
    
    previousButton = [[UIButton alloc]initWithFrame:CGRectMake(60, yPostistion+10, 40, 40)];
    
    [previousButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPrevTrack" ofType:@"png"]] forState:UIControlStateNormal];
    
    
    
    previousButton.tag =3;
    [previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    previousButton.showsTouchWhenHighlighted = YES;
    
    nextButton = [[UIButton alloc]initWithFrame:CGRectMake(220, yPostistion+10, 40, 40)];
    [nextButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNextTrack" ofType:@"png"]] forState:UIControlStateNormal];
    nextButton.tag =4;
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    nextButton.showsTouchWhenHighlighted= YES;
    
    
    volumeSlider =[[UISlider alloc] initWithFrame:CGRectMake(25, yPostistion+50, 270, 9)];
    //[volumeSlider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerVolumeKnob" ofType:@"png"  ]] forState:UIControlStateNormal];
    
    
    //   [volumeSlider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3] forState:UIControlStateNormal];
    
    // [volumeSlider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]forState:UIControlStateNormal];
    
    
    UIImage *minImage = [[UIImage imageNamed:@"slider-track-fill.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    UIImage *maxImage = [UIImage imageNamed:@"slider-track.png"];
    UIImage *thumbImage = [UIImage imageNamed:@"slider-cap.png"];
    
    
    [volumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [volumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [volumeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [volumeSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    
    
    [volumeSlider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
    
    
    if([[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"])
        volumeSlider.value =[[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"];
    else
        volumeSlider.value = audioPlayer.volume;
    
    [self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
    
    [self.view addSubview:buttonBackground];
    // [self.view addSubview:playButton];
    // [self.view addSubview:pauseButton];
    [self.view addSubview:previousButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:volumeSlider];
}




-(void)volumeSliderMoved:(UISlider *)sender
{
    audioPlayer.volume = [sender value];
    [[NSUserDefaults standardUserDefaults] setFloat:[sender value] forKey:@"PlayerVolume"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [audioPlayer stop];
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    NSString *current =[NSString stringWithFormat:@"%d:%02d",(int)p.currentTime /60,(int)p.currentTime %60,nil];
    
    NSString *dur = [NSString stringWithFormat:@"-%d:%02d", (int)((int)(p.duration - p.currentTime))/60,(int)((int)(p.duration - p.currentTime))%60,nil];
    
    duration.text = dur;
    currentTime.text = current;
    // NSLog(@"--%f",p.currentTime);
    progressSlider.value = p.currentTime;
    
}

-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
	duration.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
	//indexLabel.text = [NSString stringWithFormat:@"%d of %d", (selectedIndex + 1), [soundFiles count]];
	progressSlider.maximumValue = p.duration;
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"])
		volumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"];
	else
		volumeSlider.value = p.volume;
}


-(NSString*)getSongName :(NSString *)SongName : (BOOL) nextSong
{
    int totalSong = [songList count];
    
    for(int i =0;i<totalSong;i++)
    {
        if([SongName isEqualToString: songName])
        {
            if(nextSong)
            {
                if(i>=totalSong-1)
                {
                    return  ((Song*)[songList objectAtIndex:0]).displayName;
                }
                return ((Song*)[songList objectAtIndex:i+1]).displayName;
            }
            else
            {
                if(i==0)
                {
                    return ((Song*)[songList objectAtIndex: totalSong -1]).displayName;
                }
                return ((Song*)[songList objectAtIndex:i-1]).displayName;
            }
        }
    }
    
    // if not find, return the first one;
    return ((Song*)[songList objectAtIndex:0]).displayName;
    
}


-(void)play
{
	if (audioPlayer.playing == YES)
	{
		[audioPlayer pause];
	}
	else
	{
		if ([audioPlayer play])
		{
			
		}
		else
		{
			NSLog(@"Could not play %@\n",audioPlayer.url);
		}
	}
	
	
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
}


- (void)previous
{
    NSUInteger newIndex = songIndex - 1;
	songIndex = newIndex;
    
    // songName = [self getSongName:songName :FALSE];
    
    songName = ((Song*)[songList objectAtIndex:songIndex]).displayName;
    
    titleLabel.text = songName;
    // songIndex --;
    NSLog(@"%@",songName);
    [self playSound];
    
	
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
}

- (void)next
{
    
    NSUInteger newIndex;
	
	if (shuffle)
	{
		newIndex = rand() % [songList count];
	}
	else if (repeatOne)
	{
		newIndex = songIndex;
	}
	else if (repeatAll)
	{
		if (songIndex + 1 == [songList count])
			newIndex = 0;
		else
			newIndex = songIndex + 1;
	}
	else
	{
		newIndex = songIndex + 1;
	}
	
	songIndex = newIndex;
    
    Song *song = [songList objectAtIndex:songIndex];
    
    //  songName = [self getSongName:songName :TRUE];
    
    songName = song.displayName;
    titleLabel.text = songName;
    // songIndex++;
    NSLog(@"%@",songName);
    [self playSound];
    
	
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
    
}


- (BOOL)canGoToNextTrack
{
	if (songIndex + 1 == [songList count])
		return NO;
	else
		return YES;
}

- (BOOL)canGoToPreviousTrack
{
	if (songIndex == 0)
		return NO;
	else
		return YES;
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
	
	if ([self canGoToNextTrack])
        [self next];
	//else if (interrupted)
	//	[audioPlayer play];
	else
		[audioPlayer stop];
    
	[self updateViewForPlayerInfo:audioPlayer];
	[self updateViewForPlayerState:audioPlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
