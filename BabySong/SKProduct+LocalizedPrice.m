//
//  SKProduct+LocalizedPrice.m
//  BabySong
//
//  Created by Matthew Lu on 31/03/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "SKProduct+LocalizedPrice.h"

@implementation SKProduct (LocalizedPrice)

-(NSString*)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [numberFormatter setLocale:self.priceLocale];
    
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    
    
    return formattedString;
}

@end
