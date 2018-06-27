//
//  QQBaseViewController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseViewController.h"

@interface QQBaseViewController ()

@end

@implementation QQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:@"reloadWebViewNotivication" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserAgent) name:@"changeUserAgentNotivication" object:nil];
}

- (void)changeUserAgent {
    
    WS(weakSelf)
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BBLog(@"%@", result);
        NSString *newUserAgent = NSUserDefaults_get(@"userAgent");
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        self.webView = nil;
        [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            BBLog(@"%@", result);
        }];
    }];
}

- (void)reloadWebView {
    
    [self.webView reload];
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [NSUserDefaults_get(@"isAutorotate") boolValue] ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

- (void)changeFont {
    
    NSNumber *num = NSUserDefaults_get(@"webTextFont");
    int textFontSize = 100;
    if (num) {
        textFontSize = [num intValue];
    }
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", textFontSize];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

- (void)changeBackColor {
    
    NSString *colorStr = NSUserDefaults_get(@"webViewBackgroundColor");
    if (!colorStr) {
        colorStr = @"#FFFFFF";
    }
    NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='%@'", colorStr];
    [self.webView evaluateJavaScript:js completionHandler:nil];
}

- (void)changeTextColor {
    
    [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#000000'" completionHandler:nil];
}

#pragma mark - WKUIDelegate, WKNavigationDelegate

/// 1 在发送请求之前，决定是否跳转（注：不加上decisionHandler回调会造成闪退）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
//    self.webView.customUserAgent = NSUserDefaults_get(@"userAgent");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self changeFont];
    [self changeBackColor];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    [self changeFont];
    [self changeBackColor];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"failRequest" withExtension:@"html"];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
    } else if ([keyPath isEqualToString:@"title"]) {
    }
}

#pragma mark - set/get

- (WKWebView *)webView
{
    if (_webView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        [configuration.userContentController addScriptMessageHandler:self name:@"back"];
        [configuration.userContentController addScriptMessageHandler:self name:@"refresh"];
        [configuration.userContentController addScriptMessageHandler:self name:@"loginAgain"];
        [configuration.userContentController addScriptMessageHandler:self name:@"backgroundColor"];
        [configuration.userContentController addScriptMessageHandler:self name:@"hiddenNavigationBar"];
        configuration.allowsInlineMediaPlayback = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BBSCREENWIDTH, BBSCREENHEIGHT) configuration:configuration];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.customUserAgent = NSUserDefaults_get(@"userAgent");
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
//        _webView.opaque = NO;
    }
    return _webView;
}

- (void)dealloc
{
    if (_webView != nil) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeObserver:self forKeyPath:@"title"];
        self.webView.UIDelegate = nil;
        self.webView.navigationDelegate = nil;
        [self.webView stopLoading];
        [self.webView removeFromSuperview];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.webView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
