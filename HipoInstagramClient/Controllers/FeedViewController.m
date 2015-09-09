//
//  FeedViewController.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "FeedViewController.h"

#import "ImageViewController.h"

#import "PhotoFetcher.h"
#import "Feed.h"

#import "InstagramCell.h"
#import "LoadingIndicatorCell.h"

typedef NS_ENUM(NSInteger, TableSection) {  //
    TableSectionAssets,
    TableSectionLoading
};

@interface FeedViewController () <UITableViewDataSource,
                                  UITableViewDelegate,
                                  UISearchResultsUpdating,
                                  UISearchBarDelegate,
                                  UISearchControllerDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) PhotoFetcher *fetcher;
@property (nonatomic) UISearchController *searchController;

- (void)didTriggerRefresh:(UIRefreshControl *)refreshControl;

- (void)updateTableView;
- (void)handleError:(NSError *)error;

@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Instagram";
    self.navigationItem.hidesBackButton = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdges];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.backgroundColor =
        [UIColor colorWithRed:(CGFloat)0.93 green:(CGFloat)0.93 blue:(CGFloat)0.95 alpha:1];

    [self.tableView registerClass:[InstagramCell class]
           forCellReuseIdentifier:NSStringFromClass([InstagramCell class])];
    [self.tableView registerClass:[LoadingIndicatorCell class]
           forCellReuseIdentifier:NSStringFromClass([LoadingIndicatorCell class])];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refreshControl];
    [self.tableView sendSubviewToBack:refreshControl];
    [refreshControl addTarget:self
                       action:@selector(didTriggerRefresh:)
             forControlEvents:UIControlEventValueChanged];

    self.fetcher = [PhotoFetcher new];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.frame =
        CGRectMake(CGRectGetMidX(self.searchController.searchBar.frame),
                   CGRectGetMinY(self.searchController.searchBar.frame),
                   CGRectGetWidth(self.searchController.searchBar.frame),
                   44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;
    [self.fetcher fetchUserFeedSuccess:^(Feed *feedAfterFetch) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf updateTableView];
    } failure:^(NSError *error) {  //
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handleError:error];
    }];
}

- (void)updateTableView
{
    [self.tableView reloadData];
}

- (void)handleError:(NSError *)error
{
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                            message:error.userInfo[NSLocalizedDescriptionKey]
                                     preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];

    [alertController addAction:action];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

- (void)didTriggerRefresh:(UIRefreshControl *)refreshControl
{
    __weak typeof(self) weakSelf = self;
    [self.fetcher refreshFeedSuccess:^(Feed *feedAfterFetch) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf updateTableView];
        [refreshControl endRefreshing];
    } failure:^(NSError *error) {  //
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handleError:error];
        [refreshControl endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetcher.currentFeed.isDisplayingLastPage ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case TableSectionAssets:
            return (NSInteger)self.fetcher.currentFeed.assets.count;

        case TableSectionLoading:
            return 1;

        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TableSectionAssets: {

            NSString *identifier = NSStringFromClass([InstagramCell class]);
            InstagramCell *cell =
                [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            [cell bindAsset:self.fetcher.currentFeed.assets[(NSUInteger)indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

        case TableSectionLoading: {

            NSString *identifier = NSStringFromClass([LoadingIndicatorCell class]);
            LoadingIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier  //
                                                                         forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

        default:

            NSAssert(NO, @"shouldn't reach here");
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (NSInteger)self.fetcher.currentFeed.assets.count - 5) {

        __weak typeof(self) weakSelf = self;
        [self.fetcher fetchNextPageSuccess:^(Feed *feedAfterFetch) {  //
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf updateTableView];
        } failure:^(NSError *error) {  //
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf handleError:error];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TableSectionLoading) {
        return;
    }
    
    InstagramCell *cell = (InstagramCell *)[tableView cellForRowAtIndexPath:indexPath];
    ImageViewController *controller = [[ImageViewController alloc] initWithImage:cell.photo.image];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - UISearchControllerDelegate

- (void)willDismissSearchController:(UISearchController *)searchController
{
    __weak typeof(self) weakSelf = self;
    [self.fetcher fetchUserFeedSuccess:^(Feed *feedAfterFetch) {  //
        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf updateTableView];
    } failure:^(NSError *error) {  //
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf handleError:error];

    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    NSString *query = self.searchController.searchBar.text;
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@""];
    __weak typeof(self) weakSelf = self;
    [self.fetcher fetchItemsWithTag:query
        success:^(Feed *feedAfterFetch) {  //
            __strong typeof(self) strongSelf = weakSelf;

            [strongSelf updateTableView];
        }
        failure:^(NSError *error) {  //
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf handleError:error];
        }];
}

@end
