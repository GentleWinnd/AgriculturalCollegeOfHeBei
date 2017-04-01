//
//  SystemLocality.h
//  ProfessionalSurveyDamage
//
//  Created by KTM-Mac-003 on 16/5/27.
//  Copyright © 2016年 kaitaiming. All rights reserved.
//
/**
 * 1.先初始化定位器
 * 2.开始定位
 * 3.获取想要的位置信息
 * 4.用完之后关闭定位器
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface SystemLocalityManager : NSObject

/**
 * 定位的详细地址
 */
@property (nonatomic, strong) void (^localityAddress)(NSString *addressInfo);

/**
 * 定位的经纬坐标
 */
@property (nonatomic, strong) void (^localityTude)(NSString *longitude, NSString *latitude);

/**
 * 定位位置标记
 */
@property (nonatomic, strong) CLPlacemark *placemark;

/**
 * 定位的经纬度
 */
@property (nonatomic, strong) CLLocation *location;


/**
 * 初始化定位器
 */
- (void)initializeLocationService;

/**
 * 反地理编码
 */
- (CLPlacemark*)reverseGeocodeLocation:(CLLocation *)location;

/**
 * 停止位置更新
 */
- (void)stopUpdatingLocation;

/**
 * 开始位置更新
 */
- (void)startUpdatingLocation;



@end
