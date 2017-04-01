//
//  SigninViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/9.
//  Copyright © 2016年 YH. All rights reserved.
//
#define L_LONGITUDE @"longitude"
#define L_LATITUUDE @"latitude"
#define L_ADRESS_DETAIL @"adressDetail"

#import "SigninViewController.h"

#import "UIViewController+LewPopupViewController.h"
#import "ClassScheduleViewController.h"
#import "LewPopupViewController.h"
#import "SignedViewController.h"

#import "SignedStuView.h"
#import "SystemLocalityManager.h"
#import "SetNavigationItem.h"
#import "MZTimerLabel.h"
#import "SignedSuccessView.h"
#import "NSString+Date.h" 
#import "NSDate+Formatter.h"
#import "RecentCourseManager.h"
#import "UserData.h"

@interface SigninViewController ()
{
    SystemLocalityManager *localManager;
    NSMutableDictionary *courseInfo;
    NSMutableDictionary *activityInfo;
    NSMutableDictionary *locationInfo;
    NSMutableDictionary *signedStuInfo;
    NSString *startDate;
    NSString *endDate;
    BOOL inSignRange;
    int signedNum;
    BOOL isRefreshedLoacal;
    NSDate *startCountDate;
    NSDate *timeToCountOff;
}
@property (strong, nonatomic) IBOutlet UILabel *signTime;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UILabel *signedStuNum;

@property (strong, nonatomic) IBOutlet UILabel *className;
@property (strong, nonatomic) IBOutlet UIButton *selectClassBtn;

@property (strong, nonatomic) IBOutlet UILabel *hourO;
@property (strong, nonatomic) IBOutlet UILabel *hourT;
@property (strong, nonatomic) IBOutlet UILabel *minuteO;
@property (strong, nonatomic) IBOutlet UILabel *minuteT;
@property (strong, nonatomic) IBOutlet UILabel *secondO;
@property (strong, nonatomic) IBOutlet UILabel *secondT;

@property (strong, nonatomic) IBOutlet UIButton *signBtn;
@property (strong, nonatomic) IBOutlet UILabel *signAlert;

@property (strong, nonatomic) IBOutlet UIButton *localBtn;
@property (strong, nonatomic) IBOutlet UILabel *localLabel;

@property (strong, nonatomic) IBOutlet UIView *signedStuCountView;
@property (strong, nonatomic) IBOutlet UIView *signedStusInfoView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentClassTop;

@property (strong, nonatomic) IBOutlet UIView *startSignView;
@property (strong, nonatomic) IBOutlet UIView *subLineView;

@property (strong, nonatomic) MZTimerLabel *mzLabel;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation SigninViewController

#pragma mark - setNav 

- (void)setNavigationBar {
    NSString *title;
    NSString *subTitle;
    if (self.userRole == UserRoleTeacher) {
        title = @"签到";
        subTitle = @"";
    } else {
        title = @"签到";
        subTitle = @"";
    }
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:title subTitle:subTitle];
    
    if (self.presentingViewController) {
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [cancelBtn addTarget:self action:@selector(cancelBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 38);
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }

}

#pragma mark - initLoacationManager

- (void)initSystemLoacal {
    localManager = [[SystemLocalityManager alloc] init];
    [localManager initializeLocationService];
    [localManager startUpdatingLocation];

    @WeakObj(locationInfo);
    @WeakObj(self);
    @WeakObj(localManager);
    localManager.localityAddress = ^(NSString *addressInfo) {
       // NSLog(@"---=%@",addressInfo);
       // selfWeak.localLabel.text = addressInfo;
        [locationInfoWeak setValue:addressInfo forKey:L_ADRESS_DETAIL];
    };
    localManager.localityTude = ^(NSString *longitude, NSString *latitude){
        [localManagerWeak stopUpdatingLocation];

        [locationInfoWeak setValue:longitude forKey:L_LONGITUDE];
        [locationInfoWeak setValue:latitude forKey:L_LATITUUDE];
        if (isRefreshedLoacal == NO) {
            [selfWeak verifyTheSignedLocation];
            
        }
    };
   // NSLog(@"---==%@",localManager.location);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setNavigationBar];
    
    [self initData];
    [self signedStuView];
    if (self.userRole == UserRoleTeacher) {
//        [self customSignedStusView];
        _signedStuCountView.hidden = NO;
        _subLineView.hidden = YES;


    } else {
        _subLineView.hidden = YES;
        _signedStuCountView.hidden = YES;
    }
}

#pragma mark - initData

- (void)initData {
    signedNum = 0;
    inSignRange = NO;
    isRefreshedLoacal = NO;
    locationInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    courseInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    activityInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    signedStuInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [self initSystemLoacal];
    [self getRecentCourseInfo];
    [self refreshedStudentsSignedState];
}

#pragma mark - get recent course info

- (void)getRecentCourseInfo {
    
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        [courseInfo setValuesForKeysWithDictionary:coursesInfo];
        [self getRecentActvity];

    } failure:^(NSString *failMessage) {
        [Progress progressShowcontent:failMessage];
    }];
}

#pragma mark - get recent activity

- (void)getRecentActvity {
    
    [RecentCourseManager getRecentSignedActivityInView:self.view success:^(NSDictionary *activitysInfo) {
        
        [activityInfo setValuesForKeysWithDictionary:[NSDictionary safeDictionary:activitysInfo]];
        [self analysisCourseData];
        
    } failure:^(NSString *failMessage) {
        
        [Progress progressShowcontent:failMessage];
    }];

}

#pragma mark - verifyTheSignedLoacation

- (void)verifyTheSignedLocation {
    isRefreshedLoacal = YES;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary: @{@"GPSCoordinate":[NSString stringWithFormat:@"%@%@%@",locationInfo[L_LATITUUDE],@"%2C",locationInfo[L_LONGITUDE]]}];
    [parameter setValue:courseInfo[@"Dependent"][@"DependentId"] forKey:@"OfflineCourseId"];
    [parameter setValue:activityInfo[@"Activity"][@"Id"] forKey:@"CheckInActivityId"];
    
    [NetServiceAPI getLocationInRangeWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            self.localLabel.text = @"您不在签到范围内";
            [Progress progressShowcontent:responseObject[@"Message"]];
            inSignRange = NO;
        } else {
            inSignRange = YES;
            self.localLabel.text = @"您已在考勤范围内";
            [Progress progressShowcontent:@"您已在签到范围内"];
        }
//        NSLog(@"-----===%@",responseObject);
    } failure:^(NSError *error) {
        inSignRange = NO;
        self.localLabel.text = @"位置获取中...";

        [KTMErrorHint showNetError:error inView:self.view];
        // NSLog(@"%@",error.description);
    }];
}

#pragma mark - post signed info 

- (void)signedTheCourse {
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"CheckInActivityId":activityInfo[@"Id"],
                                @"GPSCoordinate":[NSString stringWithFormat:@"%@,%@",locationInfo[L_LATITUUDE],locationInfo[L_LONGITUDE]],@"Location":locationInfo[L_ADRESS_DETAIL]};
    
    [NetServiceAPI postSignedInfoWithParameters:parameter success:^(id responseObject) {
        
        if ([responseObject[@"State"] integerValue] == 0) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            SignedSuccessView *hintView = [SignedSuccessView initLayoutView];
            [self hiddenSelfView];
            [self.view addSubview:hintView];
            signedNum ++;
            if ([self.deleage respondsToSelector:@selector(signResult:)]) {
                [self.deleage signResult:YES];
            }
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        // NSLog(@"%@",error.description);
    }];
}

#pragma mark - cancel
- (void)cancelBarButtonItemPressed:(UIButton*)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - get students signed info

- (void)refreshedStudentsSignedState {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction {
    if (activityInfo[@"Activity"][@"Id"]) {
        [self getSignedStudentsInfo];
    }
}

#pragma mark - get sigend students info

- (void)getSignedStudentsInfo {
    NSDictionary *parameter = @{@"CheckInActivityId": activityInfo[@"Activity"][@"Id"]};

    [NetServiceAPI getSignedStudentsInfoWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            self.signedStuNum.text = [NSString stringWithFormat:@"%tu/%tu",[NSArray safeArray:responseObject[@"StudentCheckInStatDetail"][@"CheckInStudents"]].count,[NSArray safeArray:responseObject[@"StudentCheckInStatDetail"][@"ShouldStudents"]].count];
            [signedStuInfo removeAllObjects];
            [signedStuInfo setValuesForKeysWithDictionary:responseObject[@"StudentCheckInStatDetail"]];
            SignedStuView *signView = (SignedStuView *)[self.view viewWithTag:111];
            signView.signedStuInfo = signedStuInfo;
            [signView.stuCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        // NSLog(@"%@",error.description);

    }];
}

#pragma mark - analysisData

- (void)analysisCourseData {
    startDate = [NSString stringFromTDateString:activityInfo[@"StartDate"]];
    endDate = [NSString stringFromTDateString:activityInfo[@"EndDate"] ];
    int SInterval = [NSDate getTimeIntervalSecondsWithDate:startDate];
    int EInterval = [NSDate getTimeIntervalSecondsWithDate:endDate];
    if (SInterval<0) {//开始签到时间已过
        if (EInterval >0) {
            self.signTime.text = endDate;
            self.signLabel.text = @"关闭签到时间";
            [self setTimeStamp:EInterval isInSignTime:YES];
        }
    } else {
        self.signTime.text = startDate;
        self.signLabel.text = @"开启签到时间";
        [self setTimeStamp:SInterval isInSignTime:NO];
    }
    [self resetShowView];
}

#pragma mark - use get data desplay view

- (void)resetShowView {
    self.signedStuNum.text = [NSString stringWithFormat:@"%d/0",signedNum];
    self.className.text = courseInfo[@"Dependent"][@"DependentName"];

}

- (void)signedStuView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSignedStuView)];
    [self.signedStuCountView addGestureRecognizer:tap];
}

#pragma mark - gotoSignedStuView

- (void)gotoSignedStuView {
    SignedViewController *signedView = [[SignedViewController alloc] init];
    signedView.signedStuInfo = signedStuInfo;
    [self.navigationController pushViewController:signedView animated:YES];
}

#pragma mark - customSubSignedStuView

- (void)customSignedStusView {
    SignedStuView *signedStus = [SignedStuView initViewLayout];
    signedStus.frame = _signedStusInfoView.bounds;
    signedStus.tag = 111;
    [_signedStusInfoView addSubview: signedStus];
}

- (IBAction)selecteClassBtnAction:(UIButton *)sender {
    
    if (sender.tag == 1) {//重新定位
        isRefreshedLoacal = NO;
        [localManager startUpdatingLocation];
    } else if (sender.tag == 2) {//重新选课
        ClassScheduleViewController *scheduleView = [[ClassScheduleViewController alloc] init];
        scheduleView.theSelectedClass = ^(NSDictionary *courseDic) {
            _className.text = courseDic[@"Name"];
            [courseInfo setValuesForKeysWithDictionary:courseDic];
            [RecentCourseManager saveRecentCourse:courseDic];
            [self getRecentActvity];

        };
        
        [self.navigationController pushViewController:scheduleView animated:YES];
    
    } else {//签到
        
//        CGRect frame = self.view.bounds;
//        frame.size.width = self.view.frame.size.width-80;
//        frame.size.height = self.view.frame.size.height- 80;
//        frame.origin.y = 40;
//        SignedStuView *signStuView = [[NSBundle mainBundle] loadNibNamed:@"SignedStuView" owner:self options:nil].lastObject;
//        signStuView.frame = frame;
//        
//        [self lew_presentPopupView:signStuView animation:[LewPopupViewAnimationFade new] dismissed:^{
//            NSLog(@"动画结束");
//        }];
        if (inSignRange) {
            [self signedTheCourse];
        } else {
            [Progress progressShowcontent:@"未在签到范围内，无法签到哦！" currView:self.view];
        }
    }
}

#pragma mark 
- (void)hiddenSelfView {
    self.signBtn.backgroundColor = MaintextColor_LightBlack;
    self.signBtn.enabled = NO;
    self.signAlert.text = @"签到成功";

}

#pragma mark - addTimeobsrever

- (void)addTimeObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChange:) name:@"surplusTime" object:nil];

}

- (void)shouldChange:(NSNotification *)notice {
    NSString *time = [notice.userInfo allValues].lastObject;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        self.hourO.text = [time substringWithRange:NSMakeRange(0, 1)];
        self.hourT.text = [time substringWithRange:NSMakeRange(1, 1)];
        self.minuteO.text = [time substringWithRange:NSMakeRange(3, 1)];
        self.minuteT.text = [time substringWithRange:NSMakeRange(4, 1)];
        self.secondO.text = [time substringWithRange:NSMakeRange(6, 1)];
        self.secondT.text = [time substringWithRange:NSMakeRange(7, 1)];

    });

}
- (void)changingShowTime:(NSString *)time {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        self.hourO.text = [time substringWithRange:NSMakeRange(0, 1)];
        self.hourT.text = [time substringWithRange:NSMakeRange(1, 1)];
        self.minuteO.text = [time substringWithRange:NSMakeRange(3, 1)];
        self.minuteT.text = [time substringWithRange:NSMakeRange(4, 1)];
        self.secondO.text = [time substringWithRange:NSMakeRange(6, 1)];
        self.secondT.text = [time substringWithRange:NSMakeRange(7, 1)];
    });
}

#pragma mark - 添加定时器

- (void)setTimeStamp:(CGFloat)timeStamp isInSignTime:(BOOL) inTime{
//    self.hourO.layer.cornerRadius = 3;
//    if (_mzLabel == nil) {
//        _mzLabel =[[MZTimerLabel alloc] initWithLabel:nil andTimerType:MZTimerLabelTypeTimer];
//    }
//   
//    [_mzLabel setCountDownTime:timeStamp];
//    @WeakObj(_mzLabel);
//    @WeakObj(self);
    [self setCurrentViewStateIsInTime:inTime];
//    [_mzLabel startWithEndingBlock:^(NSTimeInterval countTime) {
//        [selfWeak setCurrentViewStateIsInTime:!inTime];
//        [_mzLabelWeak setCountDownTime:3600];
//        [_mzLabelWeak reset];
//        [_mzLabelWeak start];
//        
//    }];
//    [self addTimeObserver];
    [self start:timeStamp];
}

- (void)setCurrentViewStateIsInTime:(BOOL)inTime {
    self.startSignView.hidden = inTime;
    self.currentClassTop.constant = inTime?0:35;
    self.signBtn.backgroundColor = inTime?MainThemeColor_Blue:RulesLineColor_LightGray;
    self.signBtn.selected = inTime;
    self.signAlert.text = @"点击按钮，进行签到";
    self.signBtn.enabled = inTime;
}

/******************time*********************/
#pragma mark - Timer Control Method
- (void)start:(NSInteger)time{
    timeToCountOff = [[NSDate dateWithTimeIntervalSince1970:0] dateByAddingTimeInterval:time];
    
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        if(startCountDate == nil){
            startCountDate = [NSDate date];
        }
        
        [_timer fire];
    } else {
        [_timer setFireDate:[NSDate distantPast]];
    
    }
}


#pragma mark - Private method

-(void)updateLabel:(NSTimer*)timer{
    
    NSTimeInterval timeDiff = [[[NSDate alloc] init] timeIntervalSinceDate:startCountDate];
    if (timeDiff == 0) {//到签到时间
        
        [self setCurrentViewStateIsInTime:YES];
//        [timer invalidate];
        [timer setFireDate:[NSDate distantFuture]];
        return;
    }
    
    NSDate *timeToShow = [NSDate date];
    
    //timer now
    timeToShow = [timeToCountOff dateByAddingTimeInterval:(timeDiff*-1)];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *strDate = [dateFormatter stringFromDate:timeToShow];
    [self changingShowTime:strDate];
}


- (void)dealloc {
    [_timer invalidate];
    _timer = nil;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
