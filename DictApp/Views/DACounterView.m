//
//  DACounterView.m
//  DictApp
//
//  Created by Alex Nazaroff on 30.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DACounterView.h"

static const NSUInteger kDACounterViewLabelsMaxCount = 4;

@implementation DACounterView {
    UIView *alphaView;
    NSMutableArray *_labels;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        [self insertBlink];
        [self insertLabels];
    }
    
    return self;
}

- (void)insertBlink {
    alphaView = [UIView new];
    alphaView.frame = CGRectIntegral((CGRect){0, self.frame.size.height*0.5f, self.frame.size.width, self.frame.size.height*0.5f});
    alphaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    alphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    [self addSubview:alphaView];
}

- (void)insertLabels {
    _labels = [NSMutableArray arrayWithCapacity:kDACounterViewLabelsMaxCount];
    
    for (NSInteger i=0; i<kDACounterViewLabelsMaxCount; ++i) {
        UILabel *label = [UILabel new];
        label.text = @"0";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [_labels addObject:label];
        [self addSubview:label];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    alphaView.frame = CGRectIntegral((CGRect){0, self.frame.size.height*0.5f, self.frame.size.width, self.frame.size.height*0.5f});
    
    CGFloat w = roundf(self.frame.size.width / kDACounterViewLabelsMaxCount);
    CGFloat h = self.frame.size.height;
    for (NSInteger i=0; i<kDACounterViewLabelsMaxCount; ++i) {
        [self labelWithIndex:i].frame = (CGRect){i*w, 0, w, h};
    }
}

- (UILabel *)labelWithIndex:(NSUInteger)index {
    return (UILabel*)_labels[index];
}

- (void)setCount:(NSUInteger)count {
    if (_count != count) {
        _count = count;
        
        NSString *text = [NSString stringWithFormat:@"%04ld", _count];
        for (NSInteger i=0; i<kDACounterViewLabelsMaxCount; ++i) {
            [self labelWithIndex:i].text = [text substringWithRange:NSMakeRange(i, 1)];
        }
    }
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGFloat w = roundf(self.frame.size.width / kDACounterViewLabelsMaxCount);
    CGFloat h = self.frame.size.height;
    
    for (NSInteger i=0; i<kDACounterViewLabelsMaxCount; ++i) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        
        CGContextSetLineWidth(context, 1.0f);
        
        CGContextMoveToPoint(context, w * i, 0.0f);
        CGContextAddLineToPoint(context, w *i, h);
    
        CGContextStrokePath(context);
    }
}

@end
