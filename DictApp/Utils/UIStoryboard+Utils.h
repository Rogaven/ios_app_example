//
//  DAStoryboard.h
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIStoryboard (Utils)

+ (instancetype)mainStoryboard;
+ (id)controllerWithId:(NSString*) uid;

@end
