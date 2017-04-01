//
//  CacheVideoData.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#define VIDEOS_FILE @"Videos"

#import "CacheVideoData.h"

@implementation CacheVideoData

+ (void)createVideoFile {
    
    [self creatImageFile:@"Videos"];

}

#pragma creat plist

+ (void)creatImageFile:(NSString *)fileName {
    NSString *documentDirectory = [self getDocumentDirectory];
    NSString *imageFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //determine whether the file has been created
    if ([manager fileExistsAtPath:imageFilePath]) {
        // NSLog(@"have same filer");
    } else {//if no image file is automatically created
        BOOL success = [manager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        //NSLog(@"create new filer %@",success?@"successful":@"failed");
    }
}

#pragma mark - get document directory

+ (NSString *)getDocumentDirectory {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return documentDirectory;
}

#pragma mark - cache video data

+ (BOOL)writeVideoAtFilePath:(NSString *)filePath videoData:(NSData *)videoData {
    
    //获取当前时间作为图片名
    NSString *savePath = [NSString stringWithFormat:@"%@/%@/%@.MP4",[self getDocumentDirectory],VIDEOS_FILE,filePath];
    //将照片写入沙盒
    if ([videoData writeToFile:savePath atomically:YES]) {
        NSLog(@"写入成功");
        return YES;
    };
    return NO;
}

#pragma mark - get cached video

+ (NSData *)getVideoDataAtFilePath:(NSString *)filePath {
    NSData *video;
    NSString *savePath = [NSString stringWithFormat:@"%@/%@/%@.MP4",[self getDocumentDirectory],VIDEOS_FILE,filePath];
//    NSError *error = nil;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *imageNameArray = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:filePath error:&error]];
//
    //将filePath路径下的文件夹里的照片取出
    video= [[NSData alloc] initWithContentsOfFile:savePath];
   
    return video;
}


@end
