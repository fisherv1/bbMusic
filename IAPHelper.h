//
//  IAPHelper.h
//  BabySong
//
//  Created by Matthew Lu on 1/04/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray* products);

@interface IAPHelper : NSObject

-(id)initWithProductIdentifiers:(NSSet*)productIdentifiers;
-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

-(void)buyProduct:(SKProduct *)product;
-(BOOL)productPurchased:(NSString*)productIdentifier;
-(void)restoreCompletedTransactions;
@end
