//
//  DAPlacehoderView.h
//  DictApp
//
//  Created by Alex Nazaroff on 30.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DAPlacehoderViewRetryBlock)();


@interface DAPlacehoderView : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL showRetryButton;
@property (nonatomic, strong) DAPlacehoderViewRetryBlock onRetry;
@end
