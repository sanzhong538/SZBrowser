//
//  QQSearchHistoryView.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/23.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hideKeyboards)(void);
typedef void(^clickHotBtn)(NSDictionary *dict);
typedef void(^selectHistorySearch)(NSString *history);

@interface QQSearchHistoryView : UIView

@property (nonatomic, strong) NSArray *marksArray;
@property (nonatomic, copy) hideKeyboards hideKeyboards;
@property (nonatomic, copy) clickHotBtn clickHotBtn;
@property (nonatomic, copy) selectHistorySearch selectHistorySearch;

@end
