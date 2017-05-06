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

    [self initTableView];
}

- (void)setCourseInfo:(NSDictionary *)courseInfo {

    [_QuestionInfoTable reloadData];
}

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
//    NSString *SELItem = @"";
//    for (NSDictionary *AnInfo in self.answerArray) {
//        for (NSDictionary *questionInfo in self.courseInfo[@"QuestionOptionList"]) {
//            if ([AnInfo[@"Id"] isEqualToString:questionInfo[@"Id"]]) {
//                SELItem = [NSString stringWithFormat:@"%@%@",SELItem,questionInfo[@"ABCorderNum"]];
//                break;
//            }
//        }
//    }
//
    QuestionHeaderView *gradeView = [[NSBundle mainBundle] loadNibNamed:@"QuestionHeaderView" owner:nil options:nil].lastObject;
    gradeView.question.text = [NSString stringWithFormat:@"%@", self.courseInfo[@"Content"]];
    gradeView.type = [self.courseInfo[@"QuestionType"] integerValue];
    self.QUEType = [self.courseInfo[@"QuestionType"] integerValue];
    gradeView.tag = QUE_TAG;
    return gradeView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelecteAnswerTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
   
    NSDictionary *optionsInfo = [NSDictionary safeDictionary:_courseInfo[@"QuestionOptionList"][indexPath.row]];
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
    
    NSString *answerId = self.courseInfo[@"QuestionOptionList"][indexPath.row][@"Id"];
    if (self.QUEType == TestQuestionTypeSigle) {//单选
        NSDictionary *anInfo = @{@"Item":self.answerArray[indexPath.row][@"Item"],
                                 @"Id":answerId};
        [self.answerArray replaceObjectAtIndex:0 withObject:anInfo];
        [tableView reloadData];
    } else if (self.QUEType == TestQuestionTypeMultiple) {//多选
        
        NSDictionary *selectedItem = self.answerArray[indexPath.row];
        if ([selectedItem[@"Id"] isEqualToString:answerId]) {
            [self.answerArray replaceObjectAtIndex:indexPath.row withObject:@{@"Item":selectedItem[@"Item"],@"Id":@""}];
        } else {
            [self.answerArray replaceObjectAtIndex:indexPath.row withObject:@{@"Item":selectedItem[@"Item"],@"Id":answerId}];
        }

        [tableView reloadData];

//    NSString *SELItem = @"";
//    for (NSDictionary *AnInfo in self.answerArray) {
//        for (NSDictionary *questionInfo in self.courseInfo[@"QuestionOptionList"]) {
//            if ([AnInfo[@"Id"] isEqualToString:questionInfo[@"Id"]]) {
//                SELItem = [NSString stringWithFormat:@"%@%@",SELItem,questionInfo[@"ABCorderNum"]];
//                break;
//            }
//        }
//    }
//    
    
//    QuestionHeaderView *headerView = [_QuestionInfoTable viewWithTag:QUE_TAG];
//    headerView.question.text = [NSString stringWithFormat:@"%@(%@)",self.courseInfo[@"Content"],SELItem];
    }
    self.selectedAnswer(self.answerArray);
  
}






@end
