//
//  QQPagesController.h
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseViewController.h"

@interface QQPagesController : QQBaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

+ (instancetype)pagesController;

@end
