//
//  QQMenuView.h
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickItemButton)(NSInteger tag);

@interface QQMenuView : UIView

@property (nonatomic, assign) BOOL canMark;

+ (instancetype)showAnimated:(BOOL)animated back:(clickItemButton)clickItemButton;

+ (instancetype)showColorMenuAnimated:(BOOL)animated back:(clickItemButton)clickItemButton;

+ (instancetype)showUnloadPictureAnimated:(BOOL)animated back:(clickItemButton)clickItemButton;

@end
