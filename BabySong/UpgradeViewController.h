//
//  UpgradeViewController.h
//  BabySong
//
//  Created by Matthew Lu on 31/03/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKProgressToolbar.h"
#import "Song.h"
#import "SongFactory.h"

#import "iCarousel.h"

#import "THLabel.h"

@interface UpgradeViewController : UIViewController<KKProgressToolbarDelegate,iCarouselDataSource,iCarouselDelegate>
{
    NSMutableArray *newMusicArray;
    //NSArray *songlist;
}

@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;

@property (weak, nonatomic) IBOutlet UIButton *restoreBtn;

@property (weak, nonatomic) IBOutlet UIButton *downloadAction;
@property (strong, nonatomic) KKProgressToolbar *statusToolbar;

@property (weak, nonatomic) IBOutlet UITableView *songsTableView;


@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
- (IBAction)restoreAction:(id)sender;

@property (weak, nonatomic) IBOutlet iCarousel *carousel;

@property (weak, nonatomic) IBOutlet THLabel *allSongDownloadedLabel;



@end
