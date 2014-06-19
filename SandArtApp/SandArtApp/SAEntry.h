//
//  SAEntry.h
//  SandArtApp
//
//  Entry represents a single Sand Art content of the version of the specific language.
//  It can be purchased and downloaded individually.
//
//  Created by calvin on 2014. 1. 7..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TCBlobDownload/TCBlobDownloadManager.h>

enum {
    SAEntryStatusNotPurchased  = 0,
    SAEntryStatusNotDownloaded = 1,
    SAEntryStatusDownloading   = 2,
    SAEntryStatusDownloaded    = 4,
};
typedef int SAEntryStatus;

@interface SAEntry : NSObject

@property (nonatomic, retain)   NSString        *langKey;
@property (nonatomic, retain)   NSString        *title;
@property (nonatomic, retain)   NSString        *price;
@property (nonatomic)           int             status;
@property (nonatomic, retain)   TCBlobDownload  *download;
@property (nonatomic)           float           progress;
@property (nonatomic, retain)   NSString        *pathToFile;

- (SAEntry *) init;
- (SAEntry *) initWithLangKey:(NSString *) langKey;
- (void) persistForKey:(NSString *)key;
+ (SAEntry *) restoreForKey:(NSString *)key;

@end
