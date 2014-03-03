//
//  SongFactory.m
//  BabySong
//
//  Created by Matthew Lu on 29/08/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "SongFactory.h"
#import "AppDelegate.h"


@implementation SongFactory



+(void)createSongs{
    
    NSArray* songList = [[NSArray alloc]initWithObjects:@"GoodMorning",@"WhiteChrismas",@"Jinglebells",@"LondonBridge",@"AlphabetSong",@"babyredhat",@"BicycleBuiltForTwo",@"biglittle",@"clap",@"GoodNight",@"indians",@"jimmyCrackCorn",@"rain",@"teapot",@"twinkle", nil];
    
    
    NSArray* songImgList = [[NSMutableArray alloc]initWithObjects:@"GoodMorning.jpg",@"WhiteChrismas.jpg",@"Jinglebells.jpg",@"LondonBridge.jpg",@"AlphabetSong.jpg",@"babyredhat.jpg",@"BicycleBuiltForTwo.jpg",@"bigLittle.jpg",@"clap.jpg",@"GoodNight.jpg",@"indians.jpg",@"jimmyCrackCorn.jpg",@"rain.jpeg",@"teapot.jpg",@"twinkle.png", nil];
    
    NSArray* songNameList = [[NSArray alloc]initWithObjects:@"Good Morning",@"White Chrismas",@"Jingle Bells",@"London Bridge",@"Alphabet Song",@"Baby Redhat",@"Bicycle Built For Two",@"Big Little",@"Clap",@"Good Night",@"Ten Little Indians",@"Jimmy Crack Corn",@"Rain",@"Teapot",@"Twinkle Twinkle Litter Star", nil];
    
     NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext];
    
    
    for (int i=0; i< [songList count]; i++) {
        Song *song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];
        song.songId = [NSNumber numberWithInt:i];
        
        song.fileName = [songList objectAtIndex:i];
        song.imgName = [songImgList objectAtIndex:i];
        song.displayName = [songNameList objectAtIndex:i];
        song.status = i > 3 ? [NSNumber numberWithBool:FALSE] : [NSNumber numberWithBool:TRUE];
        
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"could not save: %@",[error localizedDescription]);
        }
    }
}


+(NSArray*)getSongs:(BOOL)isActive
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.status = %d",[[NSNumber numberWithBool:isActive] intValue]   ];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}



+(void)updateSong:(int)songID
{
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.songId = %d",songID];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

    
    for (int i=0; i<[fetchedObjects count]; i++) {
        Song *song = [fetchedObjects objectAtIndex:i];
        song.status = [NSNumber numberWithBool:TRUE];
    }
    
    if(![context save:&error])
    {
        NSLog(@"could not save: %@",[error localizedDescription]);
    }
}

@end
