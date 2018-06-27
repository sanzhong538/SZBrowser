//
//  QQClearCacheController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQClearCacheController.h"
#import <WebKit/WebKit.h>
#import "BBProgressHUD.h"
#import "BBConst.h"

@interface QQClearCacheController ()

@property (weak, nonatomic) IBOutlet UIButton *historyBtn;
@property (weak, nonatomic) IBOutlet UIButton *cacheBtn;
@property (weak, nonatomic) IBOutlet UIButton *cookieBtn;

@end

@implementation QQClearCacheController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)clickBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (IBAction)clickClearBtn:(UIButton *)sender {
    
    if (!self.historyBtn.selected && !self.cacheBtn.selected && !self.cookieBtn.selected) {
        return;
    }
    
    if (self.historyBtn.selected) {
        NSUserDefaults_move(@"browseHistory");
    }
    if (self.cacheBtn.selected) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    if (self.cookieBtn.selected) {
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:WKWebsiteDataStore.allWebsiteDataTypes modifiedSince:[NSDate date] completionHandler:^{
            
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BBProgressHUD showSuccessWithStatus:@"清除完成"];
    });
}

@end
