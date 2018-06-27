//
//  QQCollectionCell.m
//  QQBrowser
//
//  Created by INCO on 2018/6/26.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQCollectionCell.h"

@interface QQCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation QQCollectionCell

- (IBAction)clickDeleteBtn:(UIButton *)sender {

    if (self.clickDeleteButton) {
        self.clickDeleteButton(self.index);
    }
}

- (void)setDict:(NSDictionary *)dict {
    
    _dict = dict;
    self.titleLbl.text = dict[@"title"];
    self.imgView.image = dict[@"image"];
}

@end
