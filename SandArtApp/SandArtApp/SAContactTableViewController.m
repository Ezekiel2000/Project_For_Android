//
//  SAContactTableViewController.m
//  SandArtApp
//
//  Created by Calvin on 2014. 1. 21..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SAContactTableViewController.h"

@interface SAContactTableViewController ()

@end

@implementation SAContactTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.tableView endEditing:YES];
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    [self.tableView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *contactArray = (NSArray *)[defaults objectForKey:SAContactArrayKey];
    if (!contactArray) {
        return 0;
    }
    return [contactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Contact Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:2];
    
    NSInteger index = indexPath.row;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *contactArray = (NSArray *)[defaults objectForKey:SAContactArrayKey];
    if (contactArray) {
        NSDictionary *contact = (NSDictionary *)[contactArray objectAtIndex:index];
        
        NSString *nameString = (NSString *)[contact objectForKey:SAContactNameKey];
        // NSString *phoneString = (NSString *)[contact objectForKey:SAContactPhoneKey];
        // NSString *emailString = (NSString *)[contact objectForKey:SAContactEmailKey];
        // NSString *memoString = (NSString *)[contact objectForKey:SAContactMemoKey];
        
        NSDate *date = (NSDate *)[contact objectForKey:SAContactDateKey];
        NSString *dateString = [SAContactTableViewController stringForDate:date withDateFormat:@"YYYY-MM-dd"];
        
        dateLabel.text = dateString;
        nameLabel.text = [nameString length] < 1 ? @" " : nameString;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath)
        return;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *contactArray = (NSArray *)[defaults objectForKey:SAContactArrayKey];
        NSMutableArray *contactMutableArray = [[NSMutableArray alloc] initWithArray:contactArray];
        [contactMutableArray removeObjectAtIndex:[indexPath row]];
        [defaults setObject:[NSArray arrayWithArray:contactMutableArray] forKey:SAContactArrayKey];
        [self.tableView endUpdates];
//        [self.tableView reloadData];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Contact"]) {
        UIViewController *dest = (UIViewController *)[segue destinationViewController];
        UIView *contactView = [dest.view viewWithTag:9];
        
        UILabel *nameLabel = (UILabel *)[contactView viewWithTag:1];
        
        // 개인 수정한 곳
        UITextView *emailField = (UITextView*)[contactView viewWithTag:2];
        UITextView *phoneField = (UITextView*)[contactView viewWithTag:3];
        
        UILabel *memoLabel = (UILabel *)[contactView viewWithTag:4];
        UILabel *dateLabel = (UILabel *)[contactView viewWithTag:5];
        //
        
        NSArray *contactArray = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:SAContactArrayKey];
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *contact = [contactArray objectAtIndex:[indexPath row]];
        
        nameLabel.text = (NSString *)[contact objectForKey:SAContactNameKey];
        
        // 개인 수정한 곳
        emailField.text = (NSString *)[contact objectForKey:SAContactEmailKey];
        phoneField.text = (NSString *)[contact objectForKey:SAContactPhoneKey];
        //
        
        memoLabel.text = (NSString *)[contact objectForKey:SAContactMemoKey];
        NSDate *date = (NSDate *)[contact objectForKey:SAContactDateKey];
        dateLabel.text = [SAContactTableViewController stringForDate:date withDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
        // 개인 수정한 곳
        [emailField setEditable:FALSE];
        [phoneField setEditable:FALSE];
    }
}

#pragma mark - Utils

+ (NSString *)stringForDate:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    [dateFormat setLocale:[NSLocale currentLocale]];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

@end
