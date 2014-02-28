//
// Created by Dani Postigo on 1/25/14.
//

#import <AutoCoding/AutoCoding.h>
#import "ArrayController.h"
#import "NSObject+AutoDescription.h"

@interface ArrayController () {
    NSMutableArray *dataArray;
    NSMutableArray *observers;
}

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *observers;

@end

@implementation ArrayController

@synthesize dataArray;
@synthesize observers;

+ (NSDictionary *) codableProperties {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithDictionary: [super codableProperties]];
    if ([ret objectForKey: @"items"]) {
        [ret removeObjectForKey: @"items"];
    }
    return ret;
}


- (NSString *) description {
    return [self autoDescription];
}


- (NSMutableArray *) dataArray {
    if (dataArray == nil) {
        dataArray = [[NSMutableArray alloc] init];
    }
    return dataArray;
}


- (void) addObserver: (NSObject *) observer forKeyPath: (NSString *) keyPath options: (NSKeyValueObservingOptions) options context: (void *) context {
    if ([keyPath isEqualToString: @"items"]) {
        keyPath = @"dataArray";
        [self.observers addObject: observer];
    } else {
        NSLog(@"%s, keyPath = %@", __PRETTY_FUNCTION__, keyPath);

    }

    [super addObserver: observer forKeyPath: keyPath options: options context: context];
}


- (void) removeObserver: (NSObject *) observer forKeyPath: (NSString *) keyPath {
    if ([keyPath isEqualToString: @"items"]) {
        keyPath = @"dataArray";
        [self removeObserver: observer];
    }
    [super removeObserver: observer forKeyPath: keyPath];
}

- (void) removeObserver: (NSObject *) observer forKeyPath: (NSString *) keyPath context: (void *) context {
    if ([keyPath isEqualToString: @"items"]) {
        keyPath = @"dataArray";
        [self removeObserver: observer];
    }
    [super removeObserver: observer forKeyPath: keyPath context: context];
}


- (BOOL) hasObserver: (NSObject *) observer {
    return [self.observers containsObject: observer];
}


- (void) removeObserver: (NSObject *) observer {
    if ([self.observers containsObject: observer]) {
        [self.observers removeObject: observer];
    }
}

- (void) setItems: (NSMutableArray *) items {
    [self setValue: items forKey: @"dataArray"];

}

- (NSMutableArray *) items {
    return [self mutableArrayValueForKey: @"dataArray"];
}


/*
#pragma mark KVC Compliance


- (NSUInteger) countOfItems {
    return [self.dataArray count];
}
//
//- (id) objectInItemsAtIndex: (NSUInteger) index {
//    return [self.items objectAtIndex: index];
//}

- (NSArray *) itemsAtIndexes: (NSIndexSet *) indexes {
    return [self.dataArray objectsAtIndexes: indexes];
}

- (void) getItems: (id __unsafe_unretained *) buffer tickingRange: (NSRange) inRange {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.dataArray getObjects: buffer range: inRange];
}


- (void) insertItems: (NSArray *) employeeArray atIndexes: (NSIndexSet *) indexes {
    [self.dataArray insertObjects: employeeArray atIndexes: indexes];
    return;
}

- (void) removeItemsAtIndexes: (NSIndexSet *) indexes {
    [self.dataArray removeObjectsAtIndexes: indexes];
}

- (void) replaceItemsAtIndexes: (NSIndexSet *) indexes withItems: (NSArray *) employeeArray {
    [self.dataArray replaceObjectsAtIndexes: indexes withObjects: employeeArray];
}

*/

#pragma mark Getters

- (NSMutableArray *) observers {
    if (observers == nil) {
        observers = [[NSMutableArray alloc] init];
    }
    return observers;
}


- (void) dealloc {
    [self removeAllObservers];
}

- (void) removeAllObservers {
    while ([self.observers count] > 0) {
        NSObject *observer = [self.observers objectAtIndex: 0];
        [self removeObserver: observer forKeyPath: @"items"];
        [self.observers removeObject: observer];
    }
}


@end