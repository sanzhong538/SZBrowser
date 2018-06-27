//
//  QQHistoryController.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/24.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseViewController.h"

typedef void(^selectBack)(NSDictionary *dict);

@interface QQHistoryController : QQBaseViewController

+ (instancetype)historyControllerBack:(selectBack)selectBack;

@end
