//
//  QQDetailController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/21.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQDetailController.h"
#import "QQNavigationController.h"
#import "WKWebView+Storage.h"
#import "UIImage+Extension.h"
#import "UIDevice+Type.h"
#import "BBConst.h"

@interface QQDetailController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, assign) float delayTime;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat tabBarHeight;

@property (weak, nonatomic) UILabel *countLbl;

@end

@implementation QQDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.offsetY = [UIDevice isIPoneX] ? 88 : 64;
    self.tabBarHeight = [UIDevice isIPoneX] ? 83 : 49;
    [self addWebView];
    [self addTabBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.countLbl.text = [NSString stringWithFormat:@"%ld", self.navigationController.parentViewController.childViewControllers.count];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.progressView.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.webView.width = BBSCREENWIDTH;
}

- (void)addWebView {
    
    self.webView.frame = CGRectMake(0, 0, BBSCREENWIDTH, self.view.height-self.tabBarHeight);
    [self.view addSubview:self.webView];
    self.webView.scrollView.delegate = self;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height-2, BBSCREENWIDTH, 2)];
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.tintColor = [UIColor blueColor];
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)addTabBarView {
    
    UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-self.tabBarHeight, BBSCREENWIDTH, self.tabBarHeight)];
    tabBarView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:tabBarView];
    
    CGFloat width = BBSCREENWIDTH/5.0;
    CGFloat height = 30;
    CGFloat y = 10;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, width, height)];
    [backBtn setImage:[UIImage imageNamed:@"ai_map_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:backBtn];
    
    UIButton *mutilwindBtn = [[UIButton alloc] initWithFrame:CGRectMake(BBSCREENWIDTH-width, y, width, height)];
    [mutilwindBtn setImage:[UIImage imageNamed:@"toolbar_icon_wnd_btn"] forState:UIControlStateNormal];
    [mutilwindBtn addTarget:self action:@selector(clickMutilwindBtn) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:mutilwindBtn];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:mutilwindBtn.frame];
    self.countLbl = lbl;
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textAlignment = NSTextAlignmentCenter;
    [tabBarView addSubview:lbl];
}

- (void)clickBackBtn {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickMutilwindBtn {
    
    UIImage *image = [UIImage imageByView:self.view withFrame:CGRectMake(0, 0, BBSCREENWIDTH, BBSCREENHEIGHT-44)];
    QQNavigationController *nav = (QQNavigationController *)self.navigationController;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMutilwindNotification" object:nil userInfo:@{@"title":self.webView.title, @"image":image, @"index":@(nav.index)}];
}

- (void)setRequest:(NSURLRequest *)request {
    
    _request = request;
    [self.webView loadRequest:request];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress < 1.0) {
            self.delayTime = 1 - self.webView.estimatedProgress;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 0;
        });
    } else if ([keyPath isEqualToString:@"title"]) {
        self.webTitle = self.webView.title;
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    NSNumber *num = NSUserDefaults_get(@"withoutHistory");
    if (![num boolValue]) {
        [webView storageHistoryWithType:@"2"];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y >= self.offsetY) {
        self.title = self.webTitle;
    } else {
        self.title = nil;
    }
}

@end
