//
//  DACardsViewController.m
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DACardsViewController.h"
#import "DAProgressView.h"
#import "DACardView.h"
#import "DAWord.h"
#import "DAUtils.h"

NSString * const kDACardsDidUdateNotification = @"DACardsDidUdateNotification";
static NSUInteger const kMaxCardsCountInRow = 2;
static NSUInteger const kOffset = 15;

@interface DACardsViewController () {
    DAProgressView *_progress;
    NSArray *_uids;
    NSInteger _stage;
    
    NSMutableArray* _cardViews;
    DACardView *_prevSelectedCard;
    
    NSInteger _answers;
}
@end

@implementation DACardsViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Стоп"
                                                                             style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
    [self createCards];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createProgressView];
    [self updateCards];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self destroyProgressView];
}

- (void)stop {
    [self exit];
}

- (void)createProgressView {
    UIView *superview = self.navigationController.navigationBar;
    _progress = [[DAProgressView alloc] initWithFrame:(CGRect){10, superview.frame.size.height - 6, superview.frame.size.width - 20, 2}];
    [superview addSubview:_progress];
}

- (void)destroyProgressView {
    [_progress removeFromSuperview];
}

- (void)setWords:(NSDictionary *)words {
    if (words != _words) {
        if (words.count % 2 > 0) {
            NSMutableDictionary *tmp = [words mutableCopy];
            [tmp removeObjectForKey:[[words allKeys] lastObject]];
            _words = tmp;
        } else {
            _words = [words copy];
        }
        
        _uids = _words.allKeys;
    }
}

- (void)createCards {
    _cardViews = [NSMutableArray arrayWithCapacity:kMaxCardsCountInRow*2];
    for (NSInteger i=0; i < kMaxCardsCountInRow*2; ++i) {
        DACardView *card = [DACardView card];
        [card addTarget:self action:@selector(cardSelected:) forControlEvents:UIControlEventTouchDown];
        [card addTarget:self action:@selector(cardMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [card addTarget:self action:@selector(cardDeselected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:card];
        [_cardViews addObject:card];
    }
}

- (void)onAction {
    if (_answers>=2) {
        _answers = 0;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_stage < (self.words.count/2)) {
                    [self updateCards];
            } else {
                [self exit];
            }
        });
    }
}

- (void)exit {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDACardsDidUdateNotification object:nil];
}

- (void)updateCards {
    _stage++;
    _progress.value = (CGFloat)_stage / (self.words.count / 2);
    
    for (NSInteger i=0; i < kMaxCardsCountInRow; ++i) {
        DAWord *w = [_words objectForKey:_uids[(_stage-1)*2+i]];
        
        DACardView *wordCard = _cardViews[i*2];
        wordCard.cardTitle = w.value;
        wordCard.cardState = DACardViewStateDefault;
        wordCard.isTranslation = NO;
        wordCard.word = w;
        
        DACardView *translateCard = _cardViews[i*2+1];
        translateCard.cardTitle = w.translation;
        translateCard.cardState = DACardViewStateDefault;
        translateCard.isTranslation = YES;
        translateCard.word = w;
    }
    
    [self relayoutCards];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self relayoutCards];
}

- (void)relayoutCards {
    static NSUInteger const kMaxCardsCountInColumn = 2;
    
    CGFloat w = roundf((self.view.bounds.size.width - (kMaxCardsCountInRow+1)*kOffset)/kMaxCardsCountInRow);
    CGFloat h = roundf((self.view.bounds.size.height - (kMaxCardsCountInColumn+1)*kOffset)/kMaxCardsCountInColumn);
    
    for (NSInteger i=0; i < kMaxCardsCountInRow; ++i) {
        DACardView *wordCard = _cardViews[i*2];
        wordCard.frame = (CGRect){kOffset + i*(w+kOffset), kOffset, w, h};
        wordCard.originalPosition = wordCard.frame.origin;
        
        DACardView *translationCard = _cardViews[i*2+1];
        translationCard.frame = (CGRect){kOffset + i*(w+kOffset), kOffset*2 + h, w, h};
        translationCard.originalPosition = translationCard.frame.origin;
    }
}

- (void)cardSelected:(DACardView *)sender {
    if (_prevSelectedCard == sender) return;
    _prevSelectedCard.selected = NO;
    
    if (_prevSelectedCard && sender.isTranslation != _prevSelectedCard.isTranslation) {
        [self compareCard:sender with:_prevSelectedCard];
        _prevSelectedCard = nil;
        
        [self onAction];
    } else {
        sender.selected = YES;
        [sender.superview bringSubviewToFront:sender];
        _prevSelectedCard = sender;
    }
}

- (void)compareCard:(DACardView *)first with:(DACardView *)second {
    DACardView* wordCard = (first.isTranslation) ? second : first;
    
    if ([first.word.uuid isEqualToNumber:second.word.uuid]) {
        if (wordCard.cardState == DACardViewStateDefault) {
            wordCard.cardState = DACardViewStateSuccess;
            wordCard.word.studied = YES;
            _answers++;
        }
    } else {
        if (wordCard.cardState == DACardViewStateDefault) {
            wordCard.cardState = DACardViewStateFail;
            _answers++;
        }
    }
}

- (void)cardDeselected:(DACardView *)sender {
    
    for (NSInteger i=0; i < kMaxCardsCountInRow*2; ++i) {
        DACardView *card = _cardViews[i];
        if (card != sender && card.isTranslation != sender.isTranslation && CGRectContainsPoint(card.frame, sender.center)) {
            [self compareCard:sender with:card];
            _prevSelectedCard = nil;
            
            [self onAction];
        }
    }
        
    sender.frame = (CGRect){sender.originalPosition, sender.frame.size.width, sender.frame.size.height};
}

- (void)cardMoved:(DACardView *)sender withEvent:(UIEvent *)event {
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}

@end
