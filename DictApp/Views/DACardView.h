//
//  DACardView.h
//  DictApp
//
//  Created by Alex Nazaroff on 01.12.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAWord;

typedef NS_ENUM(NSUInteger, DACardViewState) {
    DACardViewStateDefault,
    DACardViewStateSuccess,
    DACardViewStateFail
};

@interface DACardView : UIButton
@property (nonatomic, strong) DAWord *word;
@property (nonatomic, strong) NSString *cardTitle;
@property (nonatomic, assign) DACardViewState cardState;
@property (nonatomic, assign) BOOL isTranslation;
@property (nonatomic, assign) CGPoint originalPosition;

+ (instancetype) card;
@end
