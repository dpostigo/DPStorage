//
// Created by Dani Postigo on 2/3/14.
//

#import <DPObject/BasicDelegater.h>
#import "DPItemsController.h"
#import "NSObject+DPKitObservation.h"
#import "AutoCoding.h"
#import "NSObject+DPObjectUtils.h"
#import "NSObject+CallSelector.h"

@implementation DPItemsController

static char DPItemsControllerObservationContext;

@synthesize arrayName;
@synthesize itemClass;
@synthesize removesReplacedItems;

@synthesize storageParent;
@synthesize notifiesStorageParent;

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
    [self addObserver: self forKeyPath: @"items" options: options context: &DPItemsControllerObservationContext];
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

    [self testInvocations: keyPath ofObject: object change: change context: context];

    if (context == &DPItemsControllerObservationContext) {
        id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
        id newValue = [change objectForKey: NSKeyValueChangeNewKey];


        NSKeyValueChange kind = (NSKeyValueChange) [[change objectForKey: NSKeyValueChangeKindKey] intValue];

        BOOL isPriorNotification = [[change objectForKey: NSKeyValueChangeNotificationIsPriorKey] boolValue];
        SEL selector = [self selectorWithKey: self.pluralizedString changeKind: kind isPrior: isPriorNotification];

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

        NSString *changeKind = [self stringForKeyValueChange: kind];
        if (kind == NSKeyValueChangeReplacement) {
            if (removesReplacedItems) {
                id replacementObject = isPriorNotification ? oldValue : newValue;
                [self notifyDelegates: NSSelectorFromString([NSString stringWithFormat: isPriorNotification ? @"%@WillRemove:" : @"%@DidAdd:", self.pluralizedString]) object: replacementObject];
            }
            [self notifyDelegates: selector object: oldValue object: newValue];

        } else if (kind == NSKeyValueChangeSetting) {
            [self notifyDelegates: selector object: oldValue object: newValue];

        } else {
            [self notifyDelegates: selector object: messageValue];

        }
    }

    else {
        [super observeValueForKeyPath: keyPath ofObject: object change: change context: context];
    }
}


- (void) testInvocations: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change context: (void *) context {

    BOOL isPriorNotification = [[change objectForKey: NSKeyValueChangeNotificationIsPriorKey] boolValue];
    NSKeyValueChange kind = (NSKeyValueChange) [[change objectForKey: NSKeyValueChangeKindKey] intValue];
    id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
    id newValue = [change objectForKey: NSKeyValueChangeNewKey];


    NSInvocation *noArgumentsInvocation = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(_itemsWillReset:)]];
    NSInvocation *singleArgumentInvocation = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(_itemsWillReplace:)]];
    NSInvocation *doubleArgumentInvocation = [NSInvocation invocationWithMethodSignature: [self methodSignatureForSelector: @selector(_itemsDidReplace:with:)]];
    NSInvocation *invocation = singleArgumentInvocation;


    SEL newSelector;
    if (isPriorNotification) {
        newValue = nil;

        switch (kind) {
            case NSKeyValueChangeSetting:
                newSelector = @selector(_itemsWillReset:);
                [invocation setArgument: &oldValue atIndex: 2];
                break;

            case NSKeyValueChangeInsertion:
                //                    [self _itemsWillAdd];
                invocation = noArgumentsInvocation;
                newSelector = @selector(_itemsWillAdd);
                break;

            case NSKeyValueChangeRemoval:
                //                    [self _itemsWillRemove: oldValue];
                newSelector = @selector(_itemsWillRemove:);
                [invocation setArgument: &oldValue atIndex: 2];
                break;

            case NSKeyValueChangeReplacement:
                newSelector = @selector(_itemsWillReplace:);
                if (removesReplacedItems) {
                    [self _itemsWillRemove: oldValue];
                }
                break;

            default:
                NSLog(@"Handle default.");
                break;

        }
    } else {

        switch (kind) {
            case NSKeyValueChangeSetting:
                [self _itemsDidReset: oldValue with: newValue];
                break;

            case NSKeyValueChangeInsertion:
                [self _itemsDidAdd: newValue];
                break;

            case NSKeyValueChangeRemoval:
                [self _itemsDidRemove: oldValue];
                break;

            case NSKeyValueChangeReplacement:
                [self _itemsDidReplace: oldValue with: newValue];
                break;
        }

    }

    invocation.target = self;

    NSInvocation *preInvocation;

    if (kind == NSKeyValueChangeReplacement && removesReplacedItems) {
        if (isPriorNotification) {
            [self _itemsWillRemove: oldValue];
        } else {
            [self _itemsDidAdd: newValue];
        }
    }

    if (self.storageParent) {

    }

}


- (SEL) selectorWithKey: (NSString *) key changeKind: (NSKeyValueChange) kind isPrior: (BOOL) isPriorNotification {
    NSMutableString *sel = [[NSMutableString alloc] initWithString: key];

    [sel appendString: isPriorNotification ? @"Will" : @"Did"];

    if (kind == NSKeyValueChangeSetting) {
        [sel appendString: isPriorNotification ? @"Reset:" : @"Reset:with:"];

    } else if (kind == NSKeyValueChangeInsertion) {
        [sel appendString: isPriorNotification ? @"Add" : @"Add:"];

    } else if (kind == NSKeyValueChangeRemoval) {
        [sel appendString: @"Remove:"];
    }
    else if (kind == NSKeyValueChangeReplacement) {
        [sel appendString: isPriorNotification ? @"Replace:" : @"Replace:with:"];

    } else {
        [sel appendString: @"Update"];
    }

    SEL selector = NSSelectorFromString(sel);
    return selector;
}


- (void) _itemsWillUpdate {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) _itemsWillAdd {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) _itemsWillRemove: (id) item {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (void) _itemsWillReplace: (id) item {

}

- (void) _itemsWillReset: (NSMutableArray *) oldItems {

}

- (void) _itemsDidAdd: (id) item {

}

- (void) _itemsWillAdd: (id) item toParent: (id) parent {

}

- (void) _itemsDidRemove: (id) item {

}

- (void) _itemsDidReplace: (id) oldItem with: (id) item {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) _itemsDidReset: (NSMutableArray *) oldItems with: (NSMutableArray *) items {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark delegate


- (void) itemsWillAdd {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) itemsWillRemove: (id) item {
    //    NSLog(@"%s", __PRETTY_FUNCTION__);

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