//
//  SystemLocality.m
//  ProfessionalSurveyDamage
//
//  Created by KTM-Mac-003 on 16/5/27.
//  Copyright © 2016年 kaitaiming. All rights reserved.
//

#import "SystemLocalityManager.h"
#import "NSString+Extension.h"

@interface SystemLocalityManager()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;//定义一个全局的定位管理器
}
@end

@implementation SystemLocalityManager

#pragma mark - 初始化定位器
- (void)initializeLocationService {
    // 初始化定位管理器
    locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    locationManager.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    // locationManager.distanceFilter = 1000.0f;
    
    // 设置定位精确度到米
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无如果设为kCLDistanceFilterNone，则每秒更新一次;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    //在ios 8.0下要授权
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.//这句话ios8以上版本使用。
    } else {
        [locationManager requestAlwaysAuthorization];
    }
    [self judgeMapServiceState];
}


#pragma mark - 获取地理位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    self.location = newLocation;
    //将经度显示到label上
    NSString * longitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    NSString * latitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    self.localityTude(longitude, latitude);
    // 获取当前所在的城市名
    [self reverseGeocodeLocation:newLocation];
}

#pragma mark - 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"error:%@",error);
}

#pragma mark - 停止位置更新
- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
}

#pragma mark - 开始位置更新
- (void)startUpdatingLocation {
    [locationManager startUpdatingLocation];
}

#pragma mark - 根据经纬度反地理编码
- (CLPlacemark *)reverseGeocodeLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLPlacemark *placemark;
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            placemark = [array objectAtIndex:0];
            self.placemark = placemark;
            NSString *city = [NSString safeString:_placemark.locality];
            NSString *district = [NSString safeString:_placemark.subLocality];
            NSString *street = [NSString safeString:_placemark.thoroughfare];
            NSString *subStreet = [NSString safeString:_placemark.subThoroughfare];
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = _placemark.administrativeArea;
            }
            //位置信息
            NSString *addressInfo = [NSString stringWithFormat:@"%@ %@ %@ %@",city,district,street,subStreet];
            self.localityAddress(addressInfo);
            //获取位置
            // NSLog(@"city = %@", city);
        } else if (error == nil && [array count] == 0) {
            // NSLog(@"No results were returned.");
        } else if (error != nil) {
            // NSLog(@"An error occurred = %@", error);
        }
    }];
    return placemark;
}

- (void)judgeMapServiceState {

    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {//判断该软件是否开启定位
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                    [self startUpdatingLocation];
                }];
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        UIViewController *VC = [self getCurrentVC];
        if (VC) {
            [VC presentViewController:alert animated:YES completion:nil];
        }
    }else{
        
        NSLog(@"打开");
        
    }

}

- (UIViewController *)getCurrentVC {//获取当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}




@end
