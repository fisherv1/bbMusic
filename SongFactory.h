//
//  SongFactory.h
//  BabySong
//
//  Created by Matthew Lu on 29/08/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
@interface SongFactory : NSObject


+(void)createSongs;

+(NSArray*)getSongs:(BOOL)isActive;
+(void)updateSong:(int)songID;
@end
