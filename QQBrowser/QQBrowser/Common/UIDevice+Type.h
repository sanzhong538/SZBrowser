//
//  UIDevice+Type.h
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DeviceType) {
    
    Unknown = 0,
    Simulator,
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
};

@interface UIDevice (Type)

+ (DeviceType)deviceType;
+ (BOOL)isIPoneX;

@end
