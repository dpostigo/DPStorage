//
// Created by Dani Postigo on 2/3/14.
//

#import <Foundation/Foundation.h>
#import "DPStorage.h"

@class DPItemsController;

@interface DPItemsStorage : DPStorage {
    NSMutableDictionary *itemControllers;
    NSMutableDictionary *controllerClasses;
    BOOL removesReplacedItems;

}

@property(nonatomic) BOOL removesReplacedItems;
@property(nonatomic, strong) NSMutableDictionary *itemControllers;
@property(nonatomic, strong) NSMutableDictionary *controllerClasses;

- (NSMutableArray *) arrayForKey: (NSString *) key;
- (void) setArray: (NSMutableArray *) array forKey: (NSString *) key;
- (DPItemsController *) createControllerForKey: (NSString *) key;
- (void) setupController: (DPItemsController *) controller forKey: (NSString *) key;
- (void) setControllerClass: (Class) class forKey: (NSString *) key;
- (void) setItemClass: (Class) class forKey: (NSString *) key;
@end