//
// Created by Dani Postigo on 1/25/14.
//

#import <Foundation/Foundation.h>
#import "BasicDelegater.h"

@interface ArrayController : BasicDelegater

@property(nonatomic, strong) NSMutableArray *items;


- (BOOL) hasObserver: (NSObject *) observer;
@end