//
//  InAppPurchaseManager.h
//  BabySong
//
//  Created by Matthew Lu on 31/03/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"






@interface InAppPurchaseManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{

    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}


//public methods
-(void)loadStore;
-(BOOL)canMakePurchases;
-(void)purchaseProUpgrade;



@end
