//
// Created by Dani Postigo on 2/3/14.
//

#import <DPObject/BasicDelegater.h>
#import "DPItemsController.h"
#import "NSObject+DPKitObservation.h"
#import "AutoCoding.h"
#import "NSObject+DPObjectUtils.h"

@implementation DPItemsController

static char ItemsControllerObservationContext;

@synthesize arrayName;
@synthesize itemClass;

@synthesize removesReplacedItems;

- (id) init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}


- (void) setup {
    [self subscribeDelegate: self];
    NSKeyValueObservingOptions options = (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew);
    [self addObserver: self forKeyPath: @"items" options: options context: &ItemsControllerObservationContext];
}

- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];
    [self setup];
}


#pragma mark Getters

- (NSString *) pluralizedString {
    NSString *ret = nil;
    if (arrayName) {
        ret = arrayName;
    } else {
        ret = self.itemClass == nil ? @"items" : [self pluralizedStringForClassName: NSStringFromClass(self.itemClass)];
    }
    return ret;
}


- (NSString *) pluralizedStringForClassName: (NSString *) name {
    return [NSString stringWithFormat: @"%@s", [name lowercaseString]];
}

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {
    if (context == &ItemsControllerObservationContext) {
        id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
        id newValue = [change objectForKey: NSKeyValueChangeNewKey];


        NSKeyValueChange kind = (NSKeyValueChange) [[change objectForKey: NSKeyValueChangeKindKey] intValue];

        BOOL isPriorNotification = [[change objectForKey: NSKeyValueChangeNotificationIsPriorKey] boolValue];
        SEL selector = [NSObject selectorWithKey: self.pluralizedString changeKind: kind isPrior: isPriorNotification];


        NSIndexSet *indexSet = [change objectForKey: NSKeyValueChangeIndexesKey];

        if ([indexSet count] == 1) {
            newValue = [newValue objectAtIndex: 0];
            oldValue = [oldValue objectAtIndex: 0];
        }

        id messageValue = nil;
        switch (kind) {
            case NSKeyValueChangeInsertion : // this may be an empty array
                messageValue = newValue;
                break;

            case NSKeyValueChangeRemoval:
                messageValue = oldValue;
                break;

            default :
                break;
        }

        if (isPriorNotification) {
            newValue = nil;
        }
        NSString *changeKind = [self stringForKeyValueChange: kind];
        //        NSLog(@"changeKind = %@, selector = %@, oldValue = %@, newValue = %@", changeKind, NSStringFromSelector(selector), oldValue, newValue);


        if (kind == NSKeyValueChangeReplacement) {
            if (removesReplacedItems) {
                id replacementObject = isPriorNotification ? oldValue : newValue;
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: isPriorNotification ? @"%@WillRemove:" : @"DidAdd:", self.pluralizedString]) object: replacementObject];
            }
            [self notifyDelegates: selector object: oldValue object: newValue];

        }
        else if (kind == NSKeyValueChangeSetting) {
            [self notifyDelegates: selector object: oldValue object: newValue];

        } else {
            [self notifyDelegates: selector object: messageValue];

        }
    } else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}



#pragma mark delegate

- (void) itemsWillAdd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) itemsWillRemove: (id) item {

}

- (void) itemsWillReplace: (id) item {

}

- (void) itemsWillReset: (NSMutableArray *) oldItems {

}

- (void) itemsDidAdd: (id) item {

}

- (void) itemsDidRemove: (id) item {

}

- (void) itemsDidReplace: (id) oldItem with: (id) item {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) itemsDidReset: (NSMutableArray *) oldItems with: (NSMutableArray *) items {

    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end