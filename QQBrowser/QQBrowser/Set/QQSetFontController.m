//
//  QQSetFontController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQSetFontController.h"
#import "BBConst.h"

@interface QQSetFontController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentValue;

@end

@implementation QQSetFontController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *num = NSUserDefaults_get(@"webTextFont");
    if (num == nil) {
        self.slider.value = 0.33;
        self.currentValue.text = @"100%";
    } else {
        self.slider.value = ([num intValue]-50)/150.0;
        self.currentValue.text = [NSString stringWithFormat:@"%d%%", [num intValue]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadWebViewNotivication" object:nil];
}

- (IBAction)scrollSlider:(UISlider *)sender {
    
    int value = (int)(sender.value*150);
    self.currentValue.text = [NSString stringWithFormat:@"%d%%", 50+value];
    NSUserDefaults_set(@(50+value), @"webTextFont");
}

@end
