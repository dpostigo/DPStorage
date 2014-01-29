//
// Created by Dani Postigo on 1/25/14.
//

#import <Foundation/Foundation.h>
#import "DPStorage.h"

@class ArrayController;


static char DPArrayStorageContext;

@interface DPArrayStorage : DPStorage

@property(nonatomic, retain) NSMutableArray *exampleItems;

- (NSMutableArray *) arrayForKey: (NSString *) key;
- (void) setArray: (NSMutableArray *) array ForKey: (NSString *) key;
- (ArrayController *) arrayControllerForKey: (NSString *) key;
@end