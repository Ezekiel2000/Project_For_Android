//
//  SASandArtTableViewController.h
//  SandArtApp
//
//  Created by calvin on 2014. 1. 4..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCBlobDownload/TCBlobDownloadManager.h>
#import <StoreKit/StoreKit.h>
#define SASKPaymentTransactionObserverKey @"SASKPaymentTransactionObserverKey"

@interface SASandArtTableViewController : UITableViewController <TCBlobDownloadDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, unsafe_unretained) TCBlobDownloadManager *sharedDownloadManager;
@property(nonatomic, retain) NSArray *products;

- (IBAction)download:(id)sender;
- (IBAction)cancelDownloading:(id)sender;
- (void)reloadEntryTableWithLangKey:(NSString *)langKey;

@end
