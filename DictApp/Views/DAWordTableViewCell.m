//
//  DAWordTableViewCell.m
//  DictApp
//
//  Created by Alex Nazaroff on 30.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAWordTableViewCell.h"
#import "DACheckbox.h"
#import "DAWord.h"

static CGFloat const kXOffset = 15.0f;
static CGFloat const kYOffset = 10.0f;
static CGFloat const kXMargin = 10.0f;

@implementation DAWordTableViewCell {
    DACheckbox *_checkbox;
}

- (void)awakeFromNib {
    self.contentView.clipsToBounds = YES;
    _checkbox = [DACheckbox checkbox];
    _checkbox.userInteractionEnabled = NO;
    [self addSubview:_checkbox];
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:14];

    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectionView;
    
    self.textLabel.highlightedTextColor = [UIColor blackColor];
    self.detailTextLabel.highlightedTextColor = [UIColor blackColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.textLabel.highlighted = self.detailTextLabel.highlighted = selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rc = _checkbox.frame;
    rc.origin = (CGPoint) {kXOffset, kYOffset};
    _checkbox.frame = rc;
    
    rc = self.textLabel.frame;
    rc.origin.x = _checkbox.frame.origin.x + _checkbox.frame.size.width + kXMargin;
    self.textLabel.frame = rc;
    
    rc = self.detailTextLabel.frame;
    rc.origin.x = self.textLabel.frame.origin.x + self.textLabel.frame.size.width;
    self.detailTextLabel.frame = rc;
}

- (void)setWord:(DAWord *)word {
    self.textLabel.text = [word.value capitalizedString];
    self.detailTextLabel.text = [@" – " stringByAppendingString:word.translation];
    [self updateCheckboxStateWithWord:word];
}

- (void)updateCheckboxStateWithWord:(DAWord *)word {
    _checkbox.enabled = (!word.studied);
    _checkbox.on = (word.studied || word.studying);
}

@end
