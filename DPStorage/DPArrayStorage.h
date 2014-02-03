//
// Created by Dani Postigo on 1/25/14.
//

#import <Foundation/Foundation.h>
#import "DPStorage.h"

@class ArrayController;


static char DPArrayStorageContext;

@interface DPArrayStorage : DPStorage {
    NSMutableDictionary *arrayControllers;
}

@property(nonatomic, strong) NSMutableArray *exampleItems;
@property(nonatomic, strong) NSMutableDictionary *arrayControllers;

- (NSMutableArray *) arrayForKey: (NSString *) key;
- (void) setArray: (NSMutableArray *) array ForKey: (NSString *) key;
- (ArrayController *) arrayControllerForKey: (NSString *) key;
- (void) addControllerObserver: (ArrayController *) controller;
@end