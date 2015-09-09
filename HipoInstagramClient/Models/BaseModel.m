//
//  BaseModel.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

static NSNumberFormatter *kNumberFormatter = nil;

@interface BaseModel ()

@end

@implementation BaseModel

+ (NSNumberFormatter *)unixTimeFormatter
{
    if (!kNumberFormatter) {

        kNumberFormatter = [NSNumberFormatter new];
        kNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return kNumberFormatter;
}

@end
