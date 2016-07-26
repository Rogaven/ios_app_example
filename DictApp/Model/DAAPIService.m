//
//  DAAPIService.m
//  DictApp
//
//  Created by Alex Nazaroff on 27.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAAPIService.h"
#import <AFNetworking.h>

static NSString * const kDAAPIServiceBaseURL = @"http://static01.%@.com/tmp/%@";

@implementation DAAPIService

+ (instancetype)sharedInstance {
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    
    return shared;
}

- (void)performMethod:(DAAPIMethod *)method completion:(DAAPIServiceCompletionBlock)block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:[method methodURLString] parameters:method.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSError *)invalidDataError {
    //TODO: В идеале надо завести под ошибки енум.
    return [NSError errorWithDomain:@"DicApp" code:-1 userInfo:nil];
}

@end

@interface DAAPIMethod ()
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@end

@implementation DAAPIMethod

+ (instancetype)methodWithName:(NSString *)name params:(NSDictionary *)params {
    DAAPIMethod *method = [DAAPIMethod new];
    method.name = name;
    method.params = params;
    return method;
}

- (NSString *)methodURLString {
    NSAssert(self.name, @"Name parameter is required");
    return [NSString stringWithFormat:kDAAPIServiceBaseURL, [[@"v겺Z'" dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0], self.name];
}

@end