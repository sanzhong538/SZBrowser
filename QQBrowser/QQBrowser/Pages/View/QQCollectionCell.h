//
//  QQCollectionCell.h
//  QQBrowser
//
//  Created by INCO on 2018/6/26.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickDeleteButton)(NSInteger index);

@interface QQCollectionCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) clickDeleteButton clickDeleteButton;

@end
