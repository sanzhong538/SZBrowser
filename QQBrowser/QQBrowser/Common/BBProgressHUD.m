//
//  BBProgressHUD.m
//  DianDian
//
//  Created by 吴三忠 on 2017/3/2.
//  Copyright © 2017年 吴三忠. All rights reserved.
//

#import "BBProgressHUD.h"

@implementation BBProgressHUD

+ (void)initialize {
    
    [self setDefaultStyle:SVProgressHUDStyleCustom];
    [self setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [self setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [self setMinimumDismissTimeInterval:1.5];
    [self setBackgroundColor:[UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.8]];
    [self setForegroundColor:[UIColor whiteColor]];
    [self setErrorImage:[UIImage imageNamed:@"error"]];
    [self setSuccessImage:[UIImage imageNamed:@"success"]];
    [self setInfoImage:[UIImage imageNamed:@"info"]];
}

@end
