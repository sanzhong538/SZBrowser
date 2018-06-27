//
//  QQSearchViewController.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/23.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQSearchController.h"
#import "WKWebView+Storage.h"

@interface QQSearchController ()<UITextFieldDelegate>

@property (nonatomic, copy) removeFromView removeFromView;

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation QQSearchController

+ (instancetype)searchController:(removeFromView)removeFromView {
    
    QQSearchController *searchVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"searchControllerIdentifier"];
    searchVC.removeFromView = removeFromView;
    return searchVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.webView.width = BBSCREENWIDTH;
}

- (void)setup {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    self.searchField.leftView = imgV;
    self.searchField.leftView.width = 35;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.layer.borderColor = BBColorFromRGB(0x4CBEFF).CGColor;
    self.searchField.layer.borderWidth = 1;
    [self.view addSubview:self.webView];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.webView.frame = self.contentView.frame;
}

- (void)setDict:(NSDictionary *)dict {
    
    _dict = dict;
    _searchStr = nil;
    _historyDict = nil;
    self.searchField.text = dict[@"title"];
    [self request:dict[@"url"]];
}

- (void)setHistoryDict:(NSDictionary *)historyDict {
    
    _historyDict = historyDict;
    _dict = nil;
    _searchStr = nil;
    [self loadHistory];
}

- (void)setSearchStr:(NSString *)searchStr {
    
    _searchStr = searchStr;
    _dict = nil;
    _historyDict = nil;
    self.searchField.text = searchStr;
    if ([self isUrl:searchStr]) {
        if (![searchStr hasPrefix:@"http"]) {
            searchStr = [NSString stringWithFormat:@"http://%@",searchStr];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchStr]];
        [self.webView loadRequest:request];
    } else {
        [self request:[self.engineURL stringByReplacingOccurrencesOfString:@"__KEYWORD__" withString:searchStr]];
    }
}

- (BOOL)isUrl:(NSString *)str {
    
    if(str == nil) return NO;
    
//    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
    
    NSString *urlRegex = @"^[a-zA-Z]+(//:)?[a-zA-Z0-9.]+\\.[a-zA-Z0-9?&]*[a-zA-Z0-9]$";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:str];
}

- (void)request:(NSString *)url {
    
    NSString *urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

- (void)loadHistory {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.historyDict[@"url"]]];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addChildViewController" object:nil userInfo:@{@"webView":webView}];
    NSNumber *num = NSUserDefaults_get(@"withoutHistory");
    if (![num boolValue]) {
        [webView storageHistoryWithType:@"3"];
    }
}

#pragma mark - action

- (IBAction)clickSearchBtn:(UIButton *)sender {
    
    if (self.dict) {
        [self request:self.dict[@"url"]];
    } else if (self.searchStr){
        self.searchStr = self.searchField.text;
    } else {
        [self loadHistory];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.view removeFromSuperview];
    if (self.removeFromView) {
        self.removeFromView();
    }
    return NO;
}

@end
