//
//  SASettingTableViewController.m
//  SandArtApp
//
//  Created by Calvin on 2014. 1. 28..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SASettingTableViewController.h"
#import "SAContactTableViewController.h"
#import "SASandArtTableViewController.h"
#import "SAEntry.h"
#import "SAEntryTable.h"
#import <StoreKit/StoreKit.h>

@interface SASettingTableViewController ()

@end

@implementation SASettingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    // Restore Purchases
                    [self restoreCompletedTransactions];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    // Remove All Files
                    [self showConfirmAlertViewWithTag:1 WithTitle:NSLocalizedString(@"Confirm", @"Confirm") WithMessage:NSLocalizedString(@"Remove_All_Files", @"Are you sure?")];
                    break;
                case 1:
                    // Remove All Contacts
                    [self showConfirmAlertViewWithTag:2 WithTitle:NSLocalizedString(@"Confirm", @"Confirm") WithMessage:NSLocalizedString(@"Remove_All_Contacts", @"Are you sure?")];
                    break;
            }
            break;
        case 2:
            // Links
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://everykoreanstudent.com"]];
                    break;
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sandartp4u.com"]];
                    break;
            } 
        case 3:
            // Credit
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            break;
    }
}

- (void)removeAllFiles
{
    NSArray *productIdentifiers = [SAEntryTable productIdentifiers];
    NSError *error = nil;
    
    for (NSString *productIdentifier in productIdentifiers) {
        SAEntry *entry = [SAEntry restoreForKey:productIdentifier];
        if (entry.status == SAEntryStatusDownloaded) {
            NSString *storedPath = [SAEntryTable pathWithLangKey:productIdentifier];
            BOOL success = [SASettingTableViewController removeStoredFileWithLangKey:productIdentifier andError:error];
            if (!success || error) {
                // it failed.
                NSLog(@"%@", error);
            } else {
                NSLog(@"File Manager removed %@", storedPath);
                entry.status = SAEntryStatusNotDownloaded;
                [entry persistForKey:productIdentifier];
                SASandArtTableViewController *tvc = (SASandArtTableViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
                [tvc reloadEntryTableWithLangKey:productIdentifier];
                [tvc.tableView reloadData];
            }
        }
    }
}

+ (BOOL)removeStoredFileWithLangKey:(NSString *)langKey andError:(NSError *)error
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *storedPath = [SAEntryTable pathWithLangKey:langKey];
    BOOL success = [fm removeItemAtPath:storedPath error:&error];
    return success;
}

#pragma mark - In-App Purchase Restoration

- (void)restoreCompletedTransactions {
    // It will be handled by the delegate, SASandArtTableViewController.
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restore failed %@", error);
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Restored!");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    NSString *langKey = transaction.payment.productIdentifier;
    NSLog(@"langkey = %@", langKey);
    SAEntry *entry = [SAEntry restoreForKey:langKey];
    if (entry.status == SAEntryStatusNotPurchased) {
        NSLog(@"status = %d", entry.status);
        entry.status = SAEntryStatusNotDownloaded;
        [entry persistForKey:langKey];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - Alert View 
- (void)showConfirmAlertViewWithTag:(NSUInteger)tag WithTitle:(NSString *)title WithMessage:(NSString *)message
{
    NSBundle* uikitBundle = [NSBundle bundleForClass:[UIButton class]];
    UIAlertView *av =
    [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(title, title)
     message:NSLocalizedString(message, message)
     delegate:self
     cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Cancel", @"Localizable", uikitBundle, nil)
     otherButtonTitles:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", uikitBundle, nil), nil];
    av.tag = tag;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            if (1 == alertView.tag) {
                [self removeAllFiles];
            } else if (2 == alertView.tag) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:SAContactArrayKey];
                [defaults synchronize];
                UINavigationController *nc = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:1];
                SAContactTableViewController *tvc = (SAContactTableViewController *)nc.topViewController;
                [tvc.tableView reloadData];
            }
            break;
            
        default:
            // do nothing
            break;
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
