//
//  MenuButton.m
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "MenuButton.h"
#import "UIView+SZFrame.h"

@implementation MenuButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.imageView.frame = CGRectMake((self.width-30)*0.5, self.height*0.2, 30, 30);
    self.titleLabel.frame = CGRectMake(0, self.height*0.7, self.width, self.height*0.2);
}

@end
