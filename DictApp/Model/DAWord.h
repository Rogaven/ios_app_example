//
//  DAWord.h
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAWord : NSObject <NSCoding>
@property (nonatomic, strong) NSNumber *uuid;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *translation;

@property (nonatomic, assign) BOOL studying;
@property (nonatomic, assign) BOOL studied;

+ (instancetype)wordWithNSDictionary:(NSDictionary *)dic;
@end
