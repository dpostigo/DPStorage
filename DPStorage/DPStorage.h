//
// Created by Dani Postigo on 1/25/14.
//

#import <Foundation/Foundation.h>
#import <DPObject/BasicDelegater.h>

@interface DPStorage : BasicDelegater {

    NSString *storageName;
    NSString *storageLocation;
    NSString *extension;

}

@property(nonatomic, copy) NSString *storageName;
@property(nonatomic, copy) NSString *storageLocation;
@property(nonatomic, copy) NSString *extension;


+ (NSString *) storageLocation;
+ (NSString *) extension;

- (instancetype) initWithName: (NSString *) aStorageName;
+ (instancetype) storageWithName: (NSString *) aStorageName;
+ (instancetype) destoreWithName: (NSString *) aStorageName;
+ (instancetype) destoreWithName: (NSString *) aStorageName location: (NSString *) location;
+ (instancetype) destoreWithName: (NSString *) aStorageName location: (NSString *) location extension: (NSString *) anExtension;


+ (instancetype) autocreateWithName: (NSString *) aStorageName;
+ (instancetype) autocreateWithName: (NSString *) aStorageName location: (NSString *) aLocation;
+ (instancetype) autocreateWithName: (NSString *) aStorageName location: (NSString *) aLocation extension: (NSString *) anExtension;

- (void) setupStorage;
- (void) save;
- (instancetype) destore;


@end