//
//  Asset.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

@interface Asset : BaseModel

@property (nonatomic) NSString *ownerUsername;
@property (nonatomic) NSURL *ownerAvatarURL;
@property (nonatomic) NSDate *postDate;
@property (nonatomic) NSURL *assetURL;

@end
