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
    self.tableView.estimatedRowHeight = 320;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

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

    } failure:^(NSError *error){

        NSLog(@"error: %@", error);
    }];
}


#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.fetcher.currentFeed.isDisplayingLastPage ? 1 : 2;
    return 1;
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
            return [tableView dequeueReusableCellWithIdentifier:identifier];
        }

        case TableSectionLoading:{
            
            NSString *identifier = NSStringFromClass([LoadingIndicatorCell class]);
            return [tableView dequeueReusableCellWithIdentifier:identifier];
        }

        default:
            
            NSAssert(NO, @"shouldn't reach here");
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case TableSectionAssets: {
            InstagramCell *photoCell = (InstagramCell *)cell;
            Asset *asset = self.fetcher.currentFeed.assets[(NSUInteger)indexPath.row];
            [photoCell bindAsset:asset];
        }
            break;

        case TableSectionLoading:
            
            break;

        default:
            break;
    }


}

@end
