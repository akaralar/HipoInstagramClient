//
//  SplashViewController.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 07/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "SplashViewController.h"

#import "LoginViewController.h"

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    LoginViewController *controller = [LoginViewController new];
    [self.navigationController pushViewController:controller animated:NO];
}

@end
