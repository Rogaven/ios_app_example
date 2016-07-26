//
//  DACheckbox.h
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DACheckbox : UIButton
@property (nonatomic, assign, getter=isOn) BOOL on;

+ (instancetype)checkbox;

@end
