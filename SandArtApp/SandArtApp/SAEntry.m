//
//  SAEntry.m
//  SandArtApp
//
//  Created by calvin on 2014. 1. 7..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SAEntry.h"

@implementation SAEntry

- (SAEntry *) init {
    self = [super init];
    
    if (self) {
        self.langKey = @"Not Found";
        self.status = SAEntryStatusNotPurchased;
    }
    
    return self;
}

- (SAEntry *) initWithLangKey:(NSString *) langKey {
    self = [self init];
    
    if (self) {
        self.langKey = langKey;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.langKey forKey:@"langKey"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeInt:self.status forKey:@"status"];
    [encoder encodeFloat:self.progress  forKey:@"progress"];
    [encoder encodeObject:self.pathToFile forKey:@"pathToFile"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.langKey = [decoder decodeObjectForKey:@"langKey"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.status = [decoder decodeIntForKey:@"status"];
        self.progress = [decoder decodeFloatForKey:@"progress"];
        self.pathToFile = [decoder decodeObjectForKey:@"pathToFile"];
    }
    return self;
}

- (void) persistForKey:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (SAEntry *) restoreForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    SAEntry *entry;
    if (encodedObject) {
        entry = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return entry;
}

@end
