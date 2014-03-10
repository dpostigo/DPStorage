//
// Created by Dani Postigo on 2/3/14.
//

#import "DPArrayStorageObject.h"
#import "DPItemsController.h"

@implementation DPArrayStorageObject

@synthesize defaultStorageClass;
@synthesize customStorageClasses;
@synthesize removesReplacedItems;
@synthesize storageControllers;

- (void) notifyArrays: (NSArray *) arrayNames {
    for (NSString *type in arrayNames) {
        NSArray *array = [self valueForKeyPath: type];
        for (id object in array) {
            // SEL selector = NSSelectorFromString([NSString stringWithFormat: @"%@DidAdd:", type]);
            //            [self forwardSelector: selector delegate: self object: object];
        }
    }
}


- (NSMutableArray *) arrayForKey: (NSString *) key {
    return [[self storageForKey: key] items];
}


- (void) setArray: (NSMutableArray *) array forKey: (NSString *) key {
    [self storageForKey: key].items = array;
}


- (DPItemsController *) storageForKey: (NSString *) key {
    DPItemsController *ret = [self.storageControllers objectForKey: key];
    if (ret == nil) {
        ret = [self createStorageForKey: key];
    }
    return ret;
}


#pragma mark Create Controller

- (Class) defaultStorageClass {
    if (defaultStorageClass == nil) {
        defaultStorageClass = [DPItemsController class];
    }
    return defaultStorageClass;
}


- (DPItemsController *) createStorageForKey: (NSString *) key {
    DPItemsController *ret = nil;

    Class customControllerClass = [self.customStorageClasses objectForKey: key];

    if (customControllerClass == nil) {
        ret = [[self.defaultStorageClass alloc] init];
    } else {
        ret = [[customControllerClass alloc] init];
    }

    [self setupStorage: ret forKey: key];
    return ret;

}

- (void) setupStorage: (DPItemsController *) controller forKey: (NSString *) key {
    [controller subscribeDelegate: self];
    controller.arrayName = key;
    controller.removesReplacedItems = self.removesReplacedItems;
    [self addStorage: controller forKey: key];
}

- (void) addStorage: (DPItemsController *) controller forKey: (NSString *) key {
    [self.storageControllers setObject: controller forKey: key];
    controller.storageParent = self;
}

#pragma mark Controller classes

- (NSMutableDictionary *) customStorageClasses {
    if (customStorageClasses == nil) {
        customStorageClasses = [[NSMutableDictionary alloc] init];
    }
    return customStorageClasses;
}


- (void) setStorageClass: (Class) class forKey: (NSString *) key {
    if ([class isSubclassOfClass: [DPItemsController class]]) {
        [self.customStorageClasses setObject: class forKey: key];
    } else {
        [NSException raise: @"Can't set storage class for key." format: @"Storage classes must subclass %@", [DPItemsController class]];
    }
}

#pragma mark Item classes


- (void) setItemClass: (Class) class forKey: (NSString *) key {
    [self storageForKey: key].itemClass = class;
}



#pragma mark Getters

- (NSMutableDictionary *) storageControllers {
    if (storageControllers == nil) {
        storageControllers = [[NSMutableDictionary alloc] init];
    }
    return storageControllers;
}


@end