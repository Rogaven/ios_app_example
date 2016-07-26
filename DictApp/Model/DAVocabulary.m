//
//  DADictionary.m
//  DictApp
//
//  Created by Alex Nazaroff on 27.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAVocabulary.h"
#import "DAAPIMethods.h"

#import "DAUtils.h"

@interface DAVocabulary ()
@property (nonatomic, assign, readwrite, setter=setLoading:) BOOL isLoading;
@property (nonatomic, strong, readwrite) NSError *error;
@end

@implementation DAVocabulary

- (NSString *)basePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return (paths.count) ? [paths.firstObject stringByAppendingPathComponent:@"dic"] : nil;
}

- (void)storeBase {
    // TODO: В идеале тут конечно можно сохранять в CoreData/ sqlite/ etc...
    NSString *path = [self basePath];
    if (path) {
        [[NSKeyedArchiver archivedDataWithRootObject:self.words] writeToFile:path atomically:YES];
    }
}

- (BOOL)restoreBase {
    NSString *path = [self basePath];
    if (path) {
        self.words = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[self basePath]]];
        return self.words;
    }
    return NO;
}

- (void)load {
    if (self.isLoading) return;
    self.loading = YES;
    
    DADispatchInBackgroundThread(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        if (![self restoreBase]) {
            [self updateList];
        } else {
            [self completeWithError:(self.words.count == 0) ? [DAAPIService invalidDataError] : nil];
        }
    });
}

- (void)updateList {
    [[DAAPIService sharedInstance] performMethod:[DAAPIMethods getCurrentUserDictionary] completion:^(NSDictionary *dic, NSError *err) {
        if (!err) {
            if([self createVocabulary:dic]) {
                [self storeBase];
                [self completeWithError:nil];
            } else {
                [self completeWithError:[DAAPIService invalidDataError]];
            }
        } else {
            [self completeWithError:err];
        }
    }];
}

- (void)completeWithError:(NSError *)err {
    self.loading = NO;
    self.error =  err;
    
    if (self.completion) {
        DADispatchInMainThread(self.completion);
    }
}

- (BOOL)createVocabulary:(NSDictionary *)dic {
    if ([dic isKindOfClass:NSDictionary.class]) {
        NSArray *items = dic[@"dictionaryItems"];
        self.words = [NSMutableArray arrayWithCapacity:items.count];
        for (NSDictionary *item in items) {
            DAWord *word = [DAWord wordWithNSDictionary:item];
            [self.words addObject:word];
        }
        return YES;
    } else {
        return NO;
    }
}


- (void)save {
    [self storeBase];
}

-(void)search:(NSString *)text {
    if (text.length == 0) {
        self.filteredWords = nil;
        return;
    }
    
    self.filteredWords = [self.words filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DAWord *evaluatedObject, NSDictionary *bindings) {
        return ([evaluatedObject.translation rangeOfString:text].location != NSNotFound ||
                [evaluatedObject.value rangeOfString:text].location != NSNotFound);
    }]];
}

@end
