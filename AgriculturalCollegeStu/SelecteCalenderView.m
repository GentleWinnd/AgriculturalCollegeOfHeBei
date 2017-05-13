//
//  SelecteCalenderView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/22.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "SelecteCalenderView.h"
#import "IDJDatePickerView.h"
#import "NSString+Date.h"


@interface SelecteCalenderView()<IDJDatePickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *cancleBtn;
@property (strong, nonatomic) IBOutlet UIView *topTapView;

@property (strong, nonatomic) IBOutlet UIButton *conformBtn;
@property (strong, nonatomic) IBOutlet UIView *calenderView;

@property (strong, nonatomic) NSString *selectedDate;
@end

static NSString *cellIDY= @"CellIDYear";
static NSString *cellIDM = @"CellIDMonth";
static NSString *cellIDD = @"CellIDDay";

@implementation SelecteCalenderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCalenderView];
    [self setTopButton];
    
    _selectedDate = [NSString stringFromDate:[NSDate date]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleSelf:)];
    [self.topTapView addGestureRecognizer:tap];
    
}

- (void)cancleSelf:(UIGestureRecognizer *)tap {
    if (self.currentDate) {
        self.currentDate(_selectedDate);
    }

    [self removeFromSuperview];

}


+ (instancetype)initLayoutview {
    SelecteCalenderView *sel = [[NSBundle mainBundle] loadNibNamed:@"SelecteCalenderView" owner:self options:nil].firstObject;
    sel.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
    return sel;
}

#pragma mark - set top btn 
- (void)setTopButton {

    self.cancleBtn.layer.cornerRadius = 2;
    self.cancleBtn.layer.borderColor = RulesLineColor_LightGray.CGColor;
    self.cancleBtn.layer.borderWidth = 1;
    
    self.conformBtn.layer.cornerRadius = 2;
    self.conformBtn.layer.borderWidth = 1;
    self.conformBtn.layer.borderColor = RulesLineColor_LightGray.CGColor;
}

- (IBAction)topBtnAction:(UIButton *)sender {
    
    if (sender.tag == 1) {//conform
        if (self.currentDate) {
            self.currentDate(_selectedDate);
        }
    }
    [self removeFromSuperview];
}

/****************calender table*****************/

- (void)setCalenderView {
    CGRect frame = CGRectMake(1, 1, WIDTH-26, CGRectGetHeight(self.calenderView.bounds)-2);
    //公历日期选择器
    IDJDatePickerView *djdateGregorianView=[[IDJDatePickerView alloc]initWithFrame:frame type:Gregorian1];
    [self.calenderView addSubview:djdateGregorianView];
    
    djdateGregorianView.delegate=self;

}


//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    if ([cal isMemberOfClass:[IDJCalendar class]]) {
        NSCalendar *calendar =  [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dc = [[NSDateComponents alloc] init];
        [dc setYear: [cal.year integerValue]];
        [dc setMonth: [cal.month integerValue]];
        [dc setDay: [cal.day integerValue]];
        
        NSDate *date = [calendar dateFromComponents:dc];
        _selectedDate = [NSString stringFromDate:date];
//        NSLog(@"%@:era=%@, year=%@, month=%@, day=%@, weekday=%@", cal, cal.era, cal.year, cal.month, cal.day, cal.weekday);
    } else if ([cal isMemberOfClass:[IDJChineseCalendar class]]) {
        IDJChineseCalendar *_cal=(IDJChineseCalendar *)cal;
//        NSLog(@"%@:era=%@, year=%@, month=%@, day=%@, weekday=%@, animal=%@", cal, cal.era, cal.year, cal.month, cal.day, cal.weekday, _cal.animal);
    }
}

- (void)setGetCalender {
    }


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface contentCell()

@end


@implementation contentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
       
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
    
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_dateLabel];
    }
    return _dateLabel;
}

@end



