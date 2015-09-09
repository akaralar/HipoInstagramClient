//
//  MediaCollection.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "Feed.h"

#import "FetchResult.h"
#import "PaginationCursor.h"

@interface Feed ()

@property (nonatomic, readwrite) NSArray *assets;
@property (nonatomic, readwrite, getter=isDisplayingLastPage) BOOL displayingLastPage;

@end

@implementation Feed

- (instancetype)initWithFetchResult:(FetchResult *)fetchResult
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    [self refreshWithFetchResult:fetchResult];
    
    return self;
}

- (void)refreshWithFetchResult:(FetchResult *)fetchResult
{
    self.assets = [fetchResult.assets copy];
    self.displayingLastPage = (fetchResult.cursor.lastItemID == nil);
}

- (void)loadNewPageWithFetchResult:(FetchResult *)fetchResult
{
    self.assets = [self.assets arrayByAddingObjectsFromArray:fetchResult.assets];
    self.displayingLastPage = (fetchResult.cursor.lastItemID == nil);
}
@end
