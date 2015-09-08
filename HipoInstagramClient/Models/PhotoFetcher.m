//
//  PhotoFetcher.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "PhotoFetcher.h"

#import "APIManager.h"
#import "Feed.h"
#import "FetchResult.h"

@interface PhotoFetcher ()

@property (nonatomic, readwrite) Feed *currentFeed;
@property (nonatomic) FetchResult *lastResult;

@end

@implementation PhotoFetcher


- (void)fetchUserFeedSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
}

- (void)fetchNextPageSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure
{
}
@end
