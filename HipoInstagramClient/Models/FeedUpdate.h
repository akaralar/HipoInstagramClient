//
//  FeedUpdate.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

@class Feed;

@interface FeedUpdate : BaseModel

@property (nonatomic, readonly) NSArray *indexPathsToDelete;
@property (nonatomic, readonly) NSArray *indexPathsToInsert;
@property (nonatomic, readonly) NSArray *indexPathsToReload;
@property (nonatomic, readonly) NSIndexSet *sectionsToDelete;
@property (nonatomic, readonly) NSIndexSet *sectionsToInsert;

- (instancetype)initWithFromFeed:(Feed *)fromFeed toFeed:(Feed *)toFeed;

@end
