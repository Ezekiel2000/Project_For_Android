//
//  SAContactViewController.m
//  SandArtApp
//
//  Created by Calvin on 2014. 1. 21..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SAContactViewController.h"
#import "SAContactTableViewController.h"
#import "NBPhoneMetaData.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberDesc.h"
#import "NBPhoneNumberUtil.h"
#import "NBNumberFormat.h"

@interface SAContactViewController ()

@end

@implementation SAContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float navHeight = self.navigationController.navigationBar.frame.size.height;
    float tapHeight = self.tabBarController.tabBar.frame.size.height;
    float statHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    UIView *view = (UIView *)[scrollView viewWithTag:9];
    scrollView.contentInset = UIEdgeInsetsMake(-navHeight-statHeight, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height-tapHeight);
    
    // For phone number formatter
    for (NSUInteger i = 1; i <= 4; i++) {
        UITextField *textField = (UITextField *)[view viewWithTag:i];
        if ([textField isKindOfClass:[UITextField class]])
            textField.delegate = self;
    }
}

- (void)initScrollView:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    UIView *view = (UIView *)[scrollView viewWithTag:1];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Event Handling

- (IBAction)save:(id)sender
{
    UIView *contactView = [self.view viewWithTag:9];
    NSString *nameString = ((UITextField *)[contactView viewWithTag:1]).text;
    NSString *emailString = ((UITextField *)[contactView viewWithTag:2]).text;
    NSString *phoneString = ((UITextField *)[contactView viewWithTag:3]).text;
    NSString *memoString = ((UITextField *)[contactView viewWithTag:4]).text;
    NSDate *date = [[NSDate alloc] init];
    
    NSDictionary *contact = [NSDictionary dictionaryWithObjectsAndKeys:nameString, SAContactNameKey, emailString, SAContactEmailKey, phoneString, SAContactPhoneKey, memoString, SAContactMemoKey, date, SAContactDateKey, nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *contactArray = (NSArray *)[defaults objectForKey:SAContactArrayKey];
    NSMutableArray *contactMutableArray = [[NSMutableArray alloc] initWithArray:contactArray];
    [contactMutableArray insertObject:contact atIndex:0];
    [defaults setObject:[NSArray arrayWithArray:contactMutableArray] forKey:SAContactArrayKey];
    
    // Go back to the list.
    UITableViewController *contactList = (UITableViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    [contactList.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - Keyboard Handling

#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

// Set Next responder
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Done
    if (nextTag > 4) {
        [self save:textField];
    }
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString   *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    
    NSError *aError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:textField.text defaultRegion:countryCode error:&aError];
    
    if (aError == nil) {
        textField.text = [phoneUtil format:myNumber numberFormat:NBEPhoneNumberFormatNATIONAL
                                     error:&aError];
    }
    else {
        NSLog(@"Error : %@", [aError localizedDescription]);
    }
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
    }
    return mobileNumber;
}

-(int)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    return length;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
