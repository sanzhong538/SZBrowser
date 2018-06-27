//
//  QQSearchViewController.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/23.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseViewController.h"

typedef void(^removeFromView)(void);

@interface QQSearchController : QQBaseViewController

@property (nonatomic, copy) NSString *engineURL;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSDictionary *historyDict;

+ (instancetype)searchController:(removeFromView)removeFromView;

@end
