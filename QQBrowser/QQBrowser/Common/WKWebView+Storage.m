//
//  WKWebView+Storage.m
//  QQBrowser
//
//  Created by WUSANZHONG on 2018/6/24.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "WKWebView+Storage.h"
#import "BBConst.h"

@implementation WKWebView (Storage)

- (void)storageHistoryWithType:(NSString *)type {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM月dd日";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDictionary *historyDict = NSUserDefaults_get(@"browseHistory");
    if (historyDict) {
        NSArray *tempArray = historyDict[dateStr];
        if (tempArray) {
            NSMutableArray *arrM = [NSMutableArray arrayWithArray:tempArray];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.title, @"title", self.URL.absoluteString, @"url", type, @"type", nil];
            [arrM insertObject:dict atIndex:0];
            NSMutableDictionary *dictM = historyDict.mutableCopy;
            [dictM setObject:arrM forKey:dateStr];
            NSUserDefaults_set(dictM.copy, @"browseHistory");
            
        } else {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.title, @"title", self.URL.absoluteString, @"url", type, @"type", nil];
            NSArray *array = [NSArray arrayWithObject:dict];
            NSMutableDictionary *dictM = historyDict.mutableCopy;
            [dictM setObject:array forKey:dateStr];
            NSUserDefaults_set(dictM.copy, @"browseHistory");
        }
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.title, @"title", self.URL.absoluteString, @"url", type, @"type", nil];
        NSArray *array = [NSArray arrayWithObject:dict];
        NSDictionary *storageDict = [NSDictionary dictionaryWithObjectsAndKeys:array, dateStr, nil];
        NSUserDefaults_set(storageDict, @"browseHistory");
    }
}

- (void)storageBookmarkWithType:(NSString *)type {
    
    NSArray *bookmarks = NSUserDefaults_get(@"bookmark");
    if (bookmarks) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:bookmarks];
        __block BOOL haveStorage = NO;
        [arrayM enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"url"] isEqualToString:self.URL.absoluteString]) {
                haveStorage = YES;
                [arrayM removeObject:obj];
                [arrayM insertObject:obj atIndex:0];
                *stop = YES;
            }
        }];
        if (!haveStorage) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.title, @"title", self.URL.absoluteString, @"url", type, @"type", nil];
            [arrayM insertObject:dict atIndex:0];
            NSUserDefaults_set(arrayM.copy, @"bookmark");
        }
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.title, @"title", self.URL.absoluteString, @"url", type, @"type", nil];
        NSArray *array = [NSArray arrayWithObject:dict];
        NSUserDefaults_set(array, @"bookmark");
    }
}

@end
