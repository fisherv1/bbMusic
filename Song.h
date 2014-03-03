//
//  Song.h
//  BabySong
//
//  Created by Matthew Lu on 3/09/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * songId;
@property (nonatomic, retain) NSString * imgName;
@property (nonatomic, retain) NSNumber * status;

@end
