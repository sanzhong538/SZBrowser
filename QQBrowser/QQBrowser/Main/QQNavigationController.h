//
//  QQNavigationController.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseNavController.h"

@interface QQNavigationController : QQBaseNavController

@property (nonatomic, assign) NSInteger index;

+ (instancetype)navigationController;

@end
