//
//  InAppPurchaseManager.m
//  BabySong
//
//  Created by Matthew Lu on 31/03/13.
//  Copyright (c) 2013 Matthew Lu. All rights reserved.
//

#import "InAppPurchaseManager.h"

#define  kInAppPurchaseProUpgradeProductId @"net.ihelloworld.bbsong.proupgrade"

@implementation InAppPurchaseManager

-(void)requestProUpgradeProdcutData
{
    @try {
        NSSet *productIdentifiers =[NSSet setWithObject:@"net.ihelloworld.bbsong.proupgrade"];
        productsRequest =[[SKProductsRequest alloc]initWithProductIdentifiers:productIdentifiers];
        productsRequest.delegate = self;
        [productsRequest start];

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    }


// call this method once on startup
-(void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
    
    //get the product description (defined in early sections)
    [self requestProUpgradeProdcutData];
}


// call this before making a purchase
-(BOOL)canMakePurchases
{

    return [SKPaymentQueue canMakePayments];
}


// kick off the upgrade transcation

-(void)purchaseProUpgrade
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kInAppPurchaseProUpgradeProductId];
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}



#pragma -
#pragma Purchase helpers

//saves a record of the transcation by storing the receipt to disk

-(void)recordTransaction:(SKPaymentTransaction*)transaction
{
    
    if([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


// enable pro features
-(void)provideContent:(NSString*)productId
{
    
    if([productId isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        //enable the pro features
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isProUpgradePurchased"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
}


//removes the transaction from the queue and posts a notification with the transaction result

-(void)finishTransaction:(SKPaymentTransaction*)transaction wasSuccessful:(BOOL)wasSuccessful
{
//remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction,@"transaction", nil];
    
    
    if(wasSuccessful)
    {
        //send out a notification that we've finished the transaction
        [[NSNotificationCenter defaultCenter]postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    
    else
    {
        //send out a notificaton for the failed transaction
         [[NSNotificationCenter defaultCenter]postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

// called when the transaction was successfull
-(void)completeTransaction:(SKPaymentTransaction*)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}


// called when a transaction has been restored and successfully completed

-(void)restoreTransaction:(SKPaymentTransaction*)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    
    
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction,@"transaction", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    
    
}





//called when a transaction has failed
-(void)failedTransaction:(SKPaymentTransaction*)transaction
{
    if(transaction.error.code!=SKErrorPaymentCancelled)
    {
        //error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        //this is fine the user just cancelled,so dont notify
        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    }
}



#pragma mark -
#pragma mark SKProductsRequestDelegate methods

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    proUpgradeProduct = [products count]==1 ? [products objectAtIndex:0] : nil;
    
    if(proUpgradeProduct)
    {
        NSLog(@"Product title: %@",proUpgradeProduct.localizedTitle);
        NSLog(@"Product description: %@",proUpgradeProduct.localizedDescription);
        NSLog(@"Product price: %@",proUpgradeProduct.price);
        NSLog(@"Product id:%@",proUpgradeProduct.productIdentifier);
    }
    
    
    for(NSString *invalidProdcutid in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id:%@",invalidProdcutid);
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
    
    
}



#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//called when the transaction status is updated
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for(SKPaymentTransaction *transaction in transactions)
    {
    
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
        
    }

    
}









@end
