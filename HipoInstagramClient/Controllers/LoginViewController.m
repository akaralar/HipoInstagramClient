//
//  LoginViewController.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "LoginViewController.h"
#import "APIManager.h"

#import "FeedViewController.h"


@import WebKit;

@interface LoginViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;

- (NSString *)userIDFromURL:(NSURL *)url;
- (NSString *)tokenFromURL:(NSURL *)url;

- (void)proceedToFeed;

@end

@implementation LoginViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Login";
    self.navigationItem.hidesBackButton = YES;

    self.webView = [[WKWebView alloc] initForAutoLayout];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];

    [self.webView autoPinEdgesToSuperviewEdges];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSURL *authURL = [APIManager authenticationURL];
    NSURLRequest *authRequest = [NSURLRequest requestWithURL:authURL];
    [self.webView loadRequest:authRequest];
}

#pragma mark - Internal Helpers

- (NSString *)userIDFromURL:(NSURL *)url
{
    NSString *token = [self tokenFromURL:url];
    if (!token) {
        return nil;
    }
    
    NSString *userID = [token componentsSeparatedByString:@"."][0];
    return userID;
}

- (NSString *)tokenFromURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    NSRange tokenParam = [urlString rangeOfString:@"access_token="];
    if (tokenParam.location == NSNotFound) {
        return nil;
    }
    
    NSString *token = [urlString substringFromIndex:NSMaxRange(tokenParam)];
    
    // If there are more args, don't include them in the token:
    NSRange endRange = [token rangeOfString:@"&"];
    if (endRange.location != NSNotFound) {
        token = [token substringToIndex:endRange.location];
    }
    
    return token;
}

- (void)proceedToFeed
{
    FeedViewController *controller = [FeedViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    if ([APIManager isAuthenticationRedirectHost:url.host]) {
        
        NSString *userID = [self userIDFromURL:url];
        NSString *token = [self tokenFromURL:url];
        
        if (userID && token) {
            [[APIManager sharedManager] saveUserID:userID];
            [[APIManager sharedManager] saveAccessToken:token];

            decisionHandler(WKNavigationActionPolicyCancel);
            
            [self proceedToFeed];
            return;
        }
        else {
            // TODO: handle error in auth
        }
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
