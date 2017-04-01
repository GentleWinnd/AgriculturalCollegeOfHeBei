//
//  CalenderView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//


#import "CalenderView.h"
#import "DrawCircleView.h"
#import "NSDate+Formatter.h"


@interface CalenderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *dayModelArray;
    
@property (strong, nonatomic) NSDate *tempDate;


@property (strong, nonatomic) IBOutlet UILabel *currentDate;
@property (strong, nonatomic) IBOutlet UIButton *previoucsMonth;
@property (strong, nonatomic) IBOutlet UIButton *nextMonth;

@property (strong, nonatomic) IBOutlet UIView *weekView;

@property (strong, nonatomic) IBOutlet UICollectionView *dayCollectionView;

@property (strong, nonatomic) IBOutlet UILabel *signedDays;
@property (strong, nonatomic) IBOutlet UILabel *leaveDays;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation CalenderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tempDate = [NSDate date];
    self.currentDate.text = self.tempDate.yyyyMMByLineWithDate;
    [self initDayCollectionView];
    [self getDataDayModel:self.tempDate];

}

- (void)initData {

    
    
}


#pragma mark - 初始化collectionView

- (void)initDayCollectionView {
    NSInteger width = WIDTH6Scale(50);
    NSInteger height = WIDTH6Scale(50);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _dayCollectionView.collectionViewLayout = flowLayout;
    _dayCollectionView.delegate = self;
    _dayCollectionView.dataSource = self;
    _dayCollectionView.backgroundColor = MainBackgroudColor_GrayAndWhite;
    
    [_dayCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    cell.dayLabel.textColor = MainTextColor_DarkBlack;
    
    MonthModel * mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        
        cell.monthModel = mon;
        cell.indexPath = indexPath;
        if (mon.isSelectedDay) {
            _selectedIndexPath = indexPath;
        }

    } else {
        cell.dayLabel.text = @"";
        cell.circleView.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id mon = self.dayModelArray[indexPath.row];
    CalendarCell *cell = (CalendarCell *)[collectionView cellForItemAtIndexPath:_selectedIndexPath];
    cell.circleView.hidden = NO;
    
    if ([mon isKindOfClass:[MonthModel class]]) {
        self.currentDate.text = [(MonthModel *)mon dateValue].yyyyMMddByLineWithDate;
        
    }
}

- (IBAction)previousMonth:(UIButton *)sender {
    
    self.tempDate = [self getLastMonth:self.tempDate];
    self.currentDate.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    
    NSDate *lastDate = [self getLastMonth:self.tempDate];
    [sender setTitle:lastDate.mmChineseWithDate forState:UIControlStateNormal];
    
}
- (IBAction)nextMonth:(UIButton *)sender {
    self.tempDate = [self getNextMonth:self.tempDate];
    self.currentDate.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
    
    NSDate *nextDate = [self getNextMonth:self.tempDate];
    [sender setTitle:nextDate.mmChineseWithDate forState:UIControlStateNormal];
}

//- (NSString *)jointShowDate:(NSString *)date {
//    NSString *showStr = date;
//    return [NSString stringWithFormat:@"%@"];
//}

- (void)getDataDayModel:(NSDate *)date {
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.dayCollectionView reloadData];
}


#pragma mark -Private

- (NSUInteger)numberOfDaysInMonth:(NSDate *)date {
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
}

- (NSDate *)firstDateOfMonth:(NSDate *)date {
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date {
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastMonth:(NSDate *)date {
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date {
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day {
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}

@end

/***********************CalendarCell***********************/


@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:dayLabel];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.dayLabel = dayLabel;

    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel {
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    
    if (self.dayLabel.text.length>0) {
        DrawCircleView *circleview = [[DrawCircleView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        circleview.backgroundColor = [UIColor clearColor];
        if (self.indexPath.row%6) {
            if (monthModel.dayValue == 12 || monthModel.dayValue == 10) {
                circleview.halfCircle = YES;
            }
        } else {
            circleview.grayCircle= YES;
            
        }
        self.circleView = circleview;
        
        [self.contentView addSubview:circleview];
    }
   

    [self.contentView bringSubviewToFront:self.dayLabel];

    if (monthModel.isSelectedDay) {

    }
}
@end

/***********************MonthModel***********************/

@implementation MonthModel


@end
