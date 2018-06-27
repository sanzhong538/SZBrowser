//
//  QQGuideController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/27.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQGuideController.h"
#import "BBConst.h"

@interface QQGuideController ()

@end

@implementation QQGuideController

+ (instancetype)guideViewController {
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"guideControllerIdentifier"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    NSNumber *num = NSUserDefaults_get(@"firstOpenFlag");
    if ([num boolValue]) {
        [self performSegueWithIdentifier:@"unfirstOpenGuideIdentifier" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"firstOpenGuideIdentifier" sender:nil];
        NSUserDefaults_set(@(1), @"firstOpenFlag");
    }

}

@end
