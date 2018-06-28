//
//  QQMainViewController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQMainViewController.h"
#import "QQCategoryController.h"
#import "QQWeatherController.h"
#import "QQSearchHistoryView.h"
#import "QQDetailController.h"
#import "QQSearchController.h"
#import "UIImage+Extension.h"
#import <UIButton+WebCache.h>
#import "QQScanController.h"
#import "MainTableView.h"
#import <WebKit/WebKit.h>
#import "UIDevice+Type.h"
#import "MainTableCell.h"
#import "BBNetworkTool.h"

@interface QQMainViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat bannerHeight;
@property (nonatomic, assign) CGFloat maxOffsetY;
@property (nonatomic, assign) BOOL IsSearchFieldTop;

@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) WKWebView *moreWebView;
@property (nonatomic, strong) UIImageView *upAnimatImgV;
@property (nonatomic, strong) UIImageView *downAnimatImgV;
@property (nonatomic, strong) QQSearchHistoryView *historyView;
@property (nonatomic, strong) QQSearchController *searchVC;
@property (nonatomic, strong) QQCategoryController *categoryVC;

@property (nonatomic, weak) IBOutlet MainTableView *mainTableView;
@property (weak, nonatomic) IBOutlet MainTableView *moreTableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImgView;
@property (weak, nonatomic) IBOutlet UIView *moreCategoryView;
@property (weak, nonatomic) IBOutlet UIView *mainHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchFieldLeftConstraint;
@property (weak, nonatomic) IBOutlet UIButton *tempButton;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *weatherLbl;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *headerCancelBtn;

@end

@implementation QQMainViewController

+ (instancetype)mainViewController {
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainControllerIdentifier"];
}

- (void)reloadData {
    
    self.searchField.text = nil;
    [self.searchField resignFirstResponder];
    self.searchFieldLeftConstraint.constant = 10;
    self.searchField.rightViewMode = UITextFieldViewModeAlways;
    [self.mainTableView setContentOffset:CGPointMake(0, -self.headerHeight) animated:NO];
    if (self.upAnimatImgV) {
        [self.upAnimatImgV removeFromSuperview];
        self.upAnimatImgV = nil;
    }
    if (self.downAnimatImgV) {
        [self.downAnimatImgV removeFromSuperview];
        self.downAnimatImgV = nil;
    }
    [self loadData];
}

//type： 1 其他站点  2 详情页 3 搜索页
- (void)jumpHistory:(NSDictionary *)dict {
    
    if ([dict[@"type"] isEqualToString:@"1"]) {
        self.categoryVC.urlStr = dict[@"url"];
        [self showCategoryView];
    } else if ([dict[@"type"] isEqualToString:@"2"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"url"]]];
        [self showDetailView:request];
    } else {
        self.searchVC.historyDict = dict;
        [self showSearchView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self changeStatus];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    if (_historyView && !_historyView.hidden) {
        self.historyView.frame = CGRectMake(0, [UIDevice isIPoneX] ? 88 : 64, BBSCREENWIDTH, BBSCREENHEIGHT - ([UIDevice isIPoneX] ? 88 : 64));
    }
    self.webView.width = BBSCREENWIDTH;
}

- (void)addChildViewController:(UIViewController *)childController {
    
    [super addChildViewController:childController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addChildViewController" object:nil];
}

- (void)setup {
    
    self.topView = self.view;
    self.webView.scrollView.delegate = self;
    self.headerHeight = [UIDevice isIPoneX] ? 180 : 160 ;
    self.headerViewHeight.constant = self.headerHeight;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);
    self.mainTableView.canSlip = YES;
    self.moreTableView.canSlip = YES;
    [self loadData];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audiozone_search-1"]];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    self.searchField.leftView = imgV;
    self.searchField.leftView.width = 35;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [btn setImage:[UIImage imageNamed:@"qrcode_entry_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openScanVC) forControlEvents:UIControlEventTouchUpInside];
    self.searchField.rightView = btn;
    self.searchField.rightView.width = 35;
    self.searchField.rightViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [self scrollViewDidScroll:self.mainTableView];
}

- (void)refreshCurrentView {
    
    [self.mainTableView reloadData];
    self.tempButton.userInteractionEnabled = YES;
    [self.tempButton setTitle:self.resultDict[@"weather"][@"temp"] forState:UIControlStateNormal];
    self.weatherLbl.text = self.resultDict[@"weather"][@"weather"];
    self.cityLbl.text = self.resultDict[@"weather"][@"city"];
    if (self.resultDict[@"recommend"]) {
        [self.recommendBtn sd_setImageWithURL:[NSURL URLWithString:self.resultDict[@"recommend"][@"image"]] forState:UIControlStateNormal];
    }

    NSString *urlStr = [self.resultDict[@"main_url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.webView loadRequest:request];
}

- (void)refreshMoreTableView {
    
    [self.moreTableView reloadData];
    NSString *urlStr = [self.resultDict[@"banner_more_url"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.moreWebView loadRequest:request];
}

- (void)showCategoryController:(NSString *)urlStr {
    
    if ([urlStr isEqualToString:@"more"]) {
        [self showMoreTableViewWithAnimation];
    } else {
        self.categoryVC.urlStr = urlStr;
        [self showCategoryView];
    }
}

#pragma mark - private

- (void)showMoreTableViewWithAnimation {
    
    self.view.clipsToBounds = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UIImage *img = [UIImage imageByView:self.view];
    NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
    img = [UIImage imageWithData:imageData];
    [img drawInRect:self.view.bounds];
    self.upAnimatImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BBSCREENWIDTH, self.headerHeight+self.bannerHeight)];
    self.upAnimatImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.upAnimatImgV.image = [UIImage imageCut:img withRect:CGRectMake(0, 0, img.size.width, img.size.height*(self.headerHeight+self.bannerHeight)/self.view.height)];
    [self.view addSubview:self.upAnimatImgV];
    self.downAnimatImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerHeight+self.bannerHeight, BBSCREENWIDTH, self.view.height-self.headerHeight-self.bannerHeight)];
    self.downAnimatImgV.contentMode = UIViewContentModeScaleAspectFill;
    self.downAnimatImgV.image = [UIImage imageCut:img withRect:CGRectMake(0, img.size.height*(self.headerHeight+self.bannerHeight)/self.view.height, img.size.width, img.size.height-img.size.height*(self.headerHeight+self.bannerHeight)/self.view.height)];
    [self.view addSubview:self.downAnimatImgV];
    
    self.moreCategoryView.hidden = NO;
    self.topView = self.moreCategoryView;
    [self refreshMoreTableView];
    
    WS(weakSelf)
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.upAnimatImgV.y = -weakSelf.headerHeight-weakSelf.bannerHeight;
        weakSelf.downAnimatImgV.y = weakSelf.view.height;
    } completion:^(BOOL finished) {
        weakSelf.upAnimatImgV.hidden = YES;
        weakSelf.downAnimatImgV.hidden = YES;
    }];
}

- (void)dismissMoreTableViewWithAnimation {

    self.upAnimatImgV.hidden = NO;
    self.downAnimatImgV.hidden = NO;
    WS(weakSelf)
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.upAnimatImgV.y = 0;
        weakSelf.downAnimatImgV.y = weakSelf.bannerHeight+self.headerHeight;
    } completion:^(BOOL finished) {
        [weakSelf.upAnimatImgV removeFromSuperview];
        [weakSelf.downAnimatImgV removeFromSuperview];
        weakSelf.upAnimatImgV = nil;
        weakSelf.downAnimatImgV = nil;
        weakSelf.moreCategoryView.hidden = YES;
        weakSelf.topView = weakSelf.view;
        [weakSelf.moreWebView stopLoading];
        [weakSelf.moreWebView removeFromSuperview];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        weakSelf.moreWebView = nil;
        [weakSelf refreshCurrentView];
        weakSelf.view.clipsToBounds = NO;
    }];
}


- (void)openScanVC {
    
    QQScanController *scanVC = [[QQScanController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
        
    }];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)changeStatus {
    
    [self.mainTableView setScrollEnabled:YES];
    self.mainTableView.canSlip = YES;
    if (!self.searchField.isFirstResponder) {
        CGPoint p =  [self.mainTableView.panGestureRecognizer translationInView:self.mainTableView];
        if (p.y > 0) {
            [self.mainTableView setContentOffset:CGPointMake(0, -self.headerHeight) animated:YES];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
        } else  if (p.y < 0){
            [self.mainTableView setContentOffset:CGPointMake(0, self.self.maxOffsetY) animated:YES];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    if (self.mainTableView.contentOffset.y <= -self.headerHeight && [UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleDefault) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    if (self.mainTableView.contentOffset.y >= floor(self.maxOffsetY) && [UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

- (void)changeSearchField:(BOOL)isBegin {
    
    if (isBegin) {
        [self.mainTableView setContentOffset:CGPointMake(0, self.maxOffsetY) animated:YES];
        self.searchField.rightViewMode = UITextFieldViewModeNever;
        
    } else {
        if (!self.IsSearchFieldTop) {
            [self.mainTableView setContentOffset:CGPointMake(0, -self.headerHeight) animated:YES];
        }
        self.searchField.rightViewMode = UITextFieldViewModeAlways;
        self.searchField.text = nil;
        [self.searchField resignFirstResponder];
    }
    WS(weakSelf)
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.searchFieldLeftConstraint.constant = isBegin ? 60 : 10;
    } completion:^(BOOL finished) {
        if (isBegin) {
            weakSelf.historyView.hidden = NO;
            [weakSelf.view addSubview:weakSelf.historyView];
            weakSelf.topView = weakSelf.historyView;
            [weakSelf.historyView didMoveToSuperview];
        } else {
            [weakSelf.historyView removeFromSuperview];
            weakSelf.topView = weakSelf.view;
            weakSelf.historyView = nil;
        }
    }];
}

- (void)showSearchView {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self addChildViewController:self.searchVC];
    [self.view addSubview:self.searchVC.view];
    self.topView = self.searchVC.view;
    self.historyView.hidden = YES;
    self.topViewType = @"3";
    [self.searchField resignFirstResponder];
}

- (void)showCategoryView {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self addChildViewController:self.categoryVC];
    [self.view addSubview:self.categoryVC.view];
    self.topView = self.categoryVC.view;
    self.topViewType = @"1";
}

- (void)showDetailView:(NSURLRequest *)request {
    
    QQDetailController *detailVC = [[QQDetailController alloc] init];
    detailVC.request = request;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - net

- (void)loadData {
    
    WS(weakSelf)
    [[BBNetworkTool sharedNetWorkTool] getWithURLStr:nil parameters:nil model:nil showHUD:NO success:^(id result, id originaldata) {
        
        weakSelf.resultDict = result;
        [weakSelf refreshCurrentView];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - action

- (IBAction)clickWeatherBtn:(UIButton *)sender {
    
    QQWeatherController *weatherVC = [[QQWeatherController alloc] init];
    [self.parentViewController presentViewController:weatherVC animated:NO completion:nil];
    NSString *searchStr = self.resultDict[@"search_url"];
    weatherVC.weatherURL = [searchStr stringByReplacingOccurrencesOfString:@"__KEYWORD__" withString:@"天气"];
}

- (IBAction)closeMoreTableView:(id)sender {
    
    [self dismissMoreTableViewWithAnimation];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)clickHeaderCancelBtn:(UIButton *)sender {
    
    if (self.searchVC.dict || self.searchVC.searchStr || self.searchVC.historyDict) {
        [self showSearchView];
    } else {
        [self changeSearchField:NO];
    }
}
- (IBAction)clickRecommendBtn:(UIButton *)sender {
    
    if (self.resultDict[@"recommend"]) {
        QQWeatherController *weatherVC = [[QQWeatherController alloc] init];
        [self.parentViewController presentViewController:weatherVC animated:NO completion:nil];
        weatherVC.weatherURL = self.resultDict[@"recommend"][@"url"];
    }
}

#pragma mark - WKUIDelegate, WKNavigationDelegate

/// 1 在发送请求之前，决定是否跳转（注：不加上decisionHandler回调会造成闪退）
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.absoluteString isEqualToString:self.resultDict[@"main_url"]] || [navigationAction.request.URL.absoluteString isEqualToString:self.resultDict[@"banner_more_url"]] || [navigationAction.request.URL.absoluteString containsString:@"/list"] || [navigationAction.request.URL.absoluteString containsString:@"page="]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        if (self.moreCategoryView.hidden) {
            [self showDetailView:navigationAction.request];
        } else {
            self.categoryVC.request = navigationAction.request;
            [self showCategoryView];
        }
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tableView == self.mainTableView ? @"mainTableCellIdentifier" : @"moreTableCellIdentifier" forIndexPath:indexPath];
        cell.dataArray =  tableView == self.mainTableView ? self.resultDict[@"banner"] : self.resultDict[@"banner_more"];
        WS(weakSelf)
        cell.clickItemBack = ^(NSString *urlStr) {
            [weakSelf showCategoryController:urlStr];
        };
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (!self.moreCategoryView || self.moreCategoryView.hidden) {
            [cell addSubview:self.webView];
        } else {
            [cell addSubview:self.moreWebView];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return self.bannerHeight;
    } else {
        CGFloat H = [UIDevice isIPoneX] ? BBSCREENHEIGHT - 88 - 83 : BBSCREENHEIGHT - 64 - 49;
        if (!self.moreCategoryView || self.moreCategoryView.hidden) {
            self.webView.height = H;
        } else {
            self.moreWebView.height = H;
        }
        return H;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.mainTableView == scrollView) {
//        UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
//        if (pan) {
//            CGPoint p = [pan translationInView:self.mainTableView];
//            if (p.y > 0 && scrollView.contentOffset.y == -self.headerHeight) {
//                [self.mainTableView setScrollEnabled:NO];
//            } else {
//                [self.mainTableView setScrollEnabled:YES];
//            }
//        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (scrollView == self.mainTableView) {
        [self changeStatus];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView == self.mainTableView) {
        [self changeStatus];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainTableView) {
        [self changeStatus];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.mainTableView == scrollView) {
        CGFloat offsetY = self.mainTableView.contentOffset.y;
        if (offsetY >= floor(self.maxOffsetY)) {
            self.headerBackImgView.alpha = 0.0;
            self.mainHeaderView.y = ([UIDevice isIPoneX] ? 88 : 64) - self.headerHeight;
            self.mainTableView.canSlip = NO;
        } else {
            self.mainTableView.canSlip = YES;
            BOOL hide = self.headerHeight+offsetY > 30;
            self.tempButton.hidden = hide;
            self.cityLbl.hidden = hide;
            self.weatherLbl.hidden = hide;
            self.recommendBtn.hidden = hide;
            CGPoint p =  [scrollView.panGestureRecognizer translationInView:self.mainTableView];
            if (p.y > 0 && self.webView.scrollView.contentOffset.y > 0) {
                self.mainTableView.contentOffset = CGPointMake(0, self.maxOffsetY);
            } else {
                [self.webView.scrollView setContentOffset:CGPointZero animated:NO];
            }
            if (offsetY >= -([UIDevice isIPoneX] ? 88 : 64)) {
                self.mainHeaderView.y = ([UIDevice isIPoneX] ? 88 : 64) - self.headerHeight;
                self.headerBackImgView.alpha = 0;
            } else {
                self.mainHeaderView.y = -(self.headerHeight + self.mainTableView.contentOffset.y);
                self.headerBackImgView.alpha = ABS(offsetY+([UIDevice isIPoneX] ? 88 : 64))/(self.headerHeight-([UIDevice isIPoneX] ? 88 : 64));
            }
        }
    } else {
        if (self.webView.scrollView.contentOffset.y <= 0) {
            self.mainTableView.canSlip = YES;
        } else {
            self.mainTableView.canSlip = NO;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    self.IsSearchFieldTop = _historyView ? self.IsSearchFieldTop : !self.headerBackImgView.alpha;
    [self changeSearchField:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        return NO;
    }
    NSArray *array = NSUserDefaults_get(@"history_search");
    if (array==nil || array.count == 0) {
        NSArray *arr = [NSArray arrayWithObject:textField.text];
        NSUserDefaults_set(arr, @"history_search");
    } else {
        NSMutableArray *tempArray = [NSMutableArray arrayWithObject:textField.text];
        [tempArray addObjectsFromArray:array];
        if (tempArray.count > 20) {
            [tempArray removeLastObject];
        }
        NSUserDefaults_set(tempArray.copy, @"history_search");
    }
    self.searchField.text = textField.text;
    self.searchVC.searchStr = textField.text;
    [self showSearchView];
    return YES;
}

#pragma mark - set/get

- (CGFloat)bannerHeight {
    
    NSArray *tempArray = (!self.moreCategoryView || self.moreCategoryView.hidden) ? self.resultDict[@"banner"] : self.resultDict[@"banner_more"];
    if (self.resultDict && tempArray && [tempArray count]) {
        NSUInteger count = [tempArray count];
        if (BBSCREENWIDTH < 375) {
            CGFloat WH = (BBSCREENWIDTH-4*10-10*2)/5.0;
            NSUInteger col = (count + 4) / 5;
            return 10*2+col*WH+10*(col-1);
        } else {
            CGFloat WH = (BBSCREENWIDTH-5*10-10*2)/6.0;
            NSUInteger col = (count + 5) / 6;
            return 10*2+col*WH+10*(col-1);
        }
    } else {
        return 0;
    }
}

- (CGFloat)maxOffsetY {
    
    return self.bannerHeight-([UIDevice isIPoneX] ? 88 : 64);
}

- (WKWebView *)moreWebView {
    
    if (_moreWebView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        _moreWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BBSCREENWIDTH, BBSCREENHEIGHT) configuration:configuration];
        _moreWebView.allowsBackForwardNavigationGestures = YES;
        _moreWebView.backgroundColor = [UIColor clearColor];
        _moreWebView.UIDelegate = self;
        _moreWebView.navigationDelegate = self;
    }
    return _moreWebView;
}

- (QQSearchHistoryView *)historyView {
    
    if (_historyView == nil) {
        _historyView = [[QQSearchHistoryView alloc] initWithFrame:CGRectMake(0, [UIDevice isIPoneX] ? 88 : 64, BBSCREENWIDTH, BBSCREENHEIGHT - ([UIDevice isIPoneX] ? 88 : 64))];
        _historyView.marksArray = self.resultDict[@"hot"];
        WS(weakSelf)
        _historyView.hideKeyboards = ^{
            [weakSelf.searchField resignFirstResponder];
        };
        _historyView.clickHotBtn = ^(NSDictionary *dict) {
            weakSelf.searchVC.dict = dict;
            [weakSelf showSearchView];
        };
        _historyView.selectHistorySearch = ^(NSString *history) {
            weakSelf.searchField.text = history;
            weakSelf.searchVC.searchStr = history;
            [weakSelf showSearchView];
        };
    }
    return _historyView;
}

- (QQSearchController *)searchVC {
    
    if (_searchVC == nil) {
        WS(weakSelf)
        _searchVC = [QQSearchController searchController:^{
            weakSelf.topView = weakSelf.historyView;
            weakSelf.historyView.hidden = NO;
            [weakSelf.searchField becomeFirstResponder];
        }];
        _searchVC.view.frame = self.view.bounds;
        _searchVC.engineURL = self.resultDict[@"search_url"];
    }
    return _searchVC;
}

- (QQCategoryController *)categoryVC {
    
    if (_categoryVC == nil) {
        _categoryVC = [[QQCategoryController alloc] init];
        _categoryVC.view.frame = self.view.bounds;
    }
    return _categoryVC;
}

- (UIView *)specialTopView {
    
    return self.moreCategoryView;
}

- (BOOL)canMark {
    
    if (self.topView == self.searchVC.view || self.topView == self.categoryVC.view) {
        return YES;
    } else {
        return NO;
    }
}

@end
