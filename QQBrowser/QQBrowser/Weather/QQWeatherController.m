//
//  QQWeatherController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/21.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQWeatherController.h"
#import "BBProgressHUD.h"

@interface QQWeatherController ()

@end

@implementation QQWeatherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.webView.frame = CGRectMake(0, statusH, BBSCREENWIDTH, BBSCREENHEIGHT-statusH);
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    self.view.backgroundColor = BBColorFromRGB(0xF8F8F8);
    [self addBackBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.webView.width = BBSCREENWIDTH;
}

- (void)addBackBtn {
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, [UIApplication sharedApplication].statusBarFrame.size.height+7, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)clickBackBtn {
    if ([BBProgressHUD isVisible]) {
        [BBProgressHUD dismiss];
    }
    [self.webView stopLoading];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setWeatherURL:(NSString *)weatherURL {
    
    _weatherURL = weatherURL;
    [BBProgressHUD show];
    NSString *urlStr = [weatherURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
    } else if ([keyPath isEqualToString:@"title"]) {
    }
}

#pragma mark - WKUIDelegate, WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [super webView:webView didStartProvisionalNavigation:navigation];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFinishNavigation:navigation];
    [BBProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [super webView:webView didFailProvisionalNavigation:navigation withError:error];
    [BBProgressHUD dismiss];
}

@end
