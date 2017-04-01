//
//  VideoLoadManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "VideoLoadManager.h"
#import "AFURLSessionManager.h"
#import "CacheVideoData.h"
#import "SourseDataCache.h"

@interface VideoLoadManager()
{
    NSMutableDictionary *setionManager;
}
@end
static VideoLoadManager *_videoLoadManager;

@implementation VideoLoadManager

+ (instancetype)shareVideoManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _videoLoadManager = [[VideoLoadManager alloc]init];
    });
    return _videoLoadManager;
}


- (instancetype)init {

    self = [super init];
    if (self) {
        [self monitorNetWorkReachablity];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startDownload:) name:@"downloadStart" object:nil];
        setionManager = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}


- (void)monitorNetWorkReachablity {
    
    //网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //status:
        //AFNetworkReachabilityStatusUnknown          = -1,  未知
        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
//        NSLog(@"%d", status);
    }];
    
    //准备从远程下载文件. -> 请点击下面开始按钮启动下载任务
}

/**
 * 下载文件
 */
#pragma mark - 下载相关
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag withInfo:(NSDictionary *)info andCoverUrl:(NSString *)cover andSubId:(NSString *)subId andSubTitle:(NSString *)subTitle {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4", aSavePath, aFileName];
    NSLog(@"%@", fileName);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        NSMutableArray *arr = [[user objectForKey:DOWNLOAD] mutableCopy];
        for (NSInteger i=0; i<arr.count; i++) {
            NSMutableDictionary *dic = [arr[i] mutableCopy];
            if ([dic[@"Id"] isEqualToString:aFileName]) {
                [dic setObject:aUrl forKey:@"aUrl"];
                [dic setObject:aSavePath forKey:@"aSavePath"];
                [dic setObject:aFileName forKey:@"aFileName"];
                [dic setObject:fileName forKey:@"fileName"];
                [dic setObject:cover forKey:@"Cover"];
                [dic setObject:@"0" forKey:@"downloadFinish"];
                [dic setObject:[NSString stringWithFormat:@"%zd", aTag] forKey:@"tag"];
                [dic setObject:subId forKey:@"subId"];
                [dic setObject:subTitle forKey:@"subTitle"];
                
                if ([[user objectForKey:DOWNLOAD]count] >0) {
                    [arr replaceObjectAtIndex:i withObject:dic];
                    [user setObject:arr forKey:DOWNLOAD];
                    [user synchronize];
                } else {
                    NSArray *arr = [NSArray arrayWithObjects:dic, nil];
                    [user setObject:arr forKey:DOWNLOAD];
                    [user synchronize];
                }
                
                //添加一个暂停的监听
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pauseDownload:) name:[NSString stringWithFormat:@"%@x", aFileName] object:nil];

                
                NSURL *url = [[NSURL alloc] initWithString:aUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                //获取已下载的文件长度
                unsigned long long downloadedBytes = [self fileSizeForPath:aUrl];
                if (downloadedBytes > 0) {
                    NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
                    NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
                    [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
                    request = mutableURLRequest;
                }
                
                //不使用缓存，避免断点续传出现问题
                [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
                
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                
                //AFN3.0+基于封住URLSession的句柄
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                
                NSURLSessionUploadTask *downloadTask = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:fileName] progress:^(NSProgress * _Nonnull uploadProgress) {
                    // @property int64_t totalUnitCount;  需要下载文件的总大小
                    // @property int64_t completedUnitCount; 当前已经下载的大小
                    
                    // 给Progress添加监听 KVO
                    NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    // 回到主队列刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                    });
                    [[NSNotificationCenter defaultCenter]postNotificationName:aFileName object:[NSString stringWithFormat:@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount]];

                } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
                    if (error == nil) {
                        NSMutableDictionary *mutableDic = [dic mutableCopy];
                        [mutableDic setObject:@"1" forKey:@"downloadFinish"];
                        [arr replaceObjectAtIndex:i withObject:mutableDic];
                        [user setObject:arr forKey:DOWNLOAD];
                        [user synchronize];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"haveFinishDownload" object:nil];
                        
                    } else {
                        // [KTMErrorHint showNetError:error inView:nil];
                    }
                }];
                [setionManager setValue:downloadTask forKey:aFileName];
            }
        }
    }else{
        //    持久化存储mhm
        NSMutableDictionary *userDic = [info mutableCopy];
        [userDic setObject:aUrl forKey:@"aUrl"];
        [userDic setObject:aSavePath forKey:@"aSavePath"];
        [userDic setObject:aFileName forKey:@"aFileName"];
        [userDic setObject:fileName forKey:@"fileName"];
        [userDic setObject:cover forKey:@"Cover"];
        [userDic setObject:@"0" forKey:@"downloadFinish"];
        [userDic setObject:[NSString stringWithFormat:@"%zd", aTag] forKey:@"tag"];
        [userDic setObject:subId forKey:@"subId"];
        [userDic setObject:subTitle forKey:@"subTitle"];
        
        if ([[user objectForKey:DOWNLOAD]count] >0) {
            NSMutableArray *arr = [[user objectForKey:DOWNLOAD]mutableCopy];
            [arr addObject:userDic];
            [user setObject:arr forKey:DOWNLOAD];
            [user synchronize];
        } else {
            NSArray *arr = [NSArray arrayWithObjects:userDic, nil];
            [user setObject:arr forKey:DOWNLOAD];
            [user synchronize];
        }
        
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //AFN3.0+基于封住URLSession的句柄
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        //下载Task操作
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            // @property int64_t totalUnitCount;  需要下载文件的总大小
            // @property int64_t completedUnitCount; 当前已经下载的大小
            
            // 给Progress添加监听 KVO
            NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            // 回到主队列刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            });
            [[NSNotificationCenter defaultCenter]postNotificationName:aFileName object:[NSString stringWithFormat:@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount]];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
            return [NSURL fileURLWithPath:fileName];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
            if (error == nil) {
                NSMutableArray *arr = [[user objectForKey:DOWNLOAD]mutableCopy];
                NSInteger index = [arr indexOfObject:userDic];
                [userDic setObject:@"1" forKey:@"downloadFinish"];
                [arr replaceObjectAtIndex:index withObject:userDic];
                [user setObject:arr forKey:DOWNLOAD];
                [user synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"haveFinishDownload" object:nil];
            } else {
                // [KTMErrorHint showNetError:error inView:nil];
            }
            [setionManager setValue:downloadTask forKey:aFileName];
        }];
    }
}

//获取已下载的文件大小
- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}

-(void)pauseDownload:(NSNotification *)noti
{
    NSDictionary *dic = noti.object;
    [(NSURLSessionDownloadTask *)setionManager[dic[@"aFileName"]] suspend];
    NSLog(@"pauseDownload");
}

-(void)startDownload:(NSNotification *)info {
    NSDictionary *dic = info.object;
    if ([[setionManager allKeys] containsObject:dic[@"aFileName"]]) {
        [(NSURLSessionDownloadTask *)setionManager[dic[@"aFileName"]] resume];
    } else {
        NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
        [self downloadFileURL:dic[@"aUrl"] savePath:path fileName:dic[@"Id"] tag:[dic[@"tag"]integerValue] withInfo:dic andCoverUrl:dic[@"Cover"] andSubId:dic[@"subId"] andSubTitle:dic[@"subTitle"]];
    }
}

@end
