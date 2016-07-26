//
//  DADictionary.h
//  DictApp
//
//  Created by Alex Nazaroff on 27.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAWord.h"

typedef void (^DAVocabularyLoadingCompletionBlock)();

@interface DAVocabulary : NSObject
@property (nonatomic, strong) NSMutableArray *words;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic, strong) DAVocabularyLoadingCompletionBlock completion;
- (void)load;
- (void)save;

@property (nonatomic, strong) NSArray *filteredWords;
- (void)search:(NSString *)text;
@end
