//
//  DAWordTableViewCell.h
//  DictApp
//
//  Created by Alex Nazaroff on 30.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAWord;

@interface DAWordTableViewCell : UITableViewCell
- (void)setWord:(DAWord *)word;
- (void)updateCheckboxStateWithWord:(DAWord *)word;
@end
