//
//  SAContactTableViewController.h
//  SandArtApp
//
//  Created by Calvin on 2014. 1. 21..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SAContactArrayKey   @"SA Contact Array Key"
#define SAContactNameKey    @"SA Contact Name Key"
#define SAContactEmailKey   @"SA Contact Email Key"
#define SAContactPhoneKey   @"SA Contact Phone Key"
#define SAContactMemoKey    @"SA Contact Memo Key"
#define SAContactDateKey    @"SA Contact Date Key"

@interface SAContactTableViewController : UITableViewController

@property (nonatomic) BOOL FLAG_READY_TO_WRITE;

+ (NSString *)stringForDate:(NSDate *)date withDateFormat:(NSString *)format;

@end
