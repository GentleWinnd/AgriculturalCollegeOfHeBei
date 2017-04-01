//
//  HOMEHeader.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/6.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

/*
 ====================================================================================================//拓展功能
 ====================================================================================================//拓展功能
 *
 *
 *
 *
 *
 ====================================================================================================//拓展功能
 ====================================================================================================//拓展功能
 */

/*
 ====================================================================================================//三方库功能
 ====================================================================================================//三方库功能
 *全局右滑返回====FDFullscreenPopGesture====忽略
 *全局智能键盘====IQKeyBoardManager====忽略
 *网络请求单例====AFNetworking====HOMEBaseViewController中有_AFNManager网络请求单例
 *透明指示层HUD===MBProgressHUD====HOMEBaseViewController中有_HUD指示器对象
 *上下刷新加载====MJRefresh====footer/header添加
 * ==== ====
 ====================================================================================================//三方库功能
 ====================================================================================================//三方库功能
 */

#ifndef HomeToolsTesr_HOMEHeader_h
#define HomeToolsTesr_HOMEHeader_h

/*
 ====================================================================================================//打印相关
 */
#ifdef DEBUG
//#define NSLog(...) NSLog(__VA_ARGS__)
#define NSLog(FORMAT, ...) fprintf(stdout,"[😁类名：%s : 第%d行NSLog😁] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#define debugMethod() NSLog(@"%s", __func__)


#else

#define NSLog(...)
#define debugMethod()
#endif
/*
 ====================================================================================================//获取屏幕尺寸
 */
        /** 屏幕的高度 */
#define HEIGHT [UIScreen mainScreen].bounds.size.height
        /** 屏幕的宽度 */
#define WIDTH [UIScreen mainScreen].bounds.size.width

#define WIDTH6Scale(x) ((x) * WIDTH / 375.0f)

#define HEIGHT6Scale(y) ((y) * HEIGHT / 667.0f)

/*
 ====================================================================================================//颜色相关1
 */
        /**  */
#define COLOR_BLACK [UIColor blackColor]
        /**  */
#define COLOR_DARKGRAY [UIColor darkGrayColor]
        /**  */
#define COLOR_LIGHTGRAY [UIColor lightGrayColor]
        /**  */
#define COLOR_WHITE [UIColor whiteColor]
        /**  */
#define COLOR_GRAY [UIColor grayColor]
        /**  */
#define COLOR_RED [UIColor redColor]
        /**  */
#define COLOR_GREEN [UIColor greenColor]
        /**  */
#define COLOR_BLUE [UIColor blueColor]
        /**  */
#define COLOR_CYAN [UIColor cyanColor]
        /**  */
#define COLOR_YELLOW [UIColor yellowColor]
        /**  */
#define COLOR_MAGENTA [UIColor magentaColor]
        /**  */
#define COLOR_ORANGE [UIColor orangeColor]
        /**  */
#define COLOR_PURPLE [UIColor purpleColor]
        /**  */
#define COLOR_BROWN [UIColor brownColor]
        /**  */
#define COLOR_CLEAR [UIColor clearColor]
/*
 ====================================================================================================//颜色相关2
 */
        /**  */
#define BLACK_COLOR [UIColor blackColor]
        /**  */
#define DARKGRAY_COLOR [UIColor darkGrayColor]
        /**  */
#define LIGHTGRAY_COLOR [UIColor lightGrayColor]
        /**  */
#define WHITE_COLOR [UIColor whiteColor]
        /**  */
#define GRAY_COLOR [UIColor grayColor]
        /**  */
#define RED_COLOR [UIColor redColor]
        /**  */
#define GREEN_COLOR [UIColor greenColor]
        /**  */
#define BLUE_COLOR [UIColor blueColor]
        /**  */
#define CYAN_COLOR [UIColor cyanColor]
        /**  */
#define YELLOW_COLOR [UIColor yellowColor]
        /**  */
#define MAGENTA_COLOR [UIColor magentaColor]
        /**  */
#define ORANGE_COLOR [UIColor orangeColor]
        /**  */
#define PURPLE_COLOR [UIColor purpleColor]
        /**  */
#define BROWN_COLOR [UIColor brownColor]
        /**  */
#define CLEAR_COLOR [UIColor clearColor]
/*
 ====================================================================================================//颜色相关3
 */
#define RGB_COLOR(R,G,B)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]
#define RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define COLOR_RGB(R,G,B)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]
#define COLOR_RGBA(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
        /** 16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000 */
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1.0]

/*
 ====================================================================================================//弹出框
 */
#define ALERT_HOME(title,msg)\
{\
UIAlertView *HomeAlert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]; \
[HomeAlert show]; \
}

/*
 ====================================================================================================//单项目
 */

#define USERINFO @"userInfo"
#define DOWNLOAD @"download"
#define LOGIN_LOG @"loginlog"

//shareSDK
#define SHARESDK_KEY @"987430a69c1b"
#define WEIXIN_SHARE_KEY @"wx90ee314b3e776ee3"
#define WEIXIN_SHARE_SECRET @"4a07df7927336f843af66ddee2653d3d"
#define SINA_SHARE_KEY @"266725429"
#define SINA_SHARE_SECRET @"64b44f271961dc2437bf065302262178"

//======================//======================//======================//======================//======================
#if 0
#define URL_BASE @"http://laonianlmsapi.lndx.edu.cn/"
//课程接口
#define URL_COURSE @"http://laonianlmsapi.lndx.edu.cn/Course/NewestCoursesInRootCategorys?Count=%d"
//轮播图接口
#define URL_CYCIMAGES @"http://appcloudapi.lndx.edu.cn/Snippet/DataInfos?Key=TutorialCarousel&Count=5&Size=200*200"
//获取所有分类列表
#define URL_CATEGORY_ALL @"Category/List"
//分页获取课程数据
#define URL_COURSE_LIST @"http://laonianlmsapi.lndx.edu.cn/Course/Paging?CategoryId=%@&CourseType=MVC&Sort=CreateDate&SortType=DESC&Page=%zd&PageSize=10"
//获取（微课）课程详细信息
#define URL_VIDEO_DETAIL @"http://laonianlmsapi.lndx.edu.cn/Course/MVCDetails?Id=%@&ImageWidth=129"
//用户登录
#define URL_USER_LOGIN @"http://laonianlmsapi.lndx.edu.cn/User/Login"
//用户注册
#define URL_USER_REGISTER @"http://laonianlmsapi.lndx.edu.cn/User/Register"
//获取用户信息
#define URL_USER_INFO @"http://laonianlmsapi.lndx.edu.cn/User/Info?AccessToken=%@"
//用户验证
#define URL_TOKEN_CHECK @"http://laonianlmsapi.lndx.edu.cn/User/Validation?AccessToken=%@"
//使用现有AccessToken换取新的AccessToken，这个操作将刷新AccessToken有效期
#define URL_TOKEN_REFRESH @"http://laonianlmsapi.lndx.edu.cn/User/RefreshToken?AccessToken=%@"
//上传头像
#define URL_UPLOAD_ICON @"http://laonianlmsapi.lndx.edu.cn/User/UploadPic"
//课程搜索
#define URL_COURSE_SEARCH @"http://laonianlmsapi.lndx.edu.cn/Course/Search?Keyword=%@&CourseType=MVC&Sort=%@&SortType=DESC&Page=%zd&PageSize=10"
//课程是否被收藏
#define URL_CHECK_FAVORITE @"http://laonianlmsapi.lndx.edu.cn/Course/FavoriteCheck?AccessToken=%@&Id=%@"
//设置收藏状态，如果课程已收藏则将课程移除收藏夹
#define URL_SET_FAVORITE @"http://laonianlmsapi.lndx.edu.cn/Course/SetFavorite?AccessToken=%@&Id=%@"
//幕课是否报名
#define URL_APPLY @"http://laonianlmsapi.lndx.edu.cn/Course/IsSign?AccessToken=%@&Id=%@"
//幕课详情
#define URL_MUKE_DETAIL @"http://laonianlmsapi.lndx.edu.cn/Course/Details?Id=%@&ImageWidth=300"
//幕课报名接口post
#define URL_SIGN_IN @"http://laonianlmsapi.lndx.edu.cn/Batch/SignUp"

#define URL_FAVORITE_LIST @"http://laonianlmsapi.lndx.edu.cn/Course/FavoritePaging?AccessToken=%@&Page=%zd&PageSize=10"

#else 
//======================//======================//======================//======================//======================
#define URL_BASE @"http://templmsapi.bjdxxxw.cn/"
//课程接口
#define URL_COURSE @"http://templmsapi.bjdxxxw.cn/Course/NewestMVCCourses?Count=%d"//√
//轮播图接口
#define URL_CYCIMAGES @"http://templmsapi.bjdxxxw.cn/Snippet/Slider?Key=TutorialCarousel&Count=5"//√
//获取所有分类列表
#define URL_CATEGORY_ALL @"Category/All"
//分页获取课程数据
#define URL_COURSE_LIST @"http://templmsapi.bjdxxxw.cn/Course/Paging?CategoryId=%@&CourseType=%@&Sort=CreateDate&SortType=DESC&PageNum=%zd&PageSize=50"
//获取（微课）课程详细信息
#define URL_VIDEO_DETAIL @"http://templmsapi.bjdxxxw.cn/Course/MVCDetails?Id=%@&ImageWidth=129"
//用户登录
#define URL_USER_LOGIN @""
//用户注册
#define URL_USER_REGISTER @""
//获取用户信息
#define URL_USER_INFO @"http://templmsapi.bjdxxxw.cn/Passport/GetStudentInfo?AccessToken=%@"
//设置用户信息
#define URL_SET_USERINFO @"http://templmsapi.bjdxxxw.cn/Passport/SetStudentInfo"
//用户验证
#define URL_TOKEN_CHECK @"http://templmsapi.bjdxxxw.cn/User/Validation?AccessToken=%@"
//使用现有AccessToken换取新的AccessToken，这个操作将刷新AccessToken有效期
#define URL_TOKEN_REFRESH @"http://templmsapi.bjdxxxw.cn/User/RefreshToken?AccessToken=%@"
//上传头像
#define URL_UPLOAD_ICON @"http://templmsapi.bjdxxxw.cn/Passport/SetAvatar"
//课程搜索
#define URL_COURSE_SEARCH @"http://templmsapi.bjdxxxw.cn/Course/Search?Keyword=%@&CourseType=&Sort=%@&SortType=DESC&Page=%zd&PageSize=10"
//课程是否被收藏
#define URL_CHECK_FAVORITE @"http://templmsapi.bjdxxxw.cn/Favorites/Check?AccessToken=%@&CourseId=%@"
//设置收藏状态，如果课程已收藏则将课程移除收藏夹
#define URL_SET_FAVORITE @"http://templmsapi.bjdxxxw.cn/Favorites/Set"
//幕课是否报名
#define URL_APPLY @"http://templmsapi.bjdxxxw.cn/Course/IsSign?AccessToken=%@&Id=%@"
//幕课详情
//MOOCCourseDetails
#define URL_MUKE_DETAIL @"http://templmsapi.bjdxxxw.cn/Course/MOOCCourseDetails?Id=%@&ImageWidth=300"
//获取课程版本详细信息
#define URL_MUKE_MOVIEURL @"http://templmsapi.bjdxxxw.cn/Course/MOOCCourseVersionDetails/?CourseVersionId=%@"
//幕课报名接口post
#define URL_SIGN_IN @"http://templmsapi.bjdxxxw.cn/Batch/SignUp"
//分页返回收藏课程
#define URL_FAVORITE_LIST @"http://templmsapi.bjdxxxw.cn/Favorites/Paging?AccessToken=%@&Page=%zd&PageSize=10"
//我的课程（慕课）
#define URL_USERMUKE_LIST @"http://templmsapi.bjdxxxw.cn/Course/MyCourse?AccessToken=%@&Sort=CreateDate&SortType=DESC"
//获取反馈信息接口
#define URL_GET_RECUPERATION @"http://appcloudapi.lndx.edu.cn/Feedback/Current?DependentId=tutorial&DependentType=app"
//提交反馈
#define URL_SUBMIT_OPINION @"http://appcloudapi.lndx.edu.cn/Feedback/Submit"
//检测是否可以下载
#define URL_CHECK_DL_STATE @"http://templmsapi.bjdxxxw.cn/Tool/MobileCanDownloadVideo"

#endif
//======================//======================//======================//======================//======================

#define BLUE_BASE_CITS [UIColor colorWithRed:30/255.0 green:158/255.0 blue:230/255.0 alpha:1.0]
#define VIEWCONTROLLER_NAME [[NSString stringWithUTF8String:__FILE__]lastPathComponent]

#endif
