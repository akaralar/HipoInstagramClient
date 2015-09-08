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
#import "FetchResult.h"
#import "PaginationCursor.h"

static const NSInteger kItemsPerPage = 10;

@interface PhotoFetcher ()

@property (nonatomic, readwrite) Feed *currentFeed;
@property (nonatomic) FetchResult *lastResult;

@end

@implementation PhotoFetcher

- (void)fetchUserFeedSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
    __weak typeof(self) weakSelf = self;
    SuccessBlock modifiedSuccess = ^(NSURLSessionDataTask *task, FetchResult *result) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.lastResult = result;
        strongSelf.currentFeed = [[Feed alloc] initWithAssets:result.assets];
        success(strongSelf.currentFeed);
    };

    FailureBlock modifiedFailure = ^(NSURLSessionDataTask *task, NSError *error) {  //
        failure(error);
    };
    [[APIManager sharedManager] fetchFeedPhotosAfterMediaWithID:nil
                                                   itemsPerPage:@(kItemsPerPage)
                                                        success:modifiedSuccess
                                                        failure:modifiedFailure];
}

- (void)fetchNextPageSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
    __weak typeof(self) weakSelf = self;
    SuccessBlock modifiedSuccess = ^(NSURLSessionDataTask *task, FetchResult *result) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.lastResult = result;
        [strongSelf.currentFeed loadNewPageWithAssets:result.assets];
        success(strongSelf.currentFeed);
    };

    FailureBlock modifiedFailure = ^(NSURLSessionDataTask *task, NSError *error) {  //
        failure(error);
    };
    
    [[APIManager sharedManager] fetchFeedPhotosAfterMediaWithID:self.lastResult.cursor.lastItemID
                                                   itemsPerPage:@(kItemsPerPage)
                                                        success:modifiedSuccess
                                                        failure:modifiedFailure];
}
@end
