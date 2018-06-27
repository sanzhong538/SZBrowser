//
//  QQBaseNavController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseNavController.h"
#import "UIBarButtonItem+SZ.h"
#import "BBConst.h"

@interface QQBaseNavController ()

@end

@implementation QQBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [NSUserDefaults_get(@"isAutorotate") boolValue] ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:nil norImage:@"ai_map_back" heightImage:nil target:self action:@selector(pop)];
    [super pushViewController:viewController animated:animated];
}

- (void)pop {

    [self popViewControllerAnimated:YES];
}

@end
