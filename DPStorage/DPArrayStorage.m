//
// Created by Dani Postigo on 1/25/14.
//

#import "ArrayController.h"
#import "DPArrayStorage.h"
#import "NSObject+CallSelector.h"

@interface DPArrayStorage () {
    NSMutableDictionary *arrayControllers;
}

@property(nonatomic, strong) NSMutableDictionary *arrayControllers;

- (NSString *) keyForArrayController: (ArrayController *) arrayController;

@end


@implementation DPArrayStorage



#pragma mark Example array


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

            NSString *key = [self keyForArrayController: (ArrayController *) object];

            id value = [change objectForKey: NSKeyValueChangeNewKey];
            BOOL isPriorNotification = [[change objectForKey: NSKeyValueChangeNotificationIsPriorKey] boolValue];
            NSKeyValueObservingOptions kind = (NSKeyValueObservingOptions) [[change objectForKey: NSKeyValueChangeKindKey] intValue];


            SEL selector = [self selectorWithKey: key changeKind: kind isPrior: isPriorNotification];

            if (isPriorNotification) {
                value = [change objectForKey: NSKeyValueChangeOldKey];
            }

            //            NSLog(@"selector = %@", NSStringFromSelector(selector));
            [self forwardSelector: selector delegate: self object: value];
        }

    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


- (SEL) selectorWithKey: (NSString *) key changeKind: (NSKeyValueObservingOptions) kind isPrior: (BOOL) isPriorNotification {
    NSMutableString *sel = [[NSMutableString alloc] initWithString: key];

    [sel appendString: isPriorNotification ? @"Will" : @"Did"];
    if (kind == NSKeyValueChangeSetting) {
        [sel appendString: @"Reset:"];

    } else if (kind == NSKeyValueChangeInsertion) {
        [sel appendString: @"Add:"];

    } else if (kind == NSKeyValueChangeRemoval) {
        [sel appendString: @"Remove:"];
    }
    else if (kind == NSKeyValueChangeReplacement) {
        [sel appendString: @"Replace:"];

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
    return [self arrayControllerForKey: key].items;
}


- (void) setArray: (NSMutableArray *) array ForKey: (NSString *) key {
    [self arrayControllerForKey: key].items = array;
}

- (ArrayController *) arrayControllerForKey: (NSString *) key {
    ArrayController *ret = [self.arrayControllers objectForKey: key];
    if (ret == nil) {
        ret = [[ArrayController alloc] init];
        [ret addObserver: self forKeyPath: @"items" options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew) context: &DPArrayStorageContext];
        [arrayControllers setObject: ret forKey: key];
    }
    return ret;
}

- (NSMutableDictionary *) arrayControllers {
    if (arrayControllers == nil) {
        arrayControllers = [[NSMutableDictionary alloc] init];
    }
    return arrayControllers;
}

- (void) setArrayControllers: (NSMutableDictionary *) arrayControllers1 {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    arrayControllers = arrayControllers1;

}


- (void) dealloc {
    for (ArrayController *controller in arrayControllers) {
        [controller removeObserver: self forKeyPath: @"items"];
    }

}


- (void) observer: (ArrayController *) arrayController {

    [arrayController addObserver: self forKeyPath: @"items" options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew) context: &DPArrayStorageContext];

}



@end