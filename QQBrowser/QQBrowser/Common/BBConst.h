//
//  BBConst.h
//  DianDian
//
//  Created by 吴三忠 on 2017/3/2.
//  Copyright © 2017年 吴三忠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SZFrame.h"

#ifdef DEBUG
#define BBLog(fmt, ...) {NSLog((@"%s [LINE %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define BBLog(fmt, ...) nil
#endif

#define BBRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define BBARGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define BBRandomColor YKRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define BBRandomAColor(a) YKARGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), a)

#define BBColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define Primary_Color BBColorFromRGB(0x9ecc70)

#define BBNoteCenter [NSNotificationCenter defaultCenter]
#define BBSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define BBSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

#define NSUserDefaults_get(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define NSUserDefaults_move(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define NSUserDefaults_set(value,key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]

#define FIT_320_SCREEN(w) w / 320.0f * BBSCREENWIDTH
#define FIT_480_SCREEN(h) h / 480.0f * BBSCREENHEIGHT

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;


UIKIT_EXTERN NSString * const UMKey;
UIKIT_EXTERN NSString * const BBAppKey;
UIKIT_EXTERN NSString * const BBBaseURLStr;

