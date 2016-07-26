//
//  DAAPIMethods.m
//  DictApp
//
//  Created by Alex Nazaroff on 27.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAAPIMethods.h"

@implementation DAAPIMethods

+ (DAAPIMethod *) getCurrentUserDictionary {
    return [DAAPIMethod methodWithName:@"dictionary.json" params:nil];
}

@end
