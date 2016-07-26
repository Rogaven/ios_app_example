//
//  DAStoryboard.m
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "UIStoryboard+Utils.h"

@implementation UIStoryboard (Utils)

+ (instancetype)mainStoryboard {
    return [self storyboardWithName:@"Main" bundle:nil];
}

+ (id)controllerWithId:(NSString*) uid {
    return [[self mainStoryboard] instantiateViewControllerWithIdentifier:uid];
}

@end
