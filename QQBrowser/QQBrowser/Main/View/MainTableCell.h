//
//  MainTableCell.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickItemBack)(NSString *urlStr);

@interface MainTableCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) clickItemBack clickItemBack;

@end
