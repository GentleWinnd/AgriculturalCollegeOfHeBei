//
//  QuestionCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//
#define QUE_TAG 10

#import "QuestionCollectionViewCell.h"
#import "QuestionHeaderView.h"
#import "SelecteAnswerTableViewCell.h"

@interface QuestionCollectionViewCell()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *QuestionInfoTable;

@end
static NSString *CellID = @"answerCellID";

@implementation QuestionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.answerArray = [NSMutableArray arrayWithCapacity:0];

    [self initTableView];
}

- (void)setCourseInfo:(NSDictionary *)courseInfo {
    if (courseInfo) {
        if (_answerArray.count == 0) {
            for (NSDictionary *optionsInfo in courseInfo[@"QuestionOptionList"]) {
                [self.answerArray addObject:@{@"Item":optionsInfo[@"ABCorderNum"]}];
                
            }

        }
        _courseInfo = courseInfo;
    }
    
}

/*
 {
 "Id": "86119095-0d6c-4abf-b160-b0332a7e38b1",
 "Content": "细胞壁的主要作用是",
 "QuestionType": 1,
 "QtypeString": "单选题",
 "QScore": 2.0,
 "LastStudentAnswer": "65413328-62df-43b2-a25e-329596019935",
 "QuestionOptionList": [
 {
 "Id": "fef4381d-8112-4b83-b55f-e829db5ef51a",
 "ABCorderNum": "A",
 "Content": "运输",
 "OrderNum": 1
 },
 {
 "Id": "60d87800-2178-4cf2-8d5d-33f3e9c0af89",
 "ABCorderNum": "B",
 "Content": "分泌",
 "OrderNum": 2
 },
 {
 "Id": "65413328-62df-43b2-a25e-329596019935",
 "ABCorderNum": "C",
 "Content": "保护和支持",
 "OrderNum": 3
 },
 {
 "Id": "83ed6fbe-eecd-46fe-8dd3-619bdd8bebde",
 "ABCorderNum": "D",
 "Content": "传递",
 "OrderNum": 4
 }
 ]
 },

 */

- (void)initTableView {
    
    _QuestionInfoTable.delegate = self;
    _QuestionInfoTable.dataSource = self;
    _QuestionInfoTable.estimatedRowHeight = 20.0;
    _QuestionInfoTable.rowHeight = UITableViewAutomaticDimension;
    [_QuestionInfoTable registerNib:[UINib nibWithNibName:@"SelecteAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:CellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)_courseInfo[@"QuestionOptionList"]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *SELItem = @"";
    for (NSDictionary *AnInfo in self.answerArray) {
        for (NSDictionary *questionInfo in self.courseInfo[@"QuestionOptionList"]) {
            if ([AnInfo[@"Id"] isEqualToString:questionInfo[@"Id"]]) {
                SELItem = [NSString stringWithFormat:@"%@%@",SELItem,questionInfo[@"ABCorderNum"]];
                break;
            }
        }
    }

    QuestionHeaderView *gradeView = [[NSBundle mainBundle] loadNibNamed:@"QuestionHeaderView" owner:nil options:nil].lastObject;
    gradeView.question.text = [NSString stringWithFormat:@"%@( %@ )", self.courseInfo[@"Content"],SELItem];
    gradeView.type = [self.courseInfo[@"QuestionType"] integerValue];
    self.QUEType = [self.courseInfo[@"QuestionType"] integerValue];
    gradeView.tag = QUE_TAG;
    return gradeView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelecteAnswerTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
   
    NSDictionary *optionsInfo = [NSDictionary safeDictionary:_courseInfo[@"QuestionOptionList"][indexPath.row]];
//    cell.selecteItem.text = [answer substringWithRange:NSMakeRange(0, 1)];
//    cell.selecteAnswer.text = [answer substringFromIndex:1];
    cell.selecteItem.text = optionsInfo[@"ABCorderNum"];
    cell.selecteAnswer.text = optionsInfo[@"Content"];
    cell.selecteItem.layer.backgroundColor = [UIColor whiteColor].CGColor;
    cell.selecteItem.textColor = MainTextColor_DarkBlack;

    for (NSDictionary *dic in self.answerArray) {
        if ([optionsInfo[@"Id"] isEqualToString:dic[@"Id"]]) {
            cell.selecteItem.layer.backgroundColor = MainThemeColor_Blue.CGColor;
            cell.selecteItem.textColor = [UIColor whiteColor];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelecteAnswerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *answerId = self.courseInfo[@"QuestionOptionList"][indexPath.row][@"Id"];
    if (self.QUEType == TestQuestionTypeSigle) {//单选
        NSDictionary *anInfo = @{@"Item":self.answerArray[0][@"Item"],
                                 @"Id":answerId};
        [self.answerArray replaceObjectAtIndex:0 withObject:anInfo];
        [tableView reloadData];
    } else if (self.QUEType == TestQuestionTypeMultiple) {//多选

        NSArray *CAnswers = [NSArray arrayWithArray:self.answerArray];
        NSInteger index = 0;
        for (NSDictionary *AnInfo in CAnswers) {
            if ([AnInfo[@"Id"] isEqualToString:answerId]) {
                [self.answerArray replaceObjectAtIndex:index withObject:@{@"Item":AnInfo[@"Item"],@"Id":@""}];
                cell.selecteItem.layer.backgroundColor = MainThemeColor_Blue.CGColor;
                cell.selecteItem.textColor = [UIColor whiteColor];
            } else {
                cell.selecteItem.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.selecteItem.textColor = MainTextColor_DarkBlack;
                [self.answerArray replaceObjectAtIndex:index withObject:@{@"Item":AnInfo[@"Item"],@"Id":answerId}];
            }
            index++;
        }

    } else {
    
    }
    NSString *SELItem = @"";
    for (NSDictionary *AnInfo in self.answerArray) {
        for (NSDictionary *questionInfo in self.courseInfo[@"QuestionOptionList"]) {
            if ([AnInfo[@"Id"] isEqualToString:questionInfo[@"Id"]]) {
                SELItem = [NSString stringWithFormat:@"%@%@",SELItem,questionInfo[@"ABCorderNum"]];
                break;
            }
        }
    }
    
    
    QuestionHeaderView *headerView = [_QuestionInfoTable viewWithTag:QUE_TAG];
    headerView.question.text = [NSString stringWithFormat:@"%@(%@)",self.courseInfo[@"Content"],SELItem];

    self.selectedAnswer(self.answerArray);
  
}






@end
