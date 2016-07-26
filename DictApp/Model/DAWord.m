//
//  DAWord.m
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAWord.h"

@implementation DAWord

+ (instancetype)wordWithNSDictionary:(NSDictionary *)dic {
    if (![dic isKindOfClass:NSDictionary.class]) return nil;
    
    DAWord *word = [DAWord new];
    word.uuid = dic[@"id"];
    word.value = dic[@"sentence"];
    word.translation = dic[@"translation"];
    return word;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.uuid = [aDecoder decodeObjectForKey:@"u"];
    self.value = [aDecoder decodeObjectForKey:@"v"];
    self.translation = [aDecoder decodeObjectForKey:@"t"];
    self.studied = [aDecoder decodeBoolForKey:@"s1"];
    self.studying = [aDecoder decodeBoolForKey:@"s2"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"u"];
    [aCoder encodeObject:self.value forKey:@"v"];
    [aCoder encodeObject:self.translation forKey:@"t"];
    
    [aCoder encodeBool:self.studied forKey:@"s1"];
    [aCoder encodeBool:self.studying forKey:@"s2"];
}

-(void)setStudied:(BOOL)studied {
    _studied = studied;
    _studying = NO;
}

@end
