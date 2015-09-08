//
//  MediaCollection.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

@interface Feed : BaseModel

@property (nonatomic, readonly) NSArray *assets;
@property (nonatomic, readonly, getter=isDisplayingLastPage) BOOL displayingLastPage;

- (instancetype)initWithAssets:(NSArray *)assets;
- (void)refreshWithAssets:(NSArray *)assets;
- (void)loadNewPageWithAssets:(NSArray *)assets;


@end
