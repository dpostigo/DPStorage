//
// Created by Dani Postigo on 1/25/14.
//

#import <AutoCoding/AutoCoding.h>
#import "ArrayController.h"
#import "DPArrayStorage.h"

@interface DPArrayStorage () {
}

- (NSString *) keyForArrayController: (ArrayController *) arrayController;

@end


@implementation DPArrayStorage



#pragma mark Example array


@synthesize arrayControllers;

- (NSMutableArray *) exampleItems {
    return [self arrayForKey: @"exampleItems"];
}

- (void) setExampleItems: (NSMutableArray *) exampleItems {
    [self setArray: exampleItems ForKey: @"exampleItems"];
}



#pragma mark Setters



#pragma mark Magic

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (context == &DPArrayStorageContext) {
        if ([object isKindOfClass: [ArrayController class]]) {
            id newValue = [change objectForKey: NSKeyValueChangeNewKey];
            NSString *key = [self keyForArrayController: (ArrayController *) object];

            BOOL isPriorNotification = [[change objectForKey: NSKeyValueChangeNotificationIsPriorKey] boolValue];
            NSKeyValueObservingOptions kind = (NSKeyValueObservingOptions) [[change objectForKey: NSKeyValueChangeKindKey] intValue];


            SEL selector = [self selectorWithKey: key changeKind: kind isPrior: isPriorNotification];

            if (isPriorNotification) {
                newValue = [change objectForKey: NSKeyValueChangeOldKey];
            }

            if (kind == NSKeyValueChangeSetting || kind == NSKeyValueChangeReplacement) {
                id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
                [self notifyDelegates: selector object: oldValue object: newValue];

                //                NSLog(@"%s, selector = %@, oldValue = %@, newValue = %@", __PRETTY_FUNCTION__, NSStringFromSelector(selector), oldValue, newValue);
            } else {

                [self notifyDelegates: selector object: newValue];
            }

        }

    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


- (SEL) selectorWithKey: (NSString *) key changeKind: (NSKeyValueObservingOptions) kind isPrior: (BOOL) isPriorNotification {
    NSMutableString *sel = [[NSMutableString alloc] initWithString: key];
    [sel appendString: isPriorNotification ? @"Will" : @"Did"];
    if (kind == NSKeyValueChangeSetting) {
        [sel appendString: @"Reset:with:"];

    } else if (kind == NSKeyValueChangeInsertion) {
        [sel appendString: @"Add:"];

    } else if (kind == NSKeyValueChangeRemoval) {
        [sel appendString: @"Remove:"];
    }
    else if (kind == NSKeyValueChangeReplacement) {
        [sel appendString: @"Replace:with:"];

    } else {
        [sel appendString: @"Update"];
    }

    SEL selector = NSSelectorFromString(sel);
    return selector;
}

#pragma mark Getters

- (NSString *) keyForArrayController: (ArrayController *) arrayController {
    NSString *ret = nil;
    NSArray *keys = [self.arrayControllers allKeys];
    for (NSString *key in keys) {
        if ([self arrayControllerForKey: key] == arrayController) {
            ret = key;
        }
    }
    return ret;
}

- (NSMutableArray *) arrayForKey: (NSString *) key {
    return [[self arrayControllerForKey: key] items];
}


- (void) setArray: (NSMutableArray *) array ForKey: (NSString *) key {
    [self arrayControllerForKey: key].items = array;
}

- (ArrayController *) arrayControllerForKey: (NSString *) key {
    ArrayController *ret = [self.arrayControllers objectForKey: key];
    if (ret == nil) {
        ret = [[ArrayController alloc] init];
        [self addControllerObserver: ret];
        [self.arrayControllers setObject: ret forKey: key];
    }

    return ret;
}

- (void) addControllerObserver: (ArrayController *) controller {
    if (![controller hasObserver: self]) {
        [controller addObserver: self forKeyPath: @"items" options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew) context: &DPArrayStorageContext];
    }
}

- (NSMutableDictionary *) arrayControllers {
    if (arrayControllers == nil) {
        arrayControllers = [[NSMutableDictionary alloc] init];
    }
    return arrayControllers;
}



#pragma mark Dearchiving

- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];

    [self subscribeDelegate: self];
}

- (void) dealloc {

}


- (id) init {
    self = [super init];
    if (self) {
        [self subscribeDelegate: self];
    }

    return self;
}


@end