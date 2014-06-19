//
//  SASandArtTableViewController.m
//  SandArtApp
//
//  Created by calvin on 2014. 1. 4..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SASandArtTableViewController.h"
#import "SAContactTableViewController.h"
#import "MACircleProgressIndicator.h"
#import "SASettingTableViewController.h"
#import "SAEntry.h"
#import "SAEntryTable.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SASandArtTableViewController ()

@end

@implementation SASandArtTableViewController {
    SAEntryTable *entryTable;
    NSString *storePath;
    NSArray *PRODUCT_IDENTIFIERS;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* DESIGN */

    // set bottom margin for tab bar.
    int tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarHeight, 0);

    // insert sand top-beyond 0 position.
    UIImage *sandImage = [UIImage imageNamed:@"Sand.png"];
    UIImageView *sandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -150, self.getScreenFrameForCurrentOrientation.size.width, 150)];
    sandImageView.contentMode = UIViewContentModeScaleAspectFill;
    sandImageView.image = sandImage;
    sandImageView.tag = 99;
    [self.tableView addSubview:sandImageView];
    
    // customization of circle indicator
    MACircleProgressIndicator *appearance = [MACircleProgressIndicator appearance];
    
    // The color property sets the actual color of the procress circle (how suprising ;) )
    appearance.color = kMainColor;
    
    // Use the strokeWidth property to set the width of the
    // circle stroke excplicitly.
    appearance.strokeWidth = 1.0;
    
    // If you set the strokeWidthRatio, the width of the
    // circle stroke gets calculated related to the actual
    // size of the MACircleProgressIndicator view.
    //appearance.strokeWidthRatio = 0.15; // default ratio, just for information :)
    
    /* CONTENT */
    
    // initialize pre-defined texts.
    if (!entryTable) {
        PRODUCT_IDENTIFIERS = [NSArray arrayWithObjects:
                                @"Korean", @"English", @"Chinese", @"ChineseTraditional",
                                @"Japanese", @"Russian", @"French", @"Spanish", @"Hindi",
                                @"Mongolia", @"Polish", @"Turkish", @"Nepali", @"Indonesia", nil];
        entryTable = [[SAEntryTable alloc] initWithLangKeys:PRODUCT_IDENTIFIERS];
        [self validateProductIdentifiers:PRODUCT_IDENTIFIERS];
    }
    
    /* DOWNLOAD */
    if (!self.sharedDownloadManager)
    {
        self.sharedDownloadManager = [TCBlobDownloadManager sharedDownloadManager];
        //storePath = [SAEntryTable storePath];
        storePath = [SAEntryTable applicationDocumentsDirectory];
        
        
        // remove all
        // [[NSFileManager defaultManager] removeItemAtPath:storePath error: nil];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIImageView *imageView = (UIImageView *)[self.tableView viewWithTag:99];
    imageView.frame = CGRectMake(0, -150, self.getScreenFrameForCurrentOrientation.size.width, 150);
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        NSLog(@"Change to custom UI for landscape");
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
             toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        NSLog(@"Change to custom UI for portrait");
        
    }
    
    // Need to redraw horizontal lines for table cells
    [self.tableView setNeedsDisplay];
    
    // Redraw circle indicators for changing of x positions
    for (int i = 0; i < [entryTable count]; i++)
    {
        SAEntry *entry = [entryTable entryAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
        [self update:indexPath withStatus:entry.status];
    }
}

- (CGRect)getScreenFrameForCurrentOrientation {
    return [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    if(!statusBarHidden){
        CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
        fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}

- (void)setSelectedTabBarItemImage:(NSString *)name
{
    // Changes SelectedTabBarItem Image
    self.tabBarItem.selectedImage = [UIImage imageNamed:name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event handlers

- (IBAction)purchase:(id)sender
{
    UIButton *priceButton = (UIButton *)sender;
    UIButton *button = (UIButton *)[[priceButton superview] viewWithTag:2];
    NSString *langKey = [[button titleForState:UIControlStateApplication] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    priceButton.hidden = YES;
    MACircleProgressIndicator *indicator = (MACircleProgressIndicator *)[[button superview] viewWithTag:3];
    indicator.hidden = NO;
    [indicator startWaiting];
    
    SKProduct *product = [self productForKey:langKey];
    [self paymentRequest:product];
}

- (IBAction)download:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *langKey = [button titleForState:UIControlStateApplication];
    [self downloadWithLangKey:langKey];
}

- (void)downloadWithLangKey:(NSString *)langKey
{
    SAEntry *entry = [entryTable entryWithLangKey:langKey];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[entryTable indexForLangKey:langKey] inSection:1];
    // UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    // id sender = [cell.contentView viewWithTag:2];
    
    if (SAEntryStatusNotDownloaded == entry.status) {
        // download the content
        NSString *targetPath = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Download Paths"] objectForKey:langKey];
        NSURL *targetURL = [NSURL URLWithString:targetPath];
        NSLog(@"Start downloading...");
        TCBlobDownload *download = [self.sharedDownloadManager startDownloadWithURL:targetURL
                                                                         customPath:storePath
                                                                      firstResponse:^(NSURLResponse *response) {
                                                                          [self update:indexPath withStatus:SAEntryStatusDownloading];
                                                                      }
                                                                           progress:^(float receivedLength, float totalLength) {
                                                                               entry.progress = receivedLength / totalLength;
                                                                               [self updateDownloadIndicator:indexPath toValue:receivedLength / totalLength];
                                                                           }
                                                                              error:^(NSError *error) {
                                                                                  NSLog(@"%@", error);
                                                                                  [SASettingTableViewController removeStoredFileWithLangKey:langKey andError:error];
                                                                                  entry.download = nil;
                                                                              }
                                                                           complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                                               if (downloadFinished) {
                                                                                   entry.pathToFile = pathToFile;
                                                                                   entry.download = nil;
                                                                                   [self update:indexPath withStatus:SAEntryStatusDownloaded];
                                                                               }
                                                                           }];
        entry.progress = 0;
        entry.download = download;
    }
}

- (IBAction)cancelDownloading:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *langKey = [button titleForState:UIControlStateApplication];
    SAEntry *entry = [entryTable entryWithLangKey:langKey];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[entryTable indexForLangKey:langKey] inSection:1];

    TCBlobDownload *download = (TCBlobDownload *)entry.download;
    [download cancelDownloadAndRemoveFile:YES];
    [self update:indexPath withStatus:SAEntryStatusNotDownloaded];
}

- (IBAction)play:(id)sender
{
    SAEntry *entry = [self entryForSender:sender];
    if (entry.pathToFile) {
        NSURL *url = [NSURL fileURLWithPath:entry.pathToFile];
        MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        movieViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        // Add DidFinish notification to self
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerPlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:movieViewController.moviePlayer];
        
        // Present movie player view controller
        [self presentViewController:movieViewController animated:YES completion:nil];
    }
}

# pragma mark - Event helplers

-(void)moviePlayerPlaybackDidFinish:(NSNotification *)notification {
    // MPMoviePlayerController *moviePlayer = notification.object;
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    //movie finished playing
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        // Select Contact tab.
        self.tabBarController.selectedIndex = 1;
        // Click the compose button.
        UINavigationController *nc = (UINavigationController *)self.tabBarController.selectedViewController;
        [nc popToRootViewControllerAnimated:YES];
        UITableViewController *vc = (UITableViewController *)[nc.viewControllers objectAtIndex:0];
        [vc performSegueWithIdentifier:@"Write Contact" sender:self];
    }else if (reason == MPMovieFinishReasonUserExited) {
        //user hit the done button
        NSLog(@"Done");
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        //error
        NSLog(@"Error");
    }
}

- (SAEntry *)entryForSender:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *langKey = [button titleForState:UIControlStateApplication];
    SAEntry *entry = [entryTable entryWithLangKey:langKey];
    return entry;
}

- (void)reloadEntryTableWithLangKey:(NSString *)langKey
{
    SAEntry *entry = [entryTable entryWithLangKey:langKey];
    SAEntry *new = [SAEntry restoreForKey:langKey];
    entry.status = new.status;
}
     
- (void)update:(NSIndexPath *)indexPath withStatus:(SAEntryStatus) status
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell viewWithTag:2];
    SAEntry *entry = [entryTable entryAtIndex:[indexPath row]];
    entry.status = status;
    [entry persistForKey:entry.langKey];
    [self updateButton:button withStatus:status];
}

- (void)updateButton:(UIButton *)button withStatus:(SAEntryStatus) status
{
    NSString *langKey = [button titleForState:UIControlStateApplication];
    SAEntry *entry = [entryTable entryWithLangKey:langKey];
    MACircleProgressIndicator *indicator = (MACircleProgressIndicator *)[[button superview] viewWithTag:3];
    UIButton *priceButton = (UIButton *)[[button superview] viewWithTag:4];
    
    // Circle Indicator
    if (!indicator) {
        indicator = [[MACircleProgressIndicator alloc] init];
        indicator.tag = 3;
        indicator.value = entry.progress;
        [[button superview] insertSubview:indicator belowSubview:button];
        CGRect frame = button.frame;
        frame.origin.x = frame.origin.x + frame.size.width / 2 - 13;
        frame.origin.y = frame.origin.y + 3;
        frame.size.width = 26;
        frame.size.height = 26;
        indicator.frame = frame;
    }
    
    indicator.hidden = YES;
    button.hidden = NO;
    priceButton.hidden = YES;
    
    switch (status) {
        case SAEntryStatusNotPurchased:
            button.hidden = YES;
            priceButton.hidden = NO;
            priceButton.titleLabel.text = entry.price;
            [priceButton setTitle:entry.price forState:UIControlStateNormal];
            [priceButton setTitle:entry.price forState:UIControlStateSelected];
            [priceButton addTarget:self action:@selector(purchase:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SAEntryStatusNotDownloaded:
            [button setImage:[UIImage imageNamed:@"Download.png"] forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button removeTarget:self action:@selector(cancelDownloading:) forControlEvents:UIControlEventTouchUpInside];
            [button removeTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SAEntryStatusDownloading:
            indicator.hidden = NO;
            [indicator stopWaiting];
            [button setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button removeTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
            [button removeTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(cancelDownloading:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case SAEntryStatusDownloaded:
            [button setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button removeTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
            [button removeTarget:self action:@selector(cancelDownloading:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            break;
    }
    
}

- (void)updateDownloadIndicator:(NSIndexPath *)indexPath toValue:(float)value
{
    MACircleProgressIndicator *indicator = [self indicatorAtIndexPath:indexPath];
    indicator.value = value;
}

- (MACircleProgressIndicator *)indicatorAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return (MACircleProgressIndicator *)[cell viewWithTag:3];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return [entryTable count];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (0 == [indexPath section]) ? 150 : 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = (0 == [indexPath section]) ? @"TopCell" : @"LangCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (0 != [indexPath section]) {
        UILabel *languageLabel = (UILabel *)[cell viewWithTag:1];
        SAEntry *entry = [entryTable entryAtIndex:[indexPath row]];
        [languageLabel setText:entry.langKey];
        if (entry.title)
            [languageLabel setText:entry.title];
        
        UIButton *actionButton = (UIButton *)[cell.contentView viewWithTag:2];
        // mark the target language as title of the button to download
        [actionButton setTitle:entry.langKey forState:UIControlStateApplication];
        [[cell viewWithTag:3] removeFromSuperview];
        [self updateButton:actionButton withStatus:entry.status];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == [indexPath section] && SAEntryStatusDownloaded == [entryTable entryAtIndex:[indexPath row]].status)
        return YES;
    else
        return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        SAEntry *entry = [entryTable entryAtIndex:[indexPath row]];
        [[NSFileManager defaultManager] removeItemAtPath:entry.pathToFile error:nil];
        entry.pathToFile = nil;
        [self update:indexPath withStatus:SAEntryStatusNotDownloaded];
        tableView.editing = FALSE;
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - In-App Purchase Handlers

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    [self.tableView reloadData];
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"Invalid: %@", invalidIdentifier);
    }
    [self displayStoreUI];
}

- (SKProduct *)productForKey:(NSString *)langKey
{
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:langKey]) {
            return product;
        }
    }
    return nil;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        if (0 != transaction.transactionState) {
            NSString *langKey = transaction.payment.productIdentifier;
            //[self stopWaiting:langKey];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[entryTable indexForLangKey:langKey] inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        }
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                // pass
            default:
                break;
        }
    }
}

- (void)stopWaiting:(NSString *)langKey
{
    // stop waiting indicator
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[entryTable indexForLangKey:langKey] inSection:1];
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    MACircleProgressIndicator *indicator = (MACircleProgressIndicator *)[cell.contentView viewWithTag:3];
    [indicator stopWaiting];
    indicator.hidden = YES;
    UIButton *priceButton = (UIButton *)[cell.contentView viewWithTag:4];
    priceButton.hidden = NO;
    NSLog(@"%@ %@", indicator, priceButton.titleLabel.text);
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Completed");
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    
    // You should make the update to your app based on what was purchased and inform user.
    NSString *langKey = transaction.payment.productIdentifier;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[entryTable indexForLangKey:langKey] inSection:1];
    [self update:indexPath withStatus:SAEntryStatusNotDownloaded];
    [self downloadWithLangKey:langKey];
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)displayStoreUI
{
    for (SKProduct *product in self.products) {
        NSLog(@"product: %@ %@ (%@)", product, product.localizedTitle ,[self formattedPrice:product]);
        NSString *langKey = product.productIdentifier;
        SAEntry *entry = [entryTable entryWithLangKey:langKey];
        entry.title = product.localizedTitle;
        entry.price = [self formattedPrice:product];
        [entry persistForKey:langKey];
    }
    [self.tableView reloadData];
}

- (NSString *)formattedPrice:(SKProduct *)product
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
    return formattedPrice;
}

- (void)paymentRequest:(SKProduct *)product
{
    if (!product) return;
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end




