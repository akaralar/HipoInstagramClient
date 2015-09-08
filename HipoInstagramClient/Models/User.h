//
//  User.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"
#import <Mantle/MTLJSONAdapter.h>

@interface User : BaseModel <MTLJSONSerializing>

@property (nonatomic) NSString *username;
@property (nonatomic) NSURL *avatarURL;

@end
