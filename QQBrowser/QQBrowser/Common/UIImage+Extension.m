//
//  UIImage+Extension.m
//  BH
//
//  Created by 吴三忠 on 2017/6/14.
//  Copyright © 2017年 吴三忠. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage*)imageByCaptureScreen {
    
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size,NO,0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    for(UIWindow*window in [[UIApplication sharedApplication] windows])
    {
        if(![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width* [[window layer]anchorPoint].x,
                                  -[window bounds].size.height* [[window layer]anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageByView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageByView:(UIView *)view withFrame:(CGRect)rect {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImg;
}

+ (UIImage *)imageCut:(UIImage *)image withRect:(CGRect)rect {
    
    
//    UIGraphicsBeginImageContext(rect.size);
//    [image drawInRect:rect];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
    
    CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *img = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);
    return img;
    
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    UIGraphicsBeginImageContext(smallRect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallRect, subImageRef);
//    UIImage * img = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    CGImageRelease(subImageRef);
//    return img;
}

@end
