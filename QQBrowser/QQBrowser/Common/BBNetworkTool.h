//
//  BBNetworkTool.h
//  DianDian
//
//  Created by 吴三忠 on 2017/3/2.
//  Copyright © 2017年 吴三忠. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "BBProgressHUD.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "BBConst.h"

typedef void (^failure)(NSString *error) ;

@interface BBNetworkTool : AFHTTPSessionManager

@property (nonatomic, assign) BOOL canUseNetwork;


+ (instancetype)sharedNetWorkTool;

/**
 *  GET
 */
- (void)getWithURLStr:(NSString *)string parameters:(NSDictionary *)params model:(Class)class showHUD:(BOOL)show success:(void(^)(id result, id originaldata))success failure: (failure)failure;

/**
 *  POST
 */
- (void)postWithURLStr:(NSString *)string parameters:(NSDictionary *)params model:(Class)class showHUD:(BOOL)show success:(void(^)(id result, id originaldata))success failure: (failure)failure;


- (void)judgeNetworking;


@end
