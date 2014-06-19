//
//  SAEntryTable.m
//  SandArtApp
//
//  Created by calvin on 2014. 1. 7..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SAEntryTable.h"
#import "SAEntry.h"
#import <sys/xattr.h>

@implementation SAEntryTable

- (SAEntryTable *)initWithLangKeys:(NSArray *) langKeys {
    self = [self init];
    
    if (self) {
        self.entries = [[NSMutableArray alloc] init];
        for (NSString *langKey in langKeys) {
            SAEntry *entry = [SAEntry restoreForKey:langKey];
            if (!entry) {
                entry = [[SAEntry alloc] initWithLangKey:langKey];
                entry.download = nil;
                entry.pathToFile = nil;
                entry.progress = 0;
            }
            [self.entries addObject:entry];
        }
    }
    
    return self;
}

- (NSUInteger)count {
    return [self.entries count];
}

- (SAEntry *)entryAtIndex:(NSInteger) index {
    SAEntry *entry = [self.entries objectAtIndex:index];
    return entry;
}

- (SAEntry *)entryWithLangKey:(NSString *) langKey {
    for (SAEntry *entry in self.entries) {
        if (0 == [langKey compare:entry.langKey])
            return entry;
    }
    return nil;
}

- (NSInteger)indexForLangKey:(NSString *) langKey {
    for (int i = 0; i < [self.entries count]; i++) {
        SAEntry *entry = (SAEntry *)[self.entries objectAtIndex:i];
        if (0 == [langKey compare:entry.langKey])
            return i;
    }
    return -1;
}

+ (NSArray *)productIdentifiers
{
    NSDictionary *paths = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Download Paths"];
    return [paths allKeys];
}

/*
+ (NSString *)storePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *_storePath = [documentsDirectory stringByAppendingPathComponent:@"SandArt/"];
    return _storePath;
}
*/


+ (NSString *)applicationDocumentsDirectory {
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL* pathURL = [NSURL fileURLWithPath:documentPath];
    
    NSLog(@"app String = %@", documentPath);
    NSLog(@"app URL = %@", pathURL);
    
    [self addSkipBackupAttributeToItemAtURL:pathURL];
    
    return documentPath;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "org.kccc.P4U";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result = 0;
}


+ (NSString *)pathWithLangKey:(NSString *)langKey
{
    NSString *path = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Download Paths"] objectForKey:langKey];
    NSString *filenameAndExtension = [path lastPathComponent];
    //return [[SAEntryTable storePath] stringByAppendingPathComponent:filenameAndExtension];
    return [[SAEntryTable applicationDocumentsDirectory] stringByAppendingPathComponent:filenameAndExtension];
}

@end
