//
//  QQChangeUAController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQChangeUAController.h"
#import "BBConst.h"

@interface QQChangeUAController ()

@property (nonatomic, strong) NSArray *uaArray;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *btns;

@end

@implementation QQChangeUAController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *UAStr = NSUserDefaults_get(@"userAgent");
    if (UAStr == nil) {
        [self.btns.firstObject setHidden:NO];
    } else {
        [self.btns[[self.uaArray indexOfObject:UAStr]] setHidden:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (UIButton *btn in self.btns) {
        btn.hidden = YES;
    }
    [self.btns[indexPath.row] setHidden:NO];
    NSUserDefaults_set(self.uaArray[indexPath.row], @"userAgent");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserAgentNotivication" object:nil];
}

- (NSArray *)uaArray {
    
    if (_uaArray == nil) {
        _uaArray = @[@"Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1",
                     @"Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Mobile Safari/537.36",
                     @"Mozilla/5.0 (iPad; CPU OS 11_0 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) Version/11.0 Mobile/15A5341f Safari/604.1",
                     @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36"];
    }
    return _uaArray;
}


@end
