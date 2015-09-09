//
//  FeedUpdate.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "FeedUpdate.h"
#import "Feed.h"

#import <UIKit/UITableView.h>

@interface FeedUpdate ()

@property (nonatomic, readwrite) NSArray *indexPathsToDelete;
@property (nonatomic, readwrite) NSArray *indexPathsToInsert;
@property (nonatomic, readwrite) NSArray *indexPathsToReload;
@property (nonatomic, readwrite) NSIndexSet *sectionsToDelete;
@property (nonatomic, readwrite) NSIndexSet *sectionsToInsert;

@end

@implementation FeedUpdate

- (instancetype)initWithFromFeed:(Feed *)fromFeed toFeed:(Feed *)toFeed
{
    self = [super init];

    if (!self) {
        return nil;
    }

    NSUInteger fromFeedCount = fromFeed.assets.count;
    NSUInteger toFeedCount = toFeed.assets.count;

    NSInteger difference = (NSInteger)toFeedCount - (NSInteger)fromFeedCount;
    if (difference > 0) {

        NSMutableArray *differenceArray = [toFeed.assets mutableCopy];
        [differenceArray removeObjectsInArray:fromFeed.assets];
        if ((NSInteger)differenceArray.count == difference) {

            _indexPathsToReload = @[];
            _indexPathsToInsert =
                [self indexPathsForRange:NSMakeRange(fromFeedCount, (NSUInteger)difference)  //
                               inSection:0];
        }
        else {

            _indexPathsToReload =
                [self indexPathsForRange:NSMakeRange(0, fromFeedCount) inSection:0];
            _indexPathsToInsert =
                [self indexPathsForRange:NSMakeRange(fromFeedCount, (NSUInteger)difference)  //
                               inSection:0];
        }
        _indexPathsToDelete = @[];
    }
    else if (difference < 0) {

        _indexPathsToInsert = @[];
        _indexPathsToReload = [self indexPathsForRange:NSMakeRange(0, toFeedCount) inSection:0];
        _indexPathsToDelete =
            [self indexPathsForRange:NSMakeRange(toFeedCount, fromFeedCount - toFeedCount)  //
                           inSection:0];
    }
    else {

        _indexPathsToInsert = @[];
        _indexPathsToDelete = @[];

        if ([toFeed.assets isEqualToArray:fromFeed.assets]) {
            _indexPathsToReload = @[];
        }
        else {
            _indexPathsToReload = [self indexPathsForRange:NSMakeRange(0, toFeedCount) inSection:0];
        }
    }

    if (fromFeed.isDisplayingLastPage && !toFeed.isDisplayingLastPage) {

        _sectionsToInsert = [NSIndexSet indexSetWithIndex:1];
        _sectionsToDelete = [NSIndexSet indexSet];
    }
    else if (!fromFeed.isDisplayingLastPage && toFeed.isDisplayingLastPage) {

        _sectionsToInsert = [NSIndexSet indexSet];
        _sectionsToDelete = [NSIndexSet indexSetWithIndex:1];
    }
    else {
        _sectionsToInsert = [NSIndexSet indexSet];
        _sectionsToDelete = [NSIndexSet indexSet];
    }

    return self;
}

- (NSArray *)indexPathsForRange:(NSRange)range inSection:(NSInteger)section
{
    NSMutableArray *indexes = [NSMutableArray array];
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {

        [indexes addObject:[NSIndexPath indexPathForRow:(NSInteger)i inSection:section]];
    }

    return [indexes copy];
}

- (NSString *)description
{
    return [NSString
        stringWithFormat:@"delete: %ld, insert: %ld, reload: %ld, sDelete: %ld, sInsert: %ld",
                         self.indexPathsToDelete.count,
                         self.indexPathsToInsert.count,
                         self.indexPathsToReload.count,
                         self.sectionsToDelete.count,
                         self.sectionsToInsert.count];
}

@end
