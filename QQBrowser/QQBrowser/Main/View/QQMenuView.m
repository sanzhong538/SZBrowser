//
//  QQMenuView.m
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQMenuView.h"
#import "UIView+SZFrame.h"
#import "BBProgressHUD.h"
#import "MenuButton.h"
#import "BBConst.h"

@interface QQMenuView()

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, copy) clickItemButton clickItemButton;
@property (weak, nonatomic) IBOutlet UIView *itemsView;
@property (weak, nonatomic) IBOutlet MenuButton *markBtn;
@property (weak, nonatomic) IBOutlet MenuButton *noHistoryBtn;
@property (weak, nonatomic) IBOutlet MenuButton *noPictureBtn;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;

@end

@implementation QQMenuView

+ (instancetype)menuView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"QQMenuView" owner:nil options:nil] firstObject];
}

+ (instancetype)colorMenuView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"QQColorMenuView" owner:nil options:nil] firstObject];
}

+ (instancetype)unLoadPicture {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"QQPictureView" owner:nil options:nil] firstObject];
}

+ (instancetype)showUnloadPictureAnimated:(BOOL)animated back:(clickItemButton)clickItemButton{
    
    QQMenuView *menuView = [self showMenuType:3 animated:animated];
    menuView.clickItemButton = clickItemButton;
    return menuView;
}

+ (instancetype)showAnimated:(BOOL)animated back:(clickItemButton)clickItemButton {
    
    QQMenuView *menuView = [self showMenuType:0 animated:animated];
    menuView.clickItemButton = clickItemButton;
    return menuView;
}

+ (instancetype)showColorMenuAnimated:(BOOL)animated back:(clickItemButton)clickItemButton {
    
    QQMenuView *menuView = [self showMenuType:1 animated:animated];
    menuView.clickItemButton = clickItemButton;
    return menuView;
}

+ (instancetype)showMenuType:(int)typeNum animated:(BOOL)animated {
    
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    QQMenuView *menuView = (typeNum == 0 ? [QQMenuView menuView] : (typeNum == 1 ? [QQMenuView colorMenuView] : [QQMenuView unLoadPicture]));
    menuView.frame = keyWindow.bounds;
    [keyWindow addSubview:menuView];
    if (animated) {
        menuView.itemsView.y = keyWindow.height;
        __weak typeof(menuView) weakMenuView = menuView;
        [UIView animateWithDuration:0.25 animations:^{
            weakMenuView.itemsView.y = keyWindow.height - weakMenuView.height + 34;
        }];
    }
    return menuView;
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    NSString *colorStr = NSUserDefaults_get(@"webViewBackgroundColor");
    for (UIView *v in self.colorViews) {
        v.layer.borderWidth = 0;
    }
    if (colorStr) {
        NSInteger index = [self.colors indexOfObject:colorStr];
        UIView *v = self.colorViews[index];
        v.layer.borderColor = [UIColor blueColor].CGColor;
        v.layer.borderWidth = 0.5;
    } else {
        UIView *v = self.colorViews.firstObject;
        v.layer.borderColor = [UIColor blueColor].CGColor;
        v.layer.borderWidth = 0.5;
    }
    NSNumber *num = NSUserDefaults_get(@"withoutHistory");
    [self.noHistoryBtn setTitle:[num boolValue] ? @"退出无痕" : @"无痕浏览" forState:UIControlStateNormal];
    self.noHistoryBtn.selected = [num boolValue];
    NSNumber *num1 = NSUserDefaults_get(@"withoutPicture");
    [self.noPictureBtn setTitle:[num1 boolValue] ? @"有图模式" : @"无图模式" forState:UIControlStateNormal];
    self.noPictureBtn.selected = [num1 boolValue];
}

- (IBAction)clickCancelBtn:(UIButton *)sender {
    
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    WS(weakSelf)
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.itemsView.y = keyWindow.height;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

/*
 * 11-18 添加书签 书签/历史 夜间 刷新 设置 无痕浏览 无图模式 网页护眼色
 * 31-36 默认 粉红 橘黄 草绿 青葱 水蓝
 * 51 数据无图  52 始终无图
 */

- (IBAction)clickBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case 16:
        {
            NSNumber *num = NSUserDefaults_get(@"withoutHistory");
            NSUserDefaults_set(@(![num boolValue]), @"withoutHistory");
            [self clickCancelBtn:nil];
        }
            break;
        case 17:
        {
            NSNumber *num1 = NSUserDefaults_get(@"withoutPicture");
            if ([num1 boolValue]) {
                NSUserDefaults_set(@(0), @"withoutPicture");
                if (self.clickItemButton) {
                    self.clickItemButton(sender.tag);
                }
                [self clickCancelBtn:nil];
            } else {
                [self removeFromSuperview];
                [QQMenuView showUnloadPictureAnimated:YES back:self.clickItemButton];
            }
        }
            break;
        case 18:
            [self removeFromSuperview];
            [QQMenuView showColorMenuAnimated:YES back:self.clickItemButton];
            break;
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        {
            NSUserDefaults_set(self.colors[sender.tag-31], @"webViewBackgroundColor");
            [self clickBtn:nil];
        }
            break;
        case 51:
        {
            NSUserDefaults_set(@(1), @"withoutPicture");
            if (self.clickItemButton) {
                self.clickItemButton(sender.tag);
            }
            [self clickCancelBtn:nil];
        }
            break;
        case 52:
        {
            NSUserDefaults_set(@(2), @"withoutPicture");
            if (self.clickItemButton) {
                self.clickItemButton(sender.tag);
            }
            [self clickCancelBtn:nil];
        }
            break;
        default:
            if (self.clickItemButton) {
                self.clickItemButton(sender.tag);
            }
            [self clickCancelBtn:nil];
            break;
    }
}

- (void)setCanMark:(BOOL)canMark {
    
    _canMark = canMark;
    self.markBtn.enabled = canMark;
}

- (NSArray *)colors {
    
    if (_colors == nil) {
        _colors = @[@"#FFFFFF", @"#E6D3D9", @"#E6D3B1", @"#D7E6B5", @"#BBE6C2", @"#AEE6D1"];
    }
    return _colors;
}

@end
