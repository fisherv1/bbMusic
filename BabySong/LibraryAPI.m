//
//  LibraryAPI.m
//  BabySong
//
//  Created by Matthew Lu on 17/09/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "LibraryAPI.h"
#import "Reachability.h"

@implementation LibraryAPI


+(LibraryAPI*)sharedInstance
{
    static LibraryAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc]init];
    });
    
    return  _sharedInstance;
}

+ (BOOL)isIOS7 {
    
    return  [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0;
}


+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark connectedToNetwork
+ (BOOL)checkForHOSTConnection
{
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus netStatus = [hostReach currentReachabilityStatus];
    
    BOOL connectable = TRUE;
    switch (netStatus)
    {
        case NotReachable:
        {
            connectable = FALSE;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"Please check your internet connection and try again. If possible, move to a location with better mobile reception, or connect to a Wi-Fi network."
                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
        case ReachableViaWiFi:
            connectable = TRUE;
            break;
        case ReachableViaWWAN:
            connectable = TRUE;
            break;
        default:
            connectable = TRUE;
            break;
    }
    return connectable;
}



@end
