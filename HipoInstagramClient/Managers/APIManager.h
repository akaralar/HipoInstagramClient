//
//  APIManager.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void(^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface APIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
