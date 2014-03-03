//
//  SongNameTableViewController.h
//  BabySong
//
//  Created by Matthew Lu on 2/06/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongNameTableViewController : UITableViewController
{
    NSString *songName;
  //  NSMutableArray *songNameList;
   // NSMutableArray *songImgList;
    
     NSArray *songList;
    NSInteger songIndex;
}

@end
