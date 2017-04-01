//
//  CacheVideoData.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheVideoData : NSObject

/**
 create video file
 */
+ (void)createVideoFile;


/**
 cache video data

 @param filePath sourse URL
 @param videoData video
 @return cached result
 */
+ (BOOL)writeVideoAtFilePath:(NSString *)filePath videoData:(NSData *)videoData;


/**
 get video sourse data

 @param filePath sourse URL
 @return video data
 */
+ (NSData *)getVideoDataAtFilePath:(NSString *)filePath;
@end
