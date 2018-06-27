//
//  UIBarButtonItem+SZ.h
//  项目
//
//  Created by WUSANZHONG on 15/8/5.
//  Copyright (c) 2015年 WUSANZHONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SZ)

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title norImage:(NSString *)norImage heightImage:(NSString *)heightImage target:(id)target action:(SEL)action;

@end
