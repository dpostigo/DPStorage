//
// Created by Dani Postigo on 2/3/14.
//

#import "DPItemsStorage.h"
#import "DPItemsController.h"

@implementation DPItemsStorage

@synthesize itemControllers;
@synthesize controllerClasses;

@synthesize removesReplacedItems;

- (NSMutableArray *) arrayForKey: (NSString *) key {
    return [[self itemControllerForKey: key] items];
}


- (void) setArray: (NSMutableArray *) array forKey: (NSString *) key {
    [self itemControllerForKey: key].items = array;
}


- (DPItemsController *) itemControllerForKey: (NSString *) key {
    DPItemsController *ret = [self.itemControllers objectForKey: key];
    if (ret == nil) {
        ret = [self createControllerForKey: key];
    }
    return ret;
}


- (DPItemsController *) createControllerForKey: (NSString *) key {
    DPItemsController *ret = nil;

    Class controllerClass = [self.controllerClasses objectForKey: key];

    if (controllerClass == nil) {
        ret = [[DPItemsController alloc] init];
    } else {
        ret = [[controllerClass alloc] init];
    }
    [self setupController: ret forKey: key];
    return ret;

}

- (void) setupController: (DPItemsController *) controller forKey: (NSString *) key {
    [controller subscribeDelegate: self];
    controller.arrayName = key;
    controller.removesReplacedItems = self.removesReplacedItems;
    [self.itemControllers setObject: controller forKey: key];
}


#pragma mark Controller classes

- (NSMutableDictionary *) controllerClasses {
    if (controllerClasses == nil) {
        controllerClasses = [[NSMutableDictionary alloc] init];
    }
    return controllerClasses;
}


- (void) setControllerClass: (Class) class forKey: (NSString *) key {
    [self.controllerClasses setObject: class forKey: key];
}

#pragma mark Item classes


- (void) setItemClass: (Class) class forKey: (NSString *) key {
    [self itemControllerForKey: key].itemClass = class;
}



#pragma mark Getters

- (NSMutableDictionary *) itemControllers {
    if (itemControllers == nil) {
        itemControllers = [[NSMutableDictionary alloc] init];
    }
    return itemControllers;
}


@end