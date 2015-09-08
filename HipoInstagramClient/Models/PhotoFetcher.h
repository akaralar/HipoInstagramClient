//
//  PhotoFetcher.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

@class Feed;

@interface PhotoFetcher : BaseModel

@property (nonatomic) Feed *fetchedMedia;

@end
