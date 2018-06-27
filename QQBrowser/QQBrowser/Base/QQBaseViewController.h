//
//  QQBaseViewController.h
//  QQBrowser
//
//  Created by INCO on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BBConst.h"

@interface QQBaseViewController : UIViewController<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end
