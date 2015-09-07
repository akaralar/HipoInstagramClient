//
//  APIManager.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "APIManager.h"

static NSString *const kBaseURL = @"https://api.instagram.com/";
static NSString *const kClientID = @"36412ddc9ac044fc99783825ba3747ab";
static NSString *const kClientSecret = @"78a207a5f87f4055a641ef9ff1673546";

static NSString *kAuthRedirectURI = nil;
NSString *const kAuthRedirectURIHostName = @"localhost";

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
    if (!kAuthRedirectURI) {
        kAuthRedirectURI = [NSString stringWithFormat:@"http://%@:8888/", kAuthRedirectURIHostName];
    }

    NSString *urlString =
        [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/"
                                   @"?client_id=%@&redirect_uri=%@&response_type=token",
                                   kClientID,
                                   kAuthRedirectURI];

    return [NSURL URLWithString:urlString];
}

- (void)saveAccessToken:(NSString *)accessToken
{
    self.accessToken = accessToken;
}

- (void)saveUserID:(NSString *)userID
{
    self.userID = userID;
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
