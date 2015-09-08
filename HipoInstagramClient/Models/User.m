//
//  User.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "User.h"

#import <Mantle/Mantle.h>

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"username" : @"username",  //
        @"avatarURL" : @"profile_picture"
    };
}

+ (NSValueTransformer *)avatarURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
