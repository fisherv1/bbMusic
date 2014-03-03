//
//  LibraryAPI.h
//  BabySong
//
//  Created by Matthew Lu on 17/09/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryAPI : NSObject

+(LibraryAPI *)sharedInstance;
+ (BOOL)isIOS7;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

@end
