//
//  SASettingTableViewController.h
//  SandArtApp
//
//  Created by Calvin on 2014. 1. 28..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface SASettingTableViewController : UITableViewController <SKPaymentTransactionObserver, UIAlertViewDelegate>

+ (BOOL)removeStoredFileWithLangKey:(NSString *)langKey andError:(NSError *)error;

@end