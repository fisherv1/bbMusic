//
//  SongNameViewController.h
//  BabySong
//
//  Created by Matthew Lu on 31/01/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "THLabel.h"

//#import <AVFoundation/AVFoundation.h>



@interface SongNameViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>
{
    NSString *songName;
    NSArray *songList;
    NSInteger songIndex;
    
    UIButton *upgradeBtn;
    BOOL blinkStatus;
    NSTimer *timer;
}
//@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet THLabel *songNameLabel;


@end
