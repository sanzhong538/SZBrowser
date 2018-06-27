//
//  QQSearchHistoryView.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/23.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQSearchHistoryView.h"
#import "BBConst.h"

@interface QQSearchHistoryView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *historyArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerMarkView;

@end

@implementation QQSearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    self.historyArray = NSUserDefaults_get(@"history_search");
    if (self.historyArray.count > 0) {
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BBSCREENWIDTH, 40)];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [deleteBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = deleteBtn;
    }
    [self.tableView reloadData];
}

- (void)clickDeleteBtn {
    
    NSUserDefaults_move(@"history_search");
    self.historyArray = [NSArray array];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
}

- (void)addHeaderView {
    
    int count = (int)self.marksArray.count;
    if (count == 0) return;
    CGFloat headerViewHeight = 40 * (count+2)/3 + 20;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BBSCREENWIDTH, headerViewHeight)];
    CGFloat width = (BBSCREENWIDTH-2)/3.0;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%3*(width+1), i/3*40+10, width, 40)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:self.marksArray[i][@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(i%3*(width+1)+width, i/3*(40+10)+10, 1, 20)];
        v.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        [headerView addSubview:v];
    }
    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData];
}

- (void)clickBtn:(UIButton *)btn {
    
    if (self.hideKeyboards) {
        self.hideKeyboards();
    }
    if (self.clickHotBtn) {
        self.clickHotBtn(self.marksArray[btn.tag]);
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellIdentifier"];
    }
    cell.imageView.image = [UIImage imageNamed:@"search"];
    cell.textLabel.text = self.historyArray[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.historyArray];
        [arrayM removeObjectAtIndex:indexPath.row];
        self.historyArray = arrayM.copy;
        if (self.historyArray.count == 0) {
            self.tableView.tableFooterView = [[UIView alloc] init];
        }
        [self.tableView reloadData];
        NSUserDefaults_set(self.historyArray, @"history_search");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectHistorySearch) {
        self.selectHistorySearch(self.historyArray[indexPath.row]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.hideKeyboards) {
        self.hideKeyboards();
    }
}

#pragma mark - set/get

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)setMarksArray:(NSArray *)marksArray {
    
    _marksArray = marksArray;
    [self addHeaderView];
}

@end
