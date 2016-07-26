//
//  DAAPIService.h
//  DictApp
//
//  Created by Alex Nazaroff on 27.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DAAPIServiceCompletionBlock)(NSDictionary *dic, NSError *err);

@interface DAAPIMethod: NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSDictionary *params;

+ (instancetype)methodWithName:(NSString *)name params:(NSDictionary *)params;
- (NSString *)methodURLString;
@end

@interface DAAPIService : NSObject

+ (instancetype)sharedInstance;
- (void)performMethod:(DAAPIMethod *)method completion:(DAAPIServiceCompletionBlock)block;

+ (NSError *)invalidDataError;
@end
