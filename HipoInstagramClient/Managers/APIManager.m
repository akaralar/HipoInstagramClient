//
//  APIManager.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "APIManager.h"

#import "Asset.h"

#import <Mantle/MTLJSONAdapter.h>

static NSString *const kBaseURL = @"https://api.instagram.com/v1/";
static NSString *const kClientID = @"36412ddc9ac044fc99783825ba3747ab";
static NSString *const kClientSecret = @"78a207a5f87f4055a641ef9ff1673546";

static NSString *const kAuthRedirectURI = @"http://localhost:8888/";

static NSString *const kUserFeedPath = @"users/self/feed";

static NSString *const kTokenParameterKey = @"access_token";
static NSString *const kMaxIDParameterKey = @"max_id";
static NSString *const kItemsPerPageParameterKey = @"count";

static const NSInteger kDefaultItemsPerPage = 20;

@interface APIManager ()

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *accessToken;

+ (NSURLSessionConfiguration *)defaultConfiguration;
+ (AFHTTPRequestSerializer *)defaultRequestSerializer;
+ (AFHTTPResponseSerializer *)defaultResponseSerializer;

@end

@implementation APIManager

+ (instancetype)sharedManager
{
    static APIManager *_apiClient = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        NSURLSessionConfiguration *conf = [self defaultConfiguration];
        _apiClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]  //
                              sessionConfiguration:conf];
        _apiClient.requestSerializer = [self defaultRequestSerializer];
        _apiClient.responseSerializer = [self defaultResponseSerializer];
    });

    return _apiClient;
}

+ (NSURL *)authenticationURL
{
    NSString *urlString =
        [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/"
                                   @"?client_id=%@&redirect_uri=%@&response_type=token",
                                   kClientID,
                                   kAuthRedirectURI];

    return [NSURL URLWithString:urlString];
}

+ (BOOL)isAuthenticationRedirectHost:(NSString *)host
{
    return [host isEqualToString:[NSURL URLWithString:kAuthRedirectURI].host];
}

- (void)saveAccessToken:(NSString *)accessToken
{
    NSParameterAssert(accessToken);
    self.accessToken = accessToken;
}

- (void)saveUserID:(NSString *)userID
{
    NSParameterAssert(userID);
    self.userID = userID;
}

- (void)getFeedPhotosAfterMediaWithID:(NSString *)mediaID
                         itemsPerPage:(NSNumber *)itemsPerPage
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure

{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.accessToken forKey:kTokenParameterKey];

    if (mediaID) {
        [params setObject:mediaID forKey:kMaxIDParameterKey];
    }

    if (itemsPerPage) {
        [params setObject:itemsPerPage forKey:kItemsPerPageParameterKey];
    }
    else {
        [params setObject:@(kDefaultItemsPerPage) forKey:kItemsPerPageParameterKey];
    }

    SuccessBlock modifiedSuccess = ^(NSURLSessionDataTask *task, NSDictionary *responseObject) {  //

        NSArray *assets = [MTLJSONAdapter modelsOfClass:[Asset class]
                                          fromJSONArray:responseObject[@"data"]
                                                  error:nil];
        success(task, assets);
    };

    [self GET:kUserFeedPath parameters:params success:modifiedSuccess failure:failure];
}

#pragma mark - Internal Helpers

+ (NSURLSessionConfiguration *)defaultConfiguration
{
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

+ (AFHTTPRequestSerializer *)defaultRequestSerializer
{
    return [AFJSONRequestSerializer serializer];
}

+ (AFHTTPResponseSerializer *)defaultResponseSerializer
{
    return [AFJSONResponseSerializer serializer];
}

@end
