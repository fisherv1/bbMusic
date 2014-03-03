//
//  AppDelegate.h
//  BabySong
//
//  Created by Matthew Lu on 30/01/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    NSMutableArray *songList;
    
}

-(NSString*)logfile;

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSMutableArray *songList;
@property(nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
