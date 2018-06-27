//
//  QQCategoryController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/21.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQCategoryController.h"
#import "WKWebView+Storage.h"
#import "UIDevice+Type.h"

@interface QQCategoryController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, assign) CGFloat statusHeight;

@end

@implementation QQCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tabBarHeight = [UIDevice isIPoneX] ? 83 : 49;
    self.statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
//    [self addTabBarView];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0, self.statusHeight, BBSCREENWIDTH, self.view.height-self.statusHeight);
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.webView.width = BBSCREENWIDTH;
}

- (void)setUrlStr:(NSString *)urlStr {
    
    _urlStr = urlStr;
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

- (void)setRequest:(NSURLRequest *)request {
    
    _request = request;
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addChildViewController" object:nil userInfo:@{@"webView":webView}];
    NSNumber *num = NSUserDefaults_get(@"withoutHistory");
    if (![num boolValue]) {
        [webView storageHistoryWithType:@"1"];
    }
}

@end
