//
//  DACheckbox.m
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DACheckbox.h"

@implementation DACheckbox

+ (instancetype)checkbox {
    DACheckbox *checkbox = [DACheckbox buttonWithType:UIButtonTypeCustom];
    checkbox.frame = (CGRect){0,0, 20,20};
    checkbox.layer.cornerRadius = 4;
    checkbox.layer.borderWidth = 1;
    [checkbox setTitleEdgeInsets:UIEdgeInsetsZero];
    checkbox.titleLabel.textAlignment = NSTextAlignmentCenter;
    checkbox.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    checkbox.titleLabel.hidden = NO;
    return checkbox;
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:(enabled) ? 1 : 0].CGColor;
}

-(void)setOn:(BOOL)on {
    [self setTitle:(on) ? @"✔︎" : nil forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:1.03f/2.55f green:1.56f/2.55f blue:0.34/2.55f alpha:1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateDisabled];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end
