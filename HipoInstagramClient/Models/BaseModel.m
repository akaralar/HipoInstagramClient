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
//        kNumberFormatter = [NSDateFormatter new];
//
//        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
//        [kNumberFormatter setLocale:enUSPOSIXLocale];
//        [kNumberFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
//        [kNumberFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return kNumberFormatter;
}

@end
