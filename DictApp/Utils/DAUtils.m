//
//  DAUtils.m
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAUtils.h"

@implementation DAUtils
@end

extern inline void DADispatchInMainThread(dispatch_block_t block);
extern inline void DADispatchInBackgroundThread(dispatch_queue_priority_t priority, dispatch_block_t block);