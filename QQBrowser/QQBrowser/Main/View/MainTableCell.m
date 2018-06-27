//
//  MainTableCell.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/20.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "MainTableCell.h"
#import "BBConst.h"
#import "MainCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface MainTableCell ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MainTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCollectionCellIdentifier" forIndexPath:indexPath];
    cell.titleLbl.text = self.dataArray[indexPath.item][@"title"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item][@"image"]] placeholderImage:nil];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat WH;
    if (BBSCREENWIDTH < 375) {
        WH = (BBSCREENWIDTH-4*10-10*2)/5.0;
    } else {
        WH = (BBSCREENWIDTH-5*10-10*2)/6.0;
    }
    return CGSizeMake(WH, WH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickItemBack) {
        self.clickItemBack(self.dataArray[indexPath.item][@"url"]);
    }
}


@end
