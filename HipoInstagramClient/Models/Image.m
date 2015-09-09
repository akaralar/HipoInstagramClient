//
//  Image.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "Image.h"

#import <Mantle/Mantle.h>

@implementation Image

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"imageURL" : @"url"};
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    
    if (!self) {
        return nil;
    }
    
    CGFloat width = [dictionaryValue[@"width"] floatValue];
    CGFloat height = [dictionaryValue[@"height"] floatValue];
    
    _imageSize = CGSizeMake(width, height);
    
    return self;
}

@end
