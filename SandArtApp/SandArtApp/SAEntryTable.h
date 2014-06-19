//
//  SAEntryTable.h
//  SandArtApp
//
//  List of entries,
//  which are list of SAEntry instances.
//
//  Created by calvin on 2014. 1. 7..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAEntry.h"
#import <sys/xattr.h>

@interface SAEntryTable : NSObject

@property (nonatomic, retain) NSMutableArray *entries;

- (SAEntryTable *) initWithLangKeys:(NSArray *) langKeys;
- (NSUInteger) count;
- (SAEntry *) entryAtIndex:(NSInteger) index;
- (SAEntry *) entryWithLangKey:(NSString *) langKey;
- (NSInteger) indexForLangKey:(NSString *) langKey;



+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString *)applicationDocumentsDirectory;



+ (NSArray *)productIdentifiers;
//+ (NSString *)storePath;
+ (NSString *)pathWithLangKey:(NSString *)langKey;

@end
