//
//  Asset.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"
#import <Mantle/MTLJSONAdapter.h>

@class User;

@interface Asset : BaseModel <MTLJSONSerializing>

@property (nonatomic) NSString *identifier;
@property (nonatomic) User *owner;
@property (nonatomic) NSDate *postDate;
@property (nonatomic) NSURL *assetURL;

@end
