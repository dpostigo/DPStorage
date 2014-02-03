//
// Created by Dani Postigo on 2/3/14.
//

#import <Foundation/Foundation.h>

@protocol DPItemsControllerDelegate <NSObject>

@optional
- (void) itemsWillAdd;
- (void) itemsWillRemove: (id) item;
- (void) itemsWillReplace: (id) item;
- (void) itemsWillReset: (NSMutableArray *) oldItems;

- (void) itemsDidAdd: (id) item;
- (void) itemsDidRemove: (id) item;
- (void) itemsDidReplace: (id) oldItem with: (id) item;
- (void) itemsDidReset: (NSMutableArray *) oldItems with: (NSMutableArray *) items;
@end