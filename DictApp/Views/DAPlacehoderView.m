//
//  DAPlacehoderView.m
//  DictApp
//
//  Created by Alex Nazaroff on 30.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAPlacehoderView.h"

@implementation DAPlacehoderView {
    UILabel *_label;
    UIButton *_retry;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor darkGrayColor];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_label];
        
        _retry = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _retry.frame = (CGRect) {0,0, 150, 40};
        _retry.backgroundColor = [UIColor colorWithRed:2.26/2.55 green:1.06/2.55 blue:1.07/2.55 alpha:1];
        _retry.layer.cornerRadius = 4;
        [_retry setTitle:@"Повторить" forState:UIControlStateNormal];
        [_retry addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retry];
    }
    return self;
}

- (void)layoutSubviews {
    _label.frame = self.bounds;
    _retry.frame = CGRectIntegral((CGRect){0.5f*(self.frame.size.width - _retry.frame.size.width),
                                          0.5f*self.frame.size.height + _retry.frame.size.height,
                                          _retry.frame.size.width, _retry.frame.size.height});
    
    
}

- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setShowRetryButton:(BOOL)showRetryButton {
}

- (void)action {
    if (self.onRetry) {
        self.onRetry();
    }
}

@end
