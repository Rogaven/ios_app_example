//
//  DACardsViewController.h
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kDACardsDidUdateNotification;

@interface DACardsViewController : UIViewController
@property (nonatomic, strong) NSDictionary *words;
@end
