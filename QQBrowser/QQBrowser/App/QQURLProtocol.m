//
//  QQURLProtocol.m
//  QQBrowser
//
//  Created by INCO on 2018/6/25.
//  Copyright © 2018年 SZ. All rights reserved.
//

#import "QQURLProtocol.h"
#import "BBNetworkTool.h"
#import "BBConst.h"

NSString *const HttpProtocolKey = @"http";
NSString *const HttpsProtocolKey = @"https";
static NSString *kURLProtocolHandledKey = @"URLProtocolHandledKey";

@interface QQURLProtocol()<NSURLSessionDelegate>

@property (atomic,strong,readwrite) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation QQURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{

    NSString *scheme = [[request URL] scheme];
    // 判断是否需要进入自定义加载器
    if ([scheme caseInsensitiveCompare:HttpProtocolKey] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:HttpsProtocolKey] == NSOrderedSame)
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    // 执行自定义操作，例如添加统一的请求头等
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return mutableReqeust;
}

// 判重
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    // 标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:kURLProtocolHandledKey inRequest:mutableReqeust];
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:self.queue];
    
    NSString *urlExtensionStr = [mutableReqeust.URL.absoluteString pathExtension];
    NSNumber *num = NSUserDefaults_get(@"withoutPicture");
    NSArray *types = @[@"bmp",@"jpg",@"png",@"tiff",@"gif",@"pcx",@"tga",@"exif",@"fpx",@"svg",@"psd",@"cdr",@"pcd",@"dxf",@"ufo",@"eps",@"ai",@"raw",@"WMF",@"webp", @"jpeg"];
    if ([num intValue] == 1) {
        if (![BBNetworkTool sharedNetWorkTool].canUseNetwork && [types containsObject:urlExtensionStr]) {
            mutableReqeust = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@""]];
        }
    } else if ([num intValue] == 2) {
        if ([types containsObject:urlExtensionStr]) {
            mutableReqeust = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@""]];
        }
    }
    self.task = [self.session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
}

- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - Getter
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

@end

@implementation QQURLProtocol(NSURLSessionDelegate)

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:kURLProtocolHandledKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}


@end
