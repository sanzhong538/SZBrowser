//
//  QQHistoryController.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/24.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQHistoryController.h"
#import "QQHistoryCell.h"
#import "BBConst.h"

@interface QQHistoryController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *keysArray;
@property (nonatomic, strong) NSArray *historyArray;
@property (nonatomic, strong) NSArray *bookmarkArray;
@property (nonatomic, copy) selectBack selectBack;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QQHistoryController

+ (instancetype)historyControllerBack:(selectBack)selectBack {
    
    QQHistoryController *historyVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"historyControllerIdentifier"];
    historyVC.selectBack = selectBack;
    return historyVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getData {
    
    NSDictionary *dict = NSUserDefaults_get(@"browseHistory");
    self.keysArray = [dict allKeys];
    WS(weakSelf)
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.keysArray.count];
    __block NSInteger  index = 0;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        tempArray[weakSelf.keysArray.count-1-index] = obj;
        index++;
    }];
    self.historyArray = tempArray.copy;
    self.bookmarkArray = NSUserDefaults_get(@"bookmark");
    self.segmentedControl.selectedSegmentIndex = 1;
    [self.tableView reloadData];
}

#pragma mark - action

- (IBAction)clickSegmentedControl:(UISegmentedControl *)sender {
    
    [self.tableView reloadData];
}

- (IBAction)clickClearBtn:(UIButton *)sender {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        NSUserDefaults_move(@"bookmark");
        self.bookmarkArray = [NSArray array];
    } else {
        NSUserDefaults_move(@"browseHistory");
        self.historyArray = [NSArray array];
        self.keysArray = [NSArray array];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.segmentedControl.selectedSegmentIndex == 0 ? 1 : self.historyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.segmentedControl.selectedSegmentIndex == 0 ? self.bookmarkArray.count : [self.historyArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QQHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyMarkCellIdentifier" forIndexPath:indexPath];
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        cell.titleLbl.text = self.bookmarkArray[indexPath.row][@"title"];
    } else {
        NSDictionary *dict = self.historyArray[indexPath.section][indexPath.row];
        cell.titleLbl.text = dict[@"title"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return 0;
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BBSCREENWIDTH, 30)];
    v.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, BBSCREENWIDTH-30, 30)];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.text = self.keysArray[section];
    [v addSubview:lbl];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.navigationController popViewControllerAnimated:NO];
    if (self.selectBack) {
        self.selectBack(self.segmentedControl.selectedSegmentIndex == 0 ? self.bookmarkArray[indexPath.row] : self.historyArray[indexPath.section][indexPath.row]);
    }
}

@end
