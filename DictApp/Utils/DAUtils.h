//
//  DAUtils.h
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAUtils : NSObject
@end

inline
void DADispatchInMainThread(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), block);
}

inline
void DADispatchInBackgroundThread(dispatch_queue_priority_t priority, dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}
