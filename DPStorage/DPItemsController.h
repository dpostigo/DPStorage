//
// Created by Dani Postigo on 2/3/14.
//

#import <Foundation/Foundation.h>
#import "ArrayController.h"
#import "DPItemsControllerDelegate.h"

@interface DPItemsController : ArrayController <DPItemsControllerDelegate> {
    NSString *arrayName;
    __strong Class itemClass;

    BOOL notifiesStorageParent;
    BOOL removesReplacedItems;

    id storageParent;
}

@property(nonatomic, strong) Class itemClass;
@property(nonatomic, copy) NSString *arrayName;
@property(nonatomic) BOOL removesReplacedItems;
@property(nonatomic, strong) id storageParent;
@property(nonatomic) BOOL notifiesStorageParent;
- (void) setup;
@end