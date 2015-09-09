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
    return @{ @"imageURL" : @"url", @"width" : @"width", @"height" : @"height" };
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (CGFloat)aspectRatio
{
    return self.width / self.height;
}

@end
