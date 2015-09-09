//
//  FeedViewController.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "FeedViewController.h"

#import "PhotoFetcher.h"
#import "Feed.h"

#import "InstagramCell.h"
#import "LoadingIndicatorCell.h"

typedef NS_ENUM(NSInteger, TableSection) { TableSectionAssets, TableSectionLoading };

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) PhotoFetcher *fetcher;

@end

@implementation FeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Instagram";
    self.navigationItem.hidesBackButton = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 300;

    [self.tableView registerClass:[InstagramCell class]
           forCellReuseIdentifier:NSStringFromClass([InstagramCell class])];
    [self.tableView registerClass:[LoadingIndicatorCell class]
           forCellReuseIdentifier:NSStringFromClass([LoadingIndicatorCell class])];

    [self.tableView autoPinEdgesToSuperviewEdges];

    self.fetcher = [PhotoFetcher new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;
    [self.fetcher fetchUserFeedSuccess:^(Feed *feedAfterFetch) {
        __strong typeof(self) strongSelf = weakSelf;

        [strongSelf.tableView reloadData];

    } failure:^(NSError *error) {  //
        NSLog(@"error: %@", error);
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

        [self.fetcher fetchNextPageSuccess:^(Feed *feedAfterFetch) { [self.tableView reloadData]; }
            failure:^(NSError *error) { NSLog(@"error: %@", error); }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TableSectionLoading) {
        return;
    }

    NSLog(@"did select");
}

@end
