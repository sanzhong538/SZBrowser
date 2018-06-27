//
//  QQNavigationController.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQNavigationController.h"

@interface QQNavigationController ()

@end

@implementation QQNavigationController

+ (instancetype)navigationController {
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"navigationControllerIdentifier"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
