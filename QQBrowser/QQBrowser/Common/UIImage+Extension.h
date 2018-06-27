//
//  UIImage+Extension.h
//  BH
//
//  Created by 吴三忠 on 2017/6/14.
//  Copyright © 2017年 吴三忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageByCaptureScreen;

+ (UIImage *)imageByView:(UIView *)view;

+ (UIImage *)imageByView:(UIView *)view withFrame:(CGRect)rect;

+ (UIImage *)imageCut:(UIImage *)image withRect:(CGRect)rect;

@end
