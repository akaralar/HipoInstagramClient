//
//  MediaCollection.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "Feed.h"

@interface Feed ()

@property (nonatomic, readwrite) NSArray *assets;
@property (nonatomic, readwrite, getter=isDisplayingLastPage) BOOL displayingLastPage;

@end

@implementation Feed

- (instancetype)initWithAssets:(NSArray *)assets
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    [self refreshWithAssets:assets];
    
    return self;
}

- (void)refreshWithAssets:(NSArray *)assets
{
    self.assets = [assets copy];
}

- (void)loadNewPageWithAssets:(NSArray *)assets
{
    self.assets = [self.assets arrayByAddingObjectsFromArray:assets];
}
@end
