//
// Created by Dani Postigo on 2/3/14.
//

#import <Foundation/Foundation.h>
#import "DPStorage.h"

@class DPItemsController;

@interface DPArrayStorageObject : DPStorage {

    __strong Class defaultStorageClass;
    NSMutableDictionary *storageControllers;
    NSMutableDictionary *customStorageClasses;
    BOOL removesReplacedItems;

}

@property(nonatomic) BOOL removesReplacedItems;
@property(nonatomic, strong) NSMutableDictionary *storageControllers;
@property(nonatomic, strong) NSMutableDictionary *customStorageClasses;
@property(nonatomic, strong) Class defaultStorageClass;
- (NSMutableArray *) arrayForKey: (NSString *) key;
- (void) setArray: (NSMutableArray *) array forKey: (NSString *) key;
- (DPItemsController *) storageForKey: (NSString *) key;
- (DPItemsController *) createStorageForKey: (NSString *) key;
- (void) setupStorage: (DPItemsController *) controller forKey: (NSString *) key;
- (void) setStorageClass: (Class) class forKey: (NSString *) key;
- (void) setItemClass: (Class) class forKey: (NSString *) key;
@end