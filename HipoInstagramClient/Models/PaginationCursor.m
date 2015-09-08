//
//  PaginationCursor.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "PaginationCursor.h"

@interface PaginationCursor ()

@property (nonatomic, readwrite) NSString *lastItemID;

@end

@implementation PaginationCursor

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"lastItemID" : @"next_max_id" };
}
@end
