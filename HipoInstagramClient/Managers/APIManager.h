//
//  APIManager.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^SuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface APIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
+ (NSURL *)authenticationURL;
+ (BOOL)isAuthenticationRedirectHost:(NSString *)host;

- (void)saveUserID:(NSString *)userID;
- (void)saveAccessToken:(NSString *)accessToken;

- (void)getFeedPhotosAfterMediaWithID:(NSString *)mediaID
                         itemsPerPage:(NSNumber *)itemsPerPage
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;

@end
