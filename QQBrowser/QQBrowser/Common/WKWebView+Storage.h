//
//  WKWebView+Storage.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/24.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Storage)
//type： 1 其他站点  2 详情页 3 搜索页
- (void)storageHistoryWithType:(NSString *)type;
- (void)storageBookmarkWithType:(NSString *)type;

@end
