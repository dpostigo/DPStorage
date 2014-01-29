//
// Created by Dani Postigo on 1/25/14.
//

#import "ArrayController.h"

@interface ArrayController () {
    NSMutableArray *dataArray;
}

@property(nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation ArrayController

@synthesize dataArray;

- (NSMutableArray *) dataArray {
    if (dataArray == nil) {
        dataArray = [[NSMutableArray alloc] init];
    }
    return dataArray;
}


- (void) addObserver: (NSObject *) observer forKeyPath: (NSString *) keyPath options: (NSKeyValueObservingOptions) options context: (void *) context {
    if ([keyPath isEqualToString: @"items"]) {
        keyPath = @"dataArray";
    }
    [super addObserver: observer forKeyPath: keyPath options: options context: context];
}


- (void) setItems: (NSMutableArray *) items {
    [self setValue: items forKey: @"dataArray"];

}

- (NSMutableArray *) items {
    return [self mutableArrayValueForKey: @"dataArray"];
}

//
//- (NSUInteger) countOfItems {
//    return [self.dataArray count];
//}
//
////
////- (id) objectInItemsAtIndex: (NSUInteger) index {
////    return [self.items objectAtIndex: index];
////}
//
//- (NSArray *) itemsAtIndexes: (NSIndexSet *) indexes {
//    return [self.dataArray objectsAtIndexes: indexes];
//}
//
//- (void) getItems: (id __unsafe_unretained *) buffer range: (NSRange) inRange {
//    [self.dataArray getObjects: buffer range: inRange];
//}
//
//
//- (void) insertItems: (NSArray *) employeeArray atIndexes: (NSIndexSet *) indexes {
//    [self.dataArray insertObjects: employeeArray atIndexes: indexes];
//    return;
//}
//
//- (void) removeItemsAtIndexes: (NSIndexSet *) indexes {
//    [self.dataArray removeObjectsAtIndexes: indexes];
//}
//
//- (void) replaceItemsAtIndexes: (NSIndexSet *) indexes withItems: (NSArray *) employeeArray {
//    [self.dataArray replaceObjectsAtIndexes: indexes withObjects: employeeArray];
//}



@end