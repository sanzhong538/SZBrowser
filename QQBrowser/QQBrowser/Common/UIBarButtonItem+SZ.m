//
//  UIBarButtonItem+SZ.m
//  项目
//
//  Created by WUSANZHONG on 15/8/5.
//  Copyright (c) 2015年 WUSANZHONG. All rights reserved.
//

#import "UIBarButtonItem+SZ.h"

@implementation UIBarButtonItem (SZ)

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title norImage:(NSString *)norImage heightImage:(NSString *)heightImage target:(id)target action:(SEL)action{
    
    UIButton *btn = [[UIButton alloc] init];
    
    //设置普通状态的图片
    if (norImage != nil && ![norImage  isEqualToString: @""]) {
        
        [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    }
    
    //设置高亮状态的图片
    if (heightImage != nil && ![heightImage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:heightImage] forState:UIControlStateHighlighted];
    }
    
    //设置按钮的title
    if (title != nil && ![title isEqualToString:@""]) {
        
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    
    //自动填充
    [btn sizeToFit];
    
    //添加点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
