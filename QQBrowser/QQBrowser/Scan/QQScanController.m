//
//  QQScanController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/26.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQScanController.h"

@interface QQScanController ()

@end

@implementation QQScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
