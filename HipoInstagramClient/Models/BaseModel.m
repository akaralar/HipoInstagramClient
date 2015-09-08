//
//  BaseModel.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"

static NSDateFormatter *kDateFormatter = nil;

@interface BaseModel ()

@end

@implementation BaseModel

+ (NSDateFormatter *)unixDateFormatter
{
    if (!kDateFormatter) {
        kDateFormatter = [NSDateFormatter new];

        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [kDateFormatter setLocale:enUSPOSIXLocale];
        [kDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
        [kDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return kDateFormatter;
}

@end
