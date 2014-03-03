//
//  RageIAPHelper.m
//  BabySong
//
//  Created by Matthew Lu on 1/04/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper
+(RageIAPHelper*)sharedInstance
{
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    
    dispatch_once(&once,^{
        NSSet *productIdentifiers = [NSSet setWithObjects:@"net.ihelloworld.bbsong.proupgrade", nil];
        sharedInstance = [[self alloc]initWithProductIdentifiers:productIdentifiers];
    
    });
    
    return sharedInstance;
}

@end
