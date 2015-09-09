//
//  PhotoFetcher.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "PhotoFetcher.h"

// Managers
#import "APIManager.h"

// Models
#import "Feed.h"
#import "FeedUpdate.h"
#import "FetchResult.h"
#import "PaginationCursor.h"

static const NSInteger kItemsPerPage = 10;

typedef NS_ENUM(NSInteger, FetchMode) {  //
    FetchModeFeed = 1,
    FetchModeSearchByTag
};

@interface PhotoFetcher ()

@property (nonatomic) FetchMode fetchMode;
@property (nonatomic, readwrite) Feed *currentFeed;
@property (nonatomic) NSString *tagToSearch;
@property (nonatomic) FetchResult *lastResult;

@end

@implementation PhotoFetcher

- (void)fetchUserFeedSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
    self.fetchMode = FetchModeFeed;

    __weak typeof(self) weakSelf = self;
    SuccessBlock modifiedSuccess = ^(NSURLSessionDataTask *task, FetchResult *result) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.lastResult = result;
        Feed *oldFeed = strongSelf.currentFeed;
        strongSelf.currentFeed = [[Feed alloc] initWithFetchResult:result];
        FeedUpdate *update = [[FeedUpdate alloc] initWithFromFeed:oldFeed toFeed:strongSelf.currentFeed];
        success(update);
    };

    FailureBlock modifiedFailure = ^(NSURLSessionDataTask *task, NSError *error) {  //
        failure(error);
    };

    [[APIManager sharedManager] fetchFeedPhotosAfterItemWithID:nil
                                                  itemsPerPage:@(kItemsPerPage)
                                                       success:modifiedSuccess
                                                       failure:modifiedFailure];
}

- (void)fetchItemsWithTag:(NSString *)tag
                  success:(FetchSuccessBlock)success
                  failure:(FetchFailureBlock)failure
{
    if (!tag || [tag isEqualToString:@""]) {
        return;
    }

    self.fetchMode = FetchModeSearchByTag;
    self.tagToSearch = tag;

    __weak typeof(self) weakSelf = self;
    SuccessBlock modifiedSuccess = ^(NSURLSessionDataTask *task, FetchResult *result) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.lastResult = result;
        Feed *oldFeed = self.currentFeed;
        strongSelf.currentFeed = [[Feed alloc] initWithFetchResult:result];
        FeedUpdate *update =
            [[FeedUpdate alloc] initWithFromFeed:oldFeed toFeed:strongSelf.currentFeed];
        success(update);
    };

    FailureBlock modifiedFailure = ^(NSURLSessionDataTask *task, NSError *error) {  //
        failure(error);
    };

    [[APIManager sharedManager] fetchPhotosWithTag:tag
                                   afterItemWithID:nil
                                      itemsPerPage:@(kItemsPerPage)
                                           success:modifiedSuccess
                                           failure:modifiedFailure];
}

- (void)fetchNextPageSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
    if (self.currentFeed.isDisplayingLastPage) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    SuccessBlock modifiedSuccess = ^(NSURLSessionDataTask *task, FetchResult *result) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.lastResult = result;
        Feed *oldFeed = [self.currentFeed copy];
        [strongSelf.currentFeed loadNewPageWithFetchResult:result];
        FeedUpdate *update = [[FeedUpdate alloc] initWithFromFeed:oldFeed toFeed:strongSelf.currentFeed];
        success(update);
    };

    FailureBlock modifiedFailure = ^(NSURLSessionDataTask *task, NSError *error) {  //
        failure(error);
    };

    switch (self.fetchMode) {
        case FetchModeFeed:

            [[APIManager sharedManager]
                fetchFeedPhotosAfterItemWithID:self.lastResult.cursor.lastItemID
                                  itemsPerPage:@(kItemsPerPage)
                                       success:modifiedSuccess
                                       failure:modifiedFailure];
            break;

        case FetchModeSearchByTag:

            [[APIManager sharedManager] fetchPhotosWithTag:self.tagToSearch
                                           afterItemWithID:self.lastResult.cursor.lastItemID
                                              itemsPerPage:@(kItemsPerPage)
                                                   success:modifiedSuccess
                                                   failure:modifiedFailure];
            break;

        default:
            break;
    }
}

- (void)refreshFeedSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
    switch (self.fetchMode) {
        case FetchModeFeed:

            [self fetchUserFeedSuccess:success failure:failure];

            break;
        case FetchModeSearchByTag:

            [self fetchItemsWithTag:self.tagToSearch success:success failure:failure];
            break;


        default:
            break;
    }
}
@end
