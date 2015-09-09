//
//  AppDelegate.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 06/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    SplashViewController *controller = [SplashViewController new];
    UINavigationController *navCont =
        [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navCont;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
