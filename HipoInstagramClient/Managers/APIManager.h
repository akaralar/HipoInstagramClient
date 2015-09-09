//
//  APIManager.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class FetchResult;

typedef void (^SuccessBlock)(NSURLSessionDataTask *task, FetchResult *result);
typedef void (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface APIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;
+ (NSURL *)authenticationURL;
+ (BOOL)isAuthenticationRedirectHost:(NSString *)host;

- (void)saveUserID:(NSString *)userID;
- (void)saveAccessToken:(NSString *)accessToken;

- (void)fetchFeedPhotosAfterItemWithID:(NSString *)itemID
                           itemsPerPage:(NSNumber *)itemsPerPage
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;

- (void)fetchPhotosWithTag:(NSString *)tag
           afterItemWithID:(NSString *)itemID
              itemsPerPage:(NSNumber *)itemsPerPage
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure;

@end
