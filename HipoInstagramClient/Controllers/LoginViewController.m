//
//  LoginViewController.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "LoginViewController.h"
#import "APIManager.h"

#import <PureLayout/PureLayout.h>

@import WebKit;

@interface LoginViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;
@end

@implementation LoginViewController

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

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    if ([url.host isEqualToString:kAuthRedirectURIHostName]) {

        NSString *urlString = [url absoluteString];
        NSRange tokenParam = [urlString rangeOfString:@"access_token="];
        if (tokenParam.location != NSNotFound) {
            NSString *token = [urlString substringFromIndex:NSMaxRange(tokenParam)];

            // If there are more args, don't include them in the token:
            NSRange endRange = [token rangeOfString:@"&"];
            if (endRange.location != NSNotFound) {
                token = [token substringToIndex:endRange.location];
            }

            NSString *userID = [token componentsSeparatedByString:@"."][0];
            [[APIManager sharedManager] saveUserID:userID];
            [[APIManager sharedManager] saveAccessToken:token];

            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        else {
            // Handle the access rejected case here.
            NSLog(@"rejected case, user denied request");
        }
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
