//
//  FetchResult.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "FetchResult.h"
#import "Asset.h"
#import "PaginationCursor.h"

#import <Mantle/Mantle.h>

@interface FetchResult ()

@property (nonatomic, readwrite) PaginationCursor *cursor;
@property (nonatomic, readwrite) NSArray *assets;

@end

@implementation FetchResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @"cursor" : @"pagination",  //
        @"assets" : @"data"
    };
}

+ (NSValueTransformer *)cursorJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *paginationDict,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelOfClass:[PaginationCursor class]
                         fromJSONDictionary:paginationDict
                                      error:error];
    } reverseBlock:^id(PaginationCursor *cursor, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:cursor error:error];
    }];
}

+ (NSValueTransformer *)assetsJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *assetDicts,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[Asset class] fromJSONArray:assetDicts error:error];
    } reverseBlock:^id(NSArray *assets, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONArrayFromModels:assets error:error];
    }];
}


@end
