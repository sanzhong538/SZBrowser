//
//  QQMainViewController.h
//  QQBrowser
//
//  Created by INCO on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseViewController.h"

@interface QQMainViewController : QQBaseViewController

@property (nonatomic, assign) BOOL canMark;
@property (nonatomic, assign) BOOL withoutSpecialSubView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, copy) NSString *topViewType;

+ (instancetype)mainViewController;

- (void)reloadData;
- (void)jumpHistory:(NSDictionary *)dict;

@end
