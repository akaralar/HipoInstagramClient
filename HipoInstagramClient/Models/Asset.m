//
//  Asset.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "Asset.h"
#import "User.h"
#import "Image.h"
#import <Mantle/Mantle.h>

@implementation Asset

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"owner" : @"user",
        @"identifier" : @"id",
        @"postDate" : @"created_time",
        @"image" : @"images.standart_resolution"
    };
}

+ (NSValueTransformer *)ownerJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *userDict,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userDict error:error];
    } reverseBlock:^id(User *user, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:user error:error];
    }];
}

+ (NSValueTransformer *)postDateJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *unixTimeString,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        NSNumber *unixTime = [[BaseModel unixTimeFormatter] numberFromString:unixTimeString];
        return [NSDate dateWithTimeIntervalSince1970:unixTime.doubleValue];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [@([date timeIntervalSince1970]) stringValue];
    }];
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *imageDict,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[Image class] fromJSONDictionary:imageDict error:error];
    } reverseBlock:^id(Image *image, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:image error:error];
    }];
}


@end
