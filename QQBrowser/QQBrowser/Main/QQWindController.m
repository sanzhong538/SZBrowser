//
//  QQWindController.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQWindController.h"
#import "QQNavigationController.h"
#import "QQPagesController.h"
#import "UIImage+Extension.h"

@interface QQWindController ()

@property (nonatomic, strong) NSMutableArray *snipImageInfo;
@property (nonatomic, weak) QQNavigationController *currentChildController;

@end

@implementation QQWindController

+ (instancetype)windViewController {
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"windControllerIdentifier"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    [self addChildVC];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeChild:) name:@"removeChildNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChild:) name:@"showChildNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addChildVC) name:@"addChildNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPagesVC:) name:@"showMutilwindNotification" object:nil];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.currentChildController.view.frame = self.view.bounds;
}

- (void)removeChild:(NSNotification *)n {
    
    NSDictionary *dict = n.userInfo;
    [self removeChildView:[dict[@"index"] integerValue] delete:[dict[@"delete"] boolValue]];
}

- (void)showChild:(NSNotification *)n {
    
    NSDictionary *dict = n.userInfo;
    [self removeChildView:[dict[@"index"] integerValue] delete:[dict[@"delete"] boolValue]];
}

- (void)addChildVC {
    
    QQNavigationController *navVC = [QQNavigationController navigationController];
    navVC.index = self.childViewControllers.count;
    self.currentChildController = navVC;
}

- (void)removeChildView:(NSInteger)index delete:(BOOL)delete {
    
    if (self.childViewControllers.count > index) {
        if (delete) {
            UIViewController *childVC = self.childViewControllers[index];
            [childVC removeFromParentViewController];
            [self.snipImageInfo removeObjectAtIndex:index];
            if (self.childViewControllers.count == 0) {
                
            } else {
                self.currentChildController = self.childViewControllers.lastObject;
            }
            
        } else {
            NSInteger curIndex = [self.childViewControllers indexOfObject:self.currentChildController];
            if (curIndex != index) {
                QQNavigationController *childVC = self.childViewControllers[index];
                self.currentChildController = childVC;
            }
        }
        self.currentChildController.index = self.childViewControllers.count-1;
    }
}

- (void)showPagesVC:(NSNotification *)n {
    NSDictionary *dict = n.userInfo;
    [self.snipImageInfo replaceObjectAtIndex:[dict[@"index"] integerValue] withObject:dict];
    QQPagesController *pageVC = [QQPagesController pagesController];
    pageVC.dataSource = self.snipImageInfo;
    [self presentViewController:pageVC animated:NO completion:nil];
}

- (NSMutableArray *)snipImageInfo {
    
    if (_snipImageInfo == nil) {
        _snipImageInfo = [NSMutableArray array];
    }
    return _snipImageInfo;
}

- (void)setCurrentChildController:(QQNavigationController *)currentChildController {
    
    if (_currentChildController && _currentChildController != currentChildController) {
        [_currentChildController.view removeFromSuperview];
    }
    _currentChildController = currentChildController;
    if (_currentChildController.parentViewController) {
        [self.snipImageInfo removeObjectAtIndex:[self.childViewControllers indexOfObject:_currentChildController]];
        [_currentChildController removeFromParentViewController];
    }
    [self addChildViewController:_currentChildController];
    [self.snipImageInfo addObject:[NSNull null]];
    _currentChildController.view.frame = self.view.bounds;
    [self.view addSubview:_currentChildController.view];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
