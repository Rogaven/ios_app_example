
//
//  ViewController.m
//  DictApp
//
//  Created by Alex Nazaroff on 26.11.14.
//  Copyright (c) 2014 Nazaroff. All rights reserved.
//

#import "DAWordsViewController.h"
#import <libextobjc/extobjc.h>

#import "DAVocabulary.h"
#import "DAWordTableViewCell.h"
#import "DAPlacehoderView.h"
#import "UIStoryboard+Utils.h"
#import "DACardsViewController.h"
#import "DACounterView.h"
#import "DAUtils.h"

@interface DAWordsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) DAVocabulary *vocabulary;
@property (nonatomic, strong) NSMutableDictionary *selectedWords;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet DAPlacehoderView *errorView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet DACounterView *studied;
@property (nonatomic, strong) IBOutlet DACounterView *studying;
@property (nonatomic, strong) IBOutlet UIView *submitView;
@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@property (nonatomic, strong) IBOutlet UISearchBar *searchbar;
@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchController;
@end

@implementation DAWordsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.vocabulary = [DAVocabulary new];
        [self.vocabulary load];
        
        self.selectedWords = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.separatorColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
//    self.searchbar.
    self.submitButton.layer.cornerRadius = 4;
    
    [self setLoading:self.vocabulary.isLoading];
    
    if (self.vocabulary.isLoading) {
        @weakify(self);
        self.vocabulary.completion = ^{
            @strongify(self);
            [self dataLoadCompletion];
        };
    } else {
        if (self.vocabulary.error) {
            [self setErrorViewVisible:YES];
        } else {
            [self dataDidLoad];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVocabulary) name:kDACardsDidUdateNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.errorView) {
        self.errorView.frame = self.view.bounds;
    }
}

- (void)dataLoadCompletion {
    [self setLoading:NO];
    
    if (self.vocabulary.error) {
        [self setErrorViewVisible:YES];
    }
    
    [self dataDidLoad];
    [self.tableView reloadData];
}

- (void)setLoading:(BOOL)loading {
    if (loading) {
        [self.activity startAnimating];
    } else {
        [self.activity stopAnimating];
    }
    self.errorView.hidden = loading;
    self.headerView.hidden = loading;
    self.searchbar.hidden = loading;
    self.tableView.hidden = loading;
    self.activity.hidden = !loading;
    
    if (loading) {
        self.submitView.hidden = YES;
    }
}

- (void)setErrorViewVisible:(BOOL)visible {
    if (!self.errorView) {
        self.errorView = [[DAPlacehoderView alloc] initWithFrame:self.view.bounds];
        self.errorView.text = @"Всё плохо. Но можно повторить)";
        @weakify(self);
        self.errorView.onRetry = ^{
            @strongify(self);
            [self setLoading:YES];
           
            @weakify(self);
            self.vocabulary.completion = ^{
                @strongify(self);
                [self dataLoadCompletion];
            };

            [self.vocabulary load];
        };
        [self.view addSubview:self.errorView];
    }
    
    self.errorView.hidden = !visible;
    
    self.headerView.hidden = visible;
    self.searchbar.hidden = visible;
    self.tableView.hidden = visible;
    self.activity.hidden = visible;
    
    if (visible) {
        self.submitView.hidden = YES;
    }
}

- (IBAction)learn:(id)sender {    
    DACardsViewController *nextVC = (DACardsViewController *)[UIStoryboard controllerWithId:NSStringFromClass(DACardsViewController.class)];
    nextVC.words = self.selectedWords;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"!%lu", (unsigned long)self.vocabulary.words.count);
    return (self.vocabulary.filteredWords) ? self.vocabulary.filteredWords.count: self.vocabulary.words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DAWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(DAWordTableViewCell.class)];
    DAWord *w = (DAWord *) ((self.vocabulary.filteredWords) ? self.vocabulary.filteredWords[indexPath.row] : self.vocabulary.words[indexPath.row]);
    [cell setWord:w];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    DAWord *w = (DAWord *) ((self.vocabulary.filteredWords) ? self.vocabulary.filteredWords[indexPath.row] : self.vocabulary.words[indexPath.row]);
    
    if (w.studied) return;
    
    if (self.selectedWords[w.uuid]) {
        [self.selectedWords removeObjectForKey:w.uuid];
        w.studying = NO;
        self.studying.count--;
    } else {
        [self.selectedWords setObject:w forKey:w.uuid];
        w.studying = YES;
        self.studying.count++;
    }
    
    DAWordTableViewCell *cell = (DAWordTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell updateCheckboxStateWithWord:w];
    
    [self setSubmitViewVisible:self.selectedWords.count >= 2];
}

- (void)setSubmitViewVisible:(BOOL)visible {
    self.submitView.hidden = !visible;
    self.tableView.contentInset = (visible) ? UIEdgeInsetsMake(0, 0, self.submitView.frame.size.height, 0) : UIEdgeInsetsZero;
}

- (void)updateVocabulary {
    [self dataDidLoad];
    [self.tableView reloadData];
    [self.vocabulary save];
}

- (void)dataDidLoad {
    NSUInteger studiedCount = 0;
    NSUInteger studyingCount = 0;
    
    for (DAWord *w in self.vocabulary.words) {
        if (w.studied) {
            studiedCount++;
            [self.selectedWords removeObjectForKey:w.uuid];
        } else if (w.studying)  {
            studyingCount++;
            [self.selectedWords setObject:w forKey:w.uuid];
        }
    }

    self.studied.count = studiedCount;
    self.studying.count = studyingCount;
    
    [self setSubmitViewVisible:studyingCount >= 2];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.vocabulary search:searchText];
    [self.tableView reloadData];
    
    if (searchText.length == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [searchBar resignFirstResponder];
        });
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarTextDidEndEditing:searchBar];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   [searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

@end
