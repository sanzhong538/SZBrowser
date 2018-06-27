//
//  QQPagesController.m
//  QQBrowser
//
//  Created by INCO on 2018/6/22.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQPagesController.h"
#import "QQCollectionCell.h"
#import "HJCarouselViewLayout.h"
#import "BBConst.h"

@interface QQPagesController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet HJCarouselViewLayout *carouselLayout;

@end

static NSString * const reuseIdentifier = @"multiwindowCellIdentifier";

@implementation QQPagesController


+ (instancetype)pagesController {
    
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"pagesControllerIdentifier"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carouselLayout.itemSize = CGSizeMake(BBSCREENWIDTH-40, self.collectionView.height-100);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - action

- (IBAction)clickAddBtn:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addChildNotification" object:nil];
    [self clickCancelBtn:nil];
}

- (IBAction)clickCancelBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Private

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QQCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dict = self.dataSource[self.dataSource.count-indexPath.item-1];
    cell.index = self.dataSource.count-indexPath.item-1;
    WS(weakSelf)
    cell.clickDeleteButton = ^(NSInteger index){
        if (weakSelf.dataSource.count == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addChildNotification" object:nil];
            [weakSelf clickCancelBtn:nil];
        } else {
            NSMutableArray *temp = weakSelf.dataSource.mutableCopy;
            [temp removeObjectAtIndex:index];
            weakSelf.dataSource = temp.copy;
            [weakSelf.collectionView reloadData];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeChildNotification" object:nil userInfo:@{@"index":@(index), @"delete":@(1)}];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showChildNotification" object:nil userInfo:@{@"index":@(self.dataSource.count-indexPath.item-1), @"delete":@(0)}];
    [self clickCancelBtn:nil];
}

@end
