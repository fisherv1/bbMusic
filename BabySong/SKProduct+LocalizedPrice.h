//
//  SKProduct+LocalizedPrice.h
//  BabySong
//
//  Created by Matthew Lu on 31/03/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)
@property(nonatomic,readonly)NSString *localizedPrice;

@end
