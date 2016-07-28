//
//  DAProgressView.m
//  DictApp
//
//  Created by Alex Nazaroff on 01.12.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAProgressView.h"

@implementation DAProgressView {
    UIView *_progress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _progress = [UIView new];
    _progress.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:_progress];
    
    self.backgroundColor = [UIColor colorWithRed:0.86/2.55f green:1.42/2.55f blue:2.00/2.55f alpha:1];
    _progress.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    return self;
}

- (void)setValue:(CGFloat) val {
    if (_value != val) {
        _value = val;
        CGRect rc = _progress.frame;
        rc.size.width = roundf(self.frame.size.width * val);
        _progress.frame = rc;
    }
}

- (void)layoutSubviews {
    CGRect rc = self.bounds;
    rc.size.width = roundf(self.frame.size.width * _value);
    _progress.frame = rc;
}

@end
