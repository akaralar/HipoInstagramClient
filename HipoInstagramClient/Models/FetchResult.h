//
//  FetchResult.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"
#import <Mantle/MTLJSONAdapter.h>

@class PaginationCursor;

@interface FetchResult : BaseModel <MTLJSONSerializing>

@property (nonatomic, readonly) PaginationCursor *cursor;
@property (nonatomic, readonly) NSArray *assets;

@end
