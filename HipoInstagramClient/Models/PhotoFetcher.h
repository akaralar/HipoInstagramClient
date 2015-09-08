//
//  PhotoFetcher.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

@class Feed;

typedef void(^FetchSuccessBlock)(Feed *feedAfterFetch);
typedef void(^FetchFailureBlock)(NSError *error);

@interface PhotoFetcher : BaseModel

@property (nonatomic, readonly) Feed *currentFeed;

- (void)fetchUserFeedSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure;
- (void)fetchNextPageSuccess:(FetchSuccessBlock)success failure:(FetchFailureBlock)failure;

@end
