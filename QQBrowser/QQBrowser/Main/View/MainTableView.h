//
//  MainTableView.h
//  QQBrowser
//
//  Created by INCO on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableView : UITableView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL canSlip;
@property (nonatomic, assign) BOOL stopSubViewSlip;

@end
