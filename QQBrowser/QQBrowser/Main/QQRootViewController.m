//
//  QQRootViewController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQRootViewController.h"
#import "QQNavigationController.h"
#import "QQHistoryController.h"
#import "WKWebView+Storage.h"
#import "UIImage+Extension.h"
#import "BBProgressHUD.h"
#import "QQURLProtocol.h"
#import "QQMenuView.h"

@interface QQRootViewController ()

@end

@implementation QQRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBottomView:) name:@"addChildViewController" object:nil];
    QQMainViewController *mainVC = [QQMainViewController mainViewController];
    [self addChildViewController:mainVC];
    self.currentController = mainVC;
    mainVC.view.frame = self.rootView.bounds;
    [self.rootView addSubview:mainVC.view];
    NSNumber *num = NSUserDefaults_get(@"withoutPicture");
    if ([num boolValue]) {
        [self registerURLProtocol];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.countLbl.text = [NSString stringWithFormat:@"%ld", self.parentViewController.parentViewController.childViewControllers.count];
}

- (void)changeBottomView:(NSNotification *)notification {
    
    if (notification.userInfo) {
        [self refreshBottomView:notification.userInfo[@"webView"]];
    } else {
        self.previousBtn.enabled = YES;
        self.nextBtn.enabled = NO;
    }
}

- (void)refreshBottomView {
    
    if (self.currentController.topView != self.currentController.view) {
        self.previousBtn.enabled = YES;
    } else {
        self.previousBtn.enabled = NO;
    }
    if (self.currentController.childViewControllers.count > 0&& self.currentController.topView != [(UIViewController *)self.currentController.childViewControllers.firstObject view]) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

- (void)refreshBottomView:(WKWebView *)webView{
    
    if ([webView canGoBack]) {
        self.previousBtn.enabled = YES;
    } else {
        if (self.currentController.topView != self.currentController.view) {
            self.previousBtn.enabled = YES;
        } else {
            self.previousBtn.enabled = NO;
        }
    }
    
    if ([webView canGoForward]) {
        self.nextBtn.enabled = YES;
    } else {
        if (self.currentController.topView != [(UIViewController *)self.currentController.childViewControllers.firstObject view]) {
            self.nextBtn.enabled = YES;
        } else {
            self.nextBtn.enabled = NO;
        }
    }
}

- (void)unregisterURLProtocol {
    
    [NSURLProtocol unregisterClass:[QQURLProtocol class]];
}

- (void)registerURLProtocol {
    
    Class cls = NSClassFromString(@"WKBrowsingContextController");
    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
    if (cls && sel) {
        if ([(id)cls respondsToSelector:sel]) {
            // 注册http协议
            [(id)cls performSelector:sel withObject:HttpProtocolKey];
            // 注册https协议
            [(id)cls performSelector:sel withObject:HttpsProtocolKey];
        }
    }
    [NSURLProtocol registerClass:[QQURLProtocol class]];
}

/*
 * 11-18 添加书签 书签/历史 夜间 刷新 设置 无痕浏览 无图模式 网页护眼色
 * 31-36 默认 粉红 橘黄 草绿 青葱 水蓝
 */
- (void)doMenuClick:(NSInteger)tag {
    
    switch (tag) {
        case 11:
        {
            for (UIView *v in self.currentController.topView.subviews) {
                if ([v isKindOfClass:[WKWebView class]]) {
                    WKWebView *webView = (WKWebView *)v;
                    [webView storageBookmarkWithType:self.currentController.topViewType];
                }
            }
            [BBProgressHUD showSuccessWithStatus:@"添加成功"];
        }
            break;
        case 12:
        {
            WS(weakSelf)
            QQHistoryController *historyVC = [QQHistoryController historyControllerBack:^(NSDictionary *dict) {
                [weakSelf.currentController jumpHistory:dict];
            }];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
        case 13:
            break;
        case 14:
        {
            for (UIView *v in self.currentController.topView.subviews) {
                if ([v isKindOfClass:[WKWebView class]]) {
                    WKWebView *webView = (WKWebView *)v;
                    [webView reload];
                }
            }
        }
            break;
        case 15:
        {
            [self performSegueWithIdentifier:@"settingSegueIdentifier" sender:nil];
        }
            break;
        case 17:
        {
            [self unregisterURLProtocol];
        }
            break;
        case 51:
        {
            [self registerURLProtocol];
        }
            break;
        case 52:
        {
            [self registerURLProtocol];
        }
            break;
        default:
            break;
    }
}

#pragma mark - action

- (IBAction)clickSetBtn:(UIButton *)sender {
    
    if (![self canClick]) return;
    WS(weakSelf)
    QQMenuView *menuView =[QQMenuView showAnimated:YES back:^(NSInteger tag) {
        [weakSelf doMenuClick:tag];
    }];
    menuView.canMark = self.currentController.canMark;
}

- (IBAction)clickPagesBtn:(UIButton *)sender {
    
    if (![self canClick]) return;
    NSString *title = self.currentController.topView == self.currentController.view ? @"主页" : self.currentController.webView.title;
    UIImage *image = [UIImage imageByView:self.currentController.view];
    QQNavigationController *nav = (QQNavigationController *)self.navigationController;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMutilwindNotification" object:nil userInfo:@{@"title":title, @"image":image, @"index":@(nav.index)}];
}

- (IBAction)clickScrollMainTopBtn:(UIButton *)sender {
    
    if (![self canClick]) return;
    if (self.currentController.topView != self.currentController.view) {
        if (self.currentController.specialTopView != self.currentController.topView) {
            [self.currentController.topView removeFromSuperview];
        }
        self.currentController.specialTopView.hidden = YES;
        self.currentController.topView = self.currentController.view;
    }
    [self.currentController reloadData];
    [self refreshBottomView];
}

- (IBAction)clickPreviousBtn:(UIButton *)sender {
    
    if (![self canClick]) return;
    if ([self checkWebView:YES]) {
        return;
    }
    NSInteger index = [self checkIndexOfTopView];
    if (index <= 0) {
        if (self.currentController.specialTopView.hidden) {
            [self.currentController reloadData];
        }
        self.currentController.topView = self.currentController.view;
    } else {
        UIViewController *vc = self.currentController.childViewControllers[index-1];
        [self.currentController.view addSubview:vc.view];
        self.currentController.topView = vc.view;
    }
    [self refreshBottomView];
}

- (IBAction)clickNextBtn:(UIButton *)sender {
    
    if (![self canClick]) return;
    if ([self checkWebView:NO]) {
        return;
    }
    NSInteger index = [self checkIndexOfTopView];
    UIViewController *vc;
    if (index < 0) {
        vc = self.currentController.childViewControllers.firstObject;
    } else {
        vc = self.currentController.childViewControllers[index+1];
    }
    [self.currentController.view addSubview:vc.view];
    self.currentController.topView = vc.view;
    [self refreshBottomView];
}

- (NSInteger)checkIndexOfTopView {
    
    __block NSInteger index = -1;
    WS(weakSelf)
    [self.currentController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.view == weakSelf.currentController.topView) {
            index = idx;
        }
    }];
    for (UIViewController *vc in self.currentController.childViewControllers) {
        [vc.view removeFromSuperview];
    }
    return index;
}

- (BOOL)checkWebView:(BOOL)isback {
    
    for (UIView *v in self.currentController.topView.subviews) {
        if ([v isKindOfClass:[WKWebView class]]) {
            WKWebView *webVeiw = (WKWebView *)v;
            if (isback) {
                if ([webVeiw canGoBack]) {
                    [webVeiw goBack];
                    return YES;
                }
            } else {
                if ([webVeiw canGoForward]) {
                    [webVeiw goForward];
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL)canClick {
    
    if ([self.currentController isKindOfClass:[QQMainViewController class]]) {
        QQMainViewController *mainVC = (QQMainViewController *)self.currentController;
        if ([mainVC.topView isKindOfClass:[NSClassFromString(@"QQSearchHistoryView") class]]) {
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
