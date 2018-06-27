//
//  QQRootViewController.h
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQBaseViewController.h"
#import "QQMainViewController.h"

@interface QQRootViewController : QQBaseViewController


@property (nonatomic, strong) QQMainViewController *currentController;

@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@end
