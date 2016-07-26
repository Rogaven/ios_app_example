//
//  DACardView.m
//  DictApp
//
//  Created by Alex Nazaroff on 01.12.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DACardView.h"

@implementation DACardView {
    UILabel *_label;
}

+ (instancetype) card {
    return [self buttonWithType:UIButtonTypeCustom];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        
        [self setupColorsWithState:DACardViewStateDefault];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor darkGrayColor];
        _label.highlightedTextColor = [UIColor blackColor];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_label];
    }
    return self;
}

-(void)layoutSubviews {
    _label.frame = self.bounds;
}

-(void)setCardState:(DACardViewState)state {
    if (state != _cardState) {
        _cardState = state;
        [self setupColorsWithState:state];
    }
}

-(void)setCardTitle:(NSString *)title {
    if (_cardTitle != title) {
        _cardTitle = title;
        _label.text = [title capitalizedString];
    }
}

- (void)setupColorsWithState:(DACardViewState) state {
    switch (state) {
        case DACardViewStateSuccess:
            self.backgroundColor = [UIColor colorWithRed:2.30/2.55 green:2.43/2.55 blue:2.12/2.55 alpha:1];
            self.layer.borderColor = [UIColor colorWithRed:1.61/2.55 green:2.00/2.55 blue:1.04/2.55 alpha:1].CGColor;
            break;

        case DACardViewStateFail:
            self.backgroundColor = [UIColor colorWithRed:2.55/2.55 green:2.41/2.55 blue:2.41/2.55 alpha:1];
            self.layer.borderColor = [UIColor colorWithRed:2.26/2.55 green:1.06/2.55 blue:1.07/2.55 alpha:1].CGColor;
            break;
            
        case DACardViewStateDefault:
        default:
            self.backgroundColor = [UIColor colorWithWhite:2.47/2.55 alpha:1];
            self.layer.borderColor = [UIColor colorWithWhite:2.21/2.55 alpha:1].CGColor;
            break;
    }
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    BOOL hlt = highlighted || self.selected;
    _label.highlighted = hlt;
    self.layer.borderWidth = (hlt) ? 2 : 1;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:(hlt ? 0.7: 1)];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    BOOL hlt = self.highlighted || selected;
    _label.highlighted = hlt;
    self.layer.borderWidth = (hlt) ? 2 : 1;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:(hlt ? 0.7: 1)];
}

@end
