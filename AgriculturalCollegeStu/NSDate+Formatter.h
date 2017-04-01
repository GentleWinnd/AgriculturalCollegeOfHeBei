//
//  NSDate+Formatter.h
//  SystemXinDai
//
//  Created by LvJianfeng on 16/3/26.
//  Copyright © 2016年 LvJianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TimeInteralM;
@interface NSDate (Formatter)


/**
 get current date

 @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString*)getCMCurrentDate;
//get the time interval
+(TimeInteralM *)getTimeIntervalWithDate:(NSString *)startTime;
//get the time interval seconeds
+(int)getTimeIntervalSecondsWithDate:(NSString *)startTime;

+(NSDate *)yesterday;

+(NSDateFormatter *)formatter;
+(NSDateFormatter *)formatterWithoutTime;
+(NSDateFormatter *)formatterWithoutDate;

-(NSString *)formatWithUTCTimeZone;
-(NSString *)formatWithLocalTimeZone;
-(NSString *)formatWithTimeZoneOffset:(NSTimeInterval)offset;
-(NSString *)formatWithTimeZone:(NSTimeZone *)timezone;

-(NSString *)formatWithUTCTimeZoneWithoutTime;
-(NSString *)formatWithLocalTimeZoneWithoutTime;
-(NSString *)formatWithTimeZoneOffsetWithoutTime:(NSTimeInterval)offset;
-(NSString *)formatWithTimeZoneWithoutTime:(NSTimeZone *)timezone;

-(NSString *)formatWithUTCWithoutDate;
-(NSString *)formatWithLocalTimeWithoutDate;
-(NSString *)formatWithTimeZoneOffsetWithoutDate:(NSTimeInterval)offset;
-(NSString *)formatTimeWithTimeZone:(NSTimeZone *)timezone;


+ (NSString *)currentDateStringWithFormat:(NSString *)format;
+ (NSDate *)dateWithSecondsFromNow:(NSInteger)seconds;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day;
- (NSString *)dateWithFormat:(NSString *)format;

//Other
- (NSString *)mmddByLineWithDate;
- (NSString *)yyyyMMByLineWithDate;
- (NSString *)yyyyMMddByLineWithDate;
- (NSString *)mmddChineseWithDate;
- (NSString *)mmChineseWithDate;
- (NSString *)hhmmssWithDate;

- (NSString *)morningOrAfterWithHH;
@end

@interface TimeInteralM :NSObject

@property (assign, nonatomic) int hour;
@property (assign, nonatomic) int minute;
@property (assign, nonatomic) int second;


@end
