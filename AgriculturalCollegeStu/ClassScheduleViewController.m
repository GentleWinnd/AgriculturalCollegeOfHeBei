//
//  ClassScheduleViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//
#define CELL_WIDTH (WIDTH-10)/15
#define NAV_VIEW_TAG 111


#import "ClassScheduleViewController.h"
#import "ClassCollectionViewCell.h"
#import "CDayTableViewCell.h"
#import "NSString+Date.h"
#import "ClassSCHNavView.h"
#import "NSString+Extension.h"
#import "SelecteCalenderView.h"
#import "RecentCourseManager.h"
#import "ClassNumCollectionViewCell.h"

@interface ClassScheduleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    NSMutableArray *classesArray;
    NSMutableArray *dayCourseArray;
    NSDictionary *recentCourseInfo;
    NSArray *classTimeArray;
    NSDate *SCurrentDate;
    NSInteger lastWeekNUM;
    NSInteger weekNUM;
    BOOL showRecentCourse;
    ClassSCHNavView *NAVView;
    
}
@property (strong, nonatomic) IBOutlet UICollectionView *classCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstLabelWidth;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *CDayBtn;
@property (strong, nonatomic) IBOutlet UIView *CDView;
@property (strong, nonatomic) IBOutlet UIButton *CWeekBtn;
@property (strong, nonatomic) IBOutlet UIView *CWView;
@property (strong, nonatomic) IBOutlet UIButton *CRecentBtn;

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UITableView *DayCalenderTab;





@end
static NSString *cellID = @"cellID";
static NSString *cellNumID = @"classNumeCellID";
static NSString *CDCellID = @"CDayCellID";
static NSString *lineViewID = @"lineViewId";
@implementation ClassScheduleViewController

#pragma mark - 设置导航栏

- (void)customNavigationTitle {
    
    NAVView = [[NSBundle mainBundle] loadNibNamed:@"ClassSCHNavView" owner:self options:nil].lastObject;
    NAVView.frame = CGRectMake(0, 0, 300, 38);
    NAVView.tag = NAV_VIEW_TAG;
    @WeakObj(self);
    NAVView.btnSelectd = ^(BOOL isLeft) {
        if (isLeft) {
            if (self.contentScrollView.contentOffset.x > 0) {
                [selfWeak getPreviousDay];
            } else {
                [selfWeak getPreviousWeek];
            }
        } else {
            if (self.contentScrollView.contentOffset.x > 0) {
                [selfWeak getNextDay];
            } else {
                [selfWeak getNextWeek];
            }
        }
    };
    self.navigationItem.titleView = NAVView;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.frame = CGRectMake(0, 0, 28,28);
//    [rightBtn setTitle:@"单日" forState:UIControlStateNormal];
//    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    [rightBtn setImage:[UIImage imageNamed:@"daycelendar"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:MainTextColor_DarkBlack forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)navBtnAction:(UIButton *)sender {
    if (!sender.enabled) {
        return;
    }
    sender.enabled = NO;
    [self pushUpDayCalenderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationTitle];
    [self initData];
    
    self.firstLabelWidth.constant = CELL_WIDTH;
    [self creatCustomCollectioView];
    [self customDayCalenderTab];
    [self setBottomBar];
}

#pragma mark - 初始化数据

- (void)initData {
    classesArray = [NSMutableArray arrayWithCapacity:0];
    dayCourseArray = [NSMutableArray arrayWithCapacity:0];
//    [classesArray addObjectsFromArray:@[@"高等数学（一）",@"大学英语英语下（一）",@"大学物理（大二）",@"离散数学（三）",@"数据统计与应用（一）"]];
    classTimeArray = @[@[@"8:00",@"9:00"],@[@"10:00",@"11:00"],@[@"12:00",@"13:00"],@[@"14:00",@"15:00"],@[@"16:00",@"17:00"],@[@"18:00",@"19:00",@"20:00"],];
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        recentCourseInfo = [NSDictionary dictionaryWithDictionary:coursesInfo];
    } failure:^(NSString *failMessage) {
        
    }];
    SCurrentDate = [NSDate date];
    [self analysisCurrentDate:NO];
    //[self getAllClassCourse];
    [self getClasSchedule];

}

#pragma mark -  get week course

- (void)getClasSchedule {

    NSString *startDay;
    NSString *endday;
    if ([self isCurrentWeek]) {
        startDay = [self getCurrentDateStr:[self getCurrentWeekMonday]];
        endday = [self getCurrentDateStr:[self getCurrentWeekSunday]];

    } else {
        startDay = [self getCurrentDateStr:SCurrentDate];
        endday = [self getCurrentDateStr:[self getTheDateWeekSunDay]];
    }

    NSDictionary *parameter = @{@"StartDate":startDay,
                                @"EndDate":endday};
    [self getCourseWithParameter:parameter isDailyClassSCH:NO];
}


- (void)getCourseWithParameter:(NSDictionary *)parameter isDailyClassSCH:(BOOL)daily {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    
    [NetServiceAPI getClassScheduleWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            if (daily) {
                [dayCourseArray removeAllObjects];
                [dayCourseArray addObjectsFromArray:responseObject[@"Activitys"]];
                [_DayCalenderTab reloadData];
            } else{
                [classesArray removeAllObjects];
                [classesArray addObjectsFromArray:responseObject[@"Activitys"]];
                [_classCollectionView reloadData];
            }
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
            
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - get all class course

- (void)getAllClassCourse {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getAllOfflineCourseWithParameters:nil success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            [classesArray removeAllObjects];
            [classesArray addObjectsFromArray:[NSArray safeArray:responseObject[@"OfflineCourses"]]];
            [_classCollectionView reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

#pragma mark - 创建collectionView

- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.classCollectionView.collectionViewLayout = layOut;
    self.classCollectionView.delegate = self;
    self.classCollectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.classCollectionView.backgroundColor = [UIColor clearColor];
    [self.classCollectionView registerNib:[UINib nibWithNibName:@"ClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.classCollectionView registerNib:[UINib nibWithNibName:@"ClassNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellNumID];
//    [self.classCollectionView registerClass:[lineView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:lineViewID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 48;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
      if (indexPath.row%8 == 0 ) {
          NSInteger courseNum = indexPath.row/8;
          ClassNumCollectionViewCell *NumCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellNumID forIndexPath:indexPath];
          NumCell.numLabelOne.text = [NSString stringWithFormat:@"%tu",courseNum*2+1];
          NumCell.numLabelTwo.text = [NSString stringWithFormat:@"%tu",courseNum*2+2];
          cell = NumCell;

      } else {
          ClassCollectionViewCell *courseCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
          courseCell.line.hidden = YES;
          courseCell.classLabel.hidden = NO;
          courseCell.classLabel.backgroundColor = [UIColor whiteColor];
          
          courseCell.userInteractionEnabled = NO;
          
        BOOL NoWeek = YES;
          
          if (classesArray.count>0 && NoWeek) {
              NSString *name = [self getCourseWithIndexPath:indexPath];
              if (name != nil) {
                  courseCell.classLabel.text = name;
                  courseCell.classLabel.textColor = [UIColor whiteColor];
                  courseCell.classLabel.backgroundColor = [self getColorWithAlpha:1];
                  courseCell.userInteractionEnabled = YES;
                  
              } else {
                  courseCell.classLabel.hidden = YES;
                  courseCell.line.hidden = NO;
              }
          } else {
              courseCell.classLabel.hidden = YES;
              courseCell.line.hidden = NO;
              
          }
          cell = courseCell;
 
      }

    
    return cell;
}

- (NSString *)getCourseWithIndexPath:(NSIndexPath *)indexPtah {
    NSString *classStr;
    int weekN = [self getClassWeekWithIndexPath:indexPtah];
    int classN = indexPtah.row>0?indexPtah.row/8*2+1:0;
    if (weekN && classN) {
        for (NSDictionary *classInfo in classesArray) {
            NSInteger classM = [[[NSString safeString:classInfo[@"LessonTimeRange"]] componentsSeparatedByString:@","].firstObject intValue];
            NSInteger weekM = [classInfo[@"DayOfWeekNum"] intValue];
            weekN = weekN == 7?0:weekN;

            if (classN == classM && weekM == weekN) {
                classStr = classInfo[@"Dependent"][@"DependentName"];
                break;
            }
            
        }
    }
       return classStr;
}

- (int)getClassWeekWithIndexPath:(NSIndexPath *)indexPath {
    int index = (int)indexPath.row;
    int num;

    if (indexPath.row<8) {
        num = index;
    } else {
        int rate = indexPath.row/8;
        num = indexPath.row-8*rate;
    }
    
//    for (int i=1; i<8; i++) {
//        if (index%i==0) {
//            num = i;
//            break;
//        }
//    }
    return num;
}

-(int)getRandomNumber:(int)from to:(int)to {
    
    return (int)(from + (arc4random() % (to - from + 1)));
}


#pragma mark - 获取课表显示的颜色

- (UIColor *)getColorWithAlpha:(NSInteger)number {
    
        CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
        
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
        
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
        
        return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:number];
        
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassCollectionViewCell *cell = (ClassCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *courseName = cell.classLabel.text;
    NSDictionary *courseDic;
    for (NSDictionary *courseInfo in classesArray) {
        if ([courseName isEqualToString:courseInfo[@"Dependent"][@"DependentName"]]) {
            courseDic = courseInfo;
            break;
        }
    }
    if (self.theSelectedClass) {
        self.theSelectedClass(courseDic);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = (WIDTH-10)/15;
    CGSize size;
    if (indexPath.row%8 == 0 ) {
        size = CGSizeMake(cellWidth, cellWidth*5);
    } else {
        size = CGSizeMake(2*cellWidth, 5*cellWidth);
    }
    return size;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}

#pragma mark - get current date

- (NSString *)getCurrentDateStr:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

#pragma mark - get week num

- (void)analysisCurrentDate:(BOOL)changDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth) fromDate:SCurrentDate];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger dayOfWeek = [comps weekday];
    NSInteger weekOfMonth = [comps weekOfMonth];
    weekNUM = [comps weekOfYear];
    if (!changDay) {
        lastWeekNUM = weekNUM;
    }
    if (self.contentScrollView.contentOffset.x>0) {
        NAVView.titleLabel.text = [NSString stringWithFormat:@"%tu月%tu日",month,day];
        NAVView.detailLabel.text = [NSString stringWithFormat:@"%tu年%tu月第%tu周 周%tu",year,month,weekOfMonth,dayOfWeek];
    } else {
        NAVView.titleLabel.text = [NSString stringWithFormat:@"%tu年%tu月第%tu周",year,month,weekOfMonth];
    }
    
   // return [NSString stringWithFormat:@"第%tu周",week];
}

#pragma mark - get currentday of week

- (NSInteger)getCurrentWeekInfo {
    NSCalendar *initCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
//    [initCalendar setFirstWeekday:2];
//    [initCalendar setMinimumDaysInFirstWeek:7];
    
    comps =[initCalendar components:(NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal) fromDate:currentDate];
    
    return [comps weekday];
}

- (NSDate *)getCurrentWeekMonday {
    NSInteger week = [self getCurrentWeekInfo];
    NSCalendar *initCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-(week-2)];
    NSDate *monday = [initCalendar dateByAddingComponents:comps toDate:SCurrentDate options:0];
    
    return monday;
}

- (NSDate *)getCurrentWeekSunday {
    NSInteger week = [self getCurrentWeekInfo];
    NSCalendar *initCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    [comps setDay:7-week+1];
    NSDate *sunday = [initCalendar dateByAddingComponents:comps toDate:SCurrentDate options:0];
    
    return sunday;
}


- (void)getNextWeek {
    weekNUM++;
    SCurrentDate = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:SCurrentDate];
    [self analysisCurrentDate:NO];
    [self getClasSchedule];
    NSLog(@"---=====DATE===%@",SCurrentDate);
}

- (void)getPreviousWeek {
    if (weekNUM>0) {
        weekNUM--;
    }
    SCurrentDate = [NSDate dateWithTimeInterval:-60*60*24*7 sinceDate:SCurrentDate];
    [self analysisCurrentDate:NO];
    [self getClasSchedule];
    NSLog(@"---=====DATE===%@",SCurrentDate);

}

- (void)getNextDay {
    SCurrentDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:SCurrentDate];
    [self analysisCurrentDate:YES];
    [self getClasSchedule];

}

- (void)getPreviousDay {
    SCurrentDate = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:SCurrentDate];
    [self analysisCurrentDate:YES];
    [self getClasSchedule];

}

- (NSDate *)getTheDateWeekSunDay {

    NSCalendar *initCalendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:6];
    NSDate *sunday = [initCalendar dateByAddingComponents:comps toDate:SCurrentDate options:0];
    NSLog(@"---=====DATE===%@",SCurrentDate);

    return sunday;

}

- (BOOL)isCurrentWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *endDate = [NSDate date];
    unsigned int unitFlags2 = NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps2 = [calendar components:unitFlags2 fromDate:SCurrentDate  toDate:endDate  options:0];
    NSInteger months = [comps2 month];
    return months==0?YES:NO;

}

#pragma mark - iscurrent week

- (void)whetherNewWeek {
    if (lastWeekNUM != weekNUM) {
        [self getClasSchedule];
    }
}

/*****************bottom button*******************/
#pragma mark - set bottom bar

- (void)setBottomBar {
    _CDayBtn.layer.cornerRadius = 2;
    _CWeekBtn.layer.cornerRadius = 2;
    _CRecentBtn.layer.cornerRadius = 2;
    
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
  
    if (sender.selected == NO) {
        sender.selected = YES;
        [self setBottomBtnState:sender];
    }
    if (sender.tag<3) {
        [self analysisCurrentDate:sender.tag==1?YES:NO];
       
    }
    NAVView.leftBtn.hidden = sender.tag<3?NO:YES;
    NAVView.rightBtn.hidden = sender.tag<3?NO:YES;
}

- (void)setBottomBtnState:(UIButton *)sender {
    if (sender.tag == 1) {//day calender
        _CWeekBtn.selected = NO;
        _CRecentBtn.selected = NO;
        _contentScrollView.contentOffset = CGPointMake(WIDTH, 0);
        _CDView.backgroundColor = RulesLineColor_DarkGray;
        _CWView.backgroundColor = [UIColor whiteColor];
        _CWeekBtn.backgroundColor = [UIColor whiteColor];
        _CRecentBtn.backgroundColor = [UIColor whiteColor];
        
        
        [self changeNavDetailHidden:NO];
        [self displayDailyCourse];
    } else if (sender.tag == 2) {//week calender
        _CDayBtn.selected = NO;
        _CRecentBtn.selected = NO;
        _contentScrollView.contentOffset = CGPointMake(0, 0);
        _CWView.backgroundColor = RulesLineColor_DarkGray;
        _CDView.backgroundColor = [UIColor whiteColor];
        _CDayBtn.backgroundColor = [UIColor whiteColor];
        _CRecentBtn.backgroundColor = [UIColor whiteColor];
        [self changeNavDetailHidden:YES];
        [self whetherNewWeek];
    
    } else {//recent calender
        _CDayBtn.selected =NO;
        _CWeekBtn.selected = NO;
        _contentScrollView.contentOffset = CGPointMake(WIDTH, 0);
        _CDayBtn.backgroundColor = [UIColor whiteColor];
        _CWeekBtn.backgroundColor = [UIColor whiteColor];
        _CDView.backgroundColor = [UIColor whiteColor];
        _CWView.backgroundColor = [UIColor whiteColor];
        [self changeNavDetailHidden:NO];
        [self displayRecentClass];
    
    }
    sender.backgroundColor = RulesLineColor_DarkGray;

}

#pragma mark - show recent course

- (void)displayRecentClass {
    showRecentCourse = YES;
    if ([recentCourseInfo allKeys].count == 0) {
        [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
            recentCourseInfo = [NSDictionary dictionaryWithDictionary:coursesInfo];
            [_DayCalenderTab reloadData];
        } failure:nil];
    } else {
        [_DayCalenderTab reloadData];
    
    }
}

#pragma mark - show daily course

- (void)displayDailyCourse {
    showRecentCourse = NO;
    if (dayCourseArray.count == 0) {
        NSDictionary *parameter = @{@"StartDate":[NSString stringFromDate:SCurrentDate],
                                    @"EndDate":[NSString stringFromDate:SCurrentDate]};
        [self getCourseWithParameter:parameter isDailyClassSCH:YES];
    } else {
        [_DayCalenderTab reloadData];
    }
}

#pragma mark - set nav hidden

- (void)changeNavDetailHidden:(BOOL)hidden {
    NAVView.datePsace.constant = hidden?0:-8;
    NAVView.detailLabel.hidden = hidden?YES:NO;

}

#pragma mark - pushup selectecalenderView

- (void)pushUpDayCalenderView {
    SelecteCalenderView *calenderView = [SelecteCalenderView initLayoutview];
    calenderView.currentDate = ^(NSString *getDate){
        UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
        UIButton *right = rightItem.customView;
        right.enabled = YES;
        SCurrentDate = [NSString dateFromString:getDate];
        NSDictionary *parameter = @{@"StartDate":getDate,
                                    @"EndDate":getDate};
        [self getCourseWithParameter:parameter isDailyClassSCH:YES];
        [self bottomBtnAction:self.CDayBtn];
      
    };
    [self.view addSubview:calenderView];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 123) {
        NSInteger pageIndex = scrollView.contentOffset.x/WIDTH;
        if (pageIndex>0) {
            [self bottomBtnAction:self.CDayBtn];
        } else {
            [self bottomBtnAction:self.CWeekBtn];
        }
  
    }
}

/*************************day calender***********************/

#pragma mark - day calender

- (void)customDayCalenderTab {
    _DayCalenderTab.delegate = self;
    _DayCalenderTab.dataSource = self;
    [_DayCalenderTab registerNib:[UINib nibWithNibName:@"CDayTableViewCell" bundle:nil] forCellReuseIdentifier:CDCellID];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return classTimeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (HEIGHT - 122)/4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CDCellID forIndexPath:indexPath];
    
    return [self setCell:cell cellForRowAtIndexPath:indexPath];

}

- (CDayTableViewCell *)setCell:(CDayTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    cell.backView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.6];
    cell.VLIne.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    cell.firstTime.text = classTimeArray[indexPath.row][0];
    cell.secondTime.text = classTimeArray[indexPath.row][1];
    if (indexPath.row == classTimeArray.count-1) {
        cell.thridTime.hidden = NO;
        cell.thridTime.text = classTimeArray[indexPath.row][2];
    } else {
        cell.thridTime.hidden = YES;
    }
    //         "LessonTime": "2017-01-14 10:00~12:00",

    NSDictionary *courseDic;
    if (showRecentCourse) {
        
        if ([self whetherTheTimeCourse:cell.firstTime.text courseTime:recentCourseInfo[@"LessonTime"]]) {
            courseDic = [NSDictionary safeDictionary:recentCourseInfo];
        }
    } else {
        for (NSDictionary *dic in dayCourseArray) {
            if ([self whetherTheTimeCourse:cell.firstTime.text courseTime:dic[@"LessonTime"]]) {
                courseDic = [NSDictionary safeDictionary:dic];
                break;
            }
        }
    }
    cell.DTime.text = [courseDic[@"LessonTime"] componentsSeparatedByString:@" "].lastObject;
    cell.courseLabel.text = courseDic[@"Dependent"][@"DependentName"];
    
    return cell;
}

- (BOOL)whetherTheTimeCourse:(NSString *)timeStr courseTime:(NSString *)CTime {
    NSString *CTimeStr = [[CTime componentsSeparatedByString:@" " ].lastObject componentsSeparatedByString:@"~"].firstObject;
    if ([timeStr isEqualToString:CTimeStr]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CDayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *courseDic;
    if (showRecentCourse) {
        
        if ([self whetherTheTimeCourse:cell.firstTime.text courseTime:recentCourseInfo[@"LessonTime"]]) {
            courseDic = [NSDictionary safeDictionary:recentCourseInfo];
        }
    } else {
        for (NSDictionary *dic in dayCourseArray) {
            if ([self whetherTheTimeCourse:cell.firstTime.text courseTime:dic[@"LessonTime"]]) {
                courseDic = [NSDictionary safeDictionary:dic];
                break;
            }
        }
    }
    if (self.theSelectedClass) {
        self.theSelectedClass(courseDic);
        [self.navigationController popViewControllerAnimated:YES];
    }


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


@implementation lineView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RulesLineColor_DarkGray;
    }
    return self;
}

@end
