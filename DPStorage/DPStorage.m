//
// Created by Dani Postigo on 1/25/14.
//

#import <AutoCoding/AutoCoding.h>
#import "DPStorage.h"
#import "NSObject+AutoDescription.h"

@implementation DPStorage

@synthesize storageName;
@synthesize storageLocation;
@synthesize extension;

#ifdef NDEBUG
    // do nothing
    #define DPLog(...)
#else
#define DPLog NSLog
#endif

+ (NSDictionary *) codableProperties {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithDictionary: [super codableProperties]];
    if ([ret objectForKey: @"delegates"]) {
        [ret removeObjectForKey: @"delegates"];
    }
    return ret;
}


#pragma mark Destore

+ (instancetype) destoreWithName: (NSString *) aStorageName {
    return [self destoreWithName: aStorageName location: [[self class] storageLocation]];
}

+ (instancetype) destoreWithName: (NSString *) aStorageName location: (NSString *) location {
    return [self destoreWithName: aStorageName location: [[self class] storageLocation] extension: [[self class] extension]];
}

+ (instancetype) destoreWithName: (NSString *) aStorageName location: (NSString *) location extension: (NSString *) anExtension {
    id ret = [[self class] objectWithContentsOfFile: [[self class] storagePathWithName: aStorageName location: location extension: anExtension]];
    return ret;
}


#pragma mark Autocreate

+ (instancetype) autocreateWithName: (NSString *) aStorageName {
    return [[self class] autocreateWithName: aStorageName location: [[self class] storageLocation]];
}


+ (instancetype) autocreateWithName: (NSString *) aStorageName location: (NSString *) aLocation {
    return [[self class] autocreateWithName: aStorageName location: aLocation extension: [[self class] extension]];
}


+ (instancetype) autocreateWithName: (NSString *) aStorageName location: (NSString *) aLocation extension: (NSString *) anExtension {
    id ret = [[self class] objectWithContentsOfFile: [[self class] storagePathWithName: aStorageName location: aLocation extension: anExtension]];
    if (ret == nil) {
        ret = [[self class] storageWithName: aStorageName];

    } else {
        NSLog(@"Restored from name: %@", aStorageName);
        [ret setupStorage];
        //        NSLog(@"ret = %@", ret);
    }
    return ret;
}

#pragma mark Create

- (instancetype) initWithName: (NSString *) aStorageName {
    self = [super init];
    if (self) {
        storageName = aStorageName;
        [self setupStorage];
    }

    return self;
}

+ (instancetype) storageWithName: (NSString *) aStorageName {
    return [[self alloc] initWithName: aStorageName];
}

- (void) setupStorage {

}

#pragma mark Methods


- (void) save {
    NSString *location = self.storagePath;
    //    NSLog(@"Writing to location: %@", location);
    [self writeToFile: location atomically: YES];

}

- (instancetype) destore {
    id instance = [[self class] objectWithContentsOfFile: self.storagePath];
    return instance;
}


- (NSString *) description {
    return [self autoDescription];
}




#pragma mark Setters

- (void) setStorageName: (NSString *) storageName1 {
    storageName = [storageName1 mutableCopy];
}



#pragma mark Getters

- (NSString *) storagePath {
    return [[self class] storagePathWithName: self.storageName location: self.storageLocation extension: self.extension];
}

- (NSString *) storageLocation {
    if (storageLocation == nil) {
        storageLocation = [[self class] storageLocation];
    }
    return storageLocation;
}

- (NSString *) extension {
    if (extension == nil) {
        extension = [[self class] extension];
    }
    return extension;
}


#pragma mark Defaults


+ (NSString *) storagePathWithName: (NSString *) aStorageName {
    return [[self class] storagePathWithName: aStorageName location: [[self class] storageLocation] extension: [[self class] extension]];
}

+ (NSString *) storagePathWithName: (NSString *) aStorageName location: (NSString *) location extension: (NSString *) anExtension {
    return [location stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.%@", aStorageName, anExtension]];
}


+ (NSString *) storageLocation {
    return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
}


+ (NSString *) extension {
    return @"plist";
}


@end