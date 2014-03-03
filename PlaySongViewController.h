//
//  PlaySongViewController.h
//  BabySong
//
//  Created by Matthew Lu on 1/02/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlaySongViewController : UIViewController<AVAudioPlayerDelegate>
{

    UIButton *playButton;
    UIButton *previousButton;
    UIButton *nextButton;
    UIButton			*pauseButton;
    UIButton			*repeatButton;
	UIButton			*shuffleButton;
    UIButton			*artworkView;
    
    UISlider  *volumeSlider;
    UILabel				*currentTime;
	UILabel				*duration;
    UIView				*overlayView;

    UISlider  *progressSlider;
    
    NSTimer	*updateTimer;
    NSString *songName;
    NSArray *songList;
    NSInteger songIndex;
    
    UILabel           *titleLabel;
    
    BOOL				repeatAll;
	BOOL				repeatOne;
	BOOL				shuffle;
    
    
    //Song *song;
    
}

@property(nonatomic,strong) AVAudioPlayer *audioPlayer;

@property(nonatomic,strong) NSString *songName;

@property(nonatomic,assign) NSInteger songIndex;
@property(nonatomic,strong) NSArray *songList;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

//@property(nonatomic,strong) Song *song;;

@end
