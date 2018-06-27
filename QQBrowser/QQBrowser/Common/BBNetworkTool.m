//
//  BBNetworkTool.m
//  DianDian
//
//  Created by 吴三忠 on 2017/3/2.
//  Copyright © 2017年 吴三忠. All rights reserved.
//

#import "BBNetworkTool.h"
#import "NSString+MD5.h"

@interface BBNetworkTool ()

@end

@implementation BBNetworkTool

+ (instancetype)sharedNetWorkTool {
    
    static BBNetworkTool    *instance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        instance.requestSerializer.timeoutInterval = 30;
    });
    return instance;
}

- (void)judgeNetworking {
    
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        BBLog(@"%zd", status);
        if (status != AFNetworkReachabilityStatusReachableViaWiFi) {
            weakSelf.canUseNetwork = NO;
        }
        else {
            weakSelf.canUseNetwork = YES;
        }
    }];
}


/**
 *  GET
 */
- (void)getWithURLStr:(NSString *)string parameters:(NSDictionary *)params model:(NSObject *)object showHUD:(BOOL)show success:(void(^)(id result, id originaldata))success failure: (failure)failure {
    
    if (show) {
        [BBProgressHUD showWithStatus:@"加载中..."];
    }
    NSDictionary *dict = [self getTokenAndTime:params];
    [self GET:BBBaseURLStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject[@"error"] == nil) {
            
            if (show) {
                [BBProgressHUD dismiss];
            }
            if (object == nil ) {
                success(responseObject, responseObject);
            }
            else{
                id result = [[object class] mj_objectWithKeyValues:responseObject];
                success(result, responseObject);
            }
            BBLog(@"%@", responseObject);
        }
        else {
            failure(responseObject[@"error"]);
            [BBProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) failure(error.localizedDescription);
        [BBProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}


/**
 *  POST
 */
- (void)postWithURLStr:(NSString *)string parameters:(NSDictionary *)params model:(NSObject *)object showHUD:(BOOL)show success:(void(^)(id result, id originaldata))success failure: (failure)failure {
    
    if (show) {
        [BBProgressHUD showWithStatus:@"加载中..."];
    }
    NSDictionary *dict = [self getTokenAndTime:params];
    [self POST:BBBaseURLStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject[@"error"] == nil) {
            
            if (show) {
                [BBProgressHUD dismiss];
            }
            if (object == nil ) {
                success(responseObject, responseObject);
            }
            else{
                id result = [[object class] mj_objectWithKeyValues:responseObject];
                success(result, responseObject);
            }
            BBLog(@"%@", responseObject);
        }
        else {
            failure(responseObject[@"error"]);
            [BBProgressHUD showErrorWithStatus:responseObject[@"error"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) failure(error.localizedDescription);
        [BBProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

#pragma mark - token

- (NSDictionary *)getTokenAndTime:(NSDictionary *)dict {
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:dict];
//    dictM[@"os"] = @"2";
//    dictM[@"limit"] = @"20";
//    if ([dict[@"a"] isEqualToString:@"start"]) {
//        double time = [[NSDate date] timeIntervalSince1970];
//        dictM[@"time"] = [NSString stringWithFormat:@"%.0f", time];
//        dictM[@"token"] = [NSString stringWithFormat:@"%.0f%@", time, BBAppKey].md5.md5;
//    }
//    else {
//        NSString *t = NSUserDefaults_get(@"time");
//        dictM[@"time"] = t;
//        dictM[@"token"] = t.md5.md5;
//    }
//    double time = [[NSDate date] timeIntervalSince1970];
//    dictM[@"time"] = [NSString stringWithFormat:@"%.0f", time];
//    dictM[@"token"] = [NSString stringWithFormat:@"%.0f%@", time, BBAppKey].md5.md5;
    dictM[@"version"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    dictM[@"bundle"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return dictM.copy;
}

@end
