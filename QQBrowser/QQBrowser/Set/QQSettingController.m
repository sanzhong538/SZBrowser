//
//  QQSettingController.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/24.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQSettingController.h"
#import "BBConst.h"

@interface QQSettingController ()

@property (weak, nonatomic) IBOutlet UISwitch *rotateSwitch;

@end

@implementation QQSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.rotateSwitch.on = ![NSUserDefaults_get(@"isAutorotate") boolValue];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)clcikRotateSwitch:(UISwitch *)sender {
    
    NSUserDefaults_set(@(!sender.on), @"isAutorotate");
}

@end
