//
//  SecondTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/8.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SecondTableViewCell.h"

@interface SecondTableViewCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backGroundViewOne;
@property (weak, nonatomic) IBOutlet UIView *backGroundViewTwo;
@property (strong, nonatomic) IBOutlet UIView *backGroundViewThree;
@property (strong, nonatomic) IBOutlet UIView *backGroundViewFour;
@property (strong, nonatomic) IBOutlet UIView *backGorundViewFive;
@property (strong, nonatomic) IBOutlet UIView *backGroundViewSix;

@property (strong, nonatomic) IBOutlet UILabel *coutLabelOne;
@property (strong, nonatomic) IBOutlet UILabel *countLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *countLabelThree;
@property (strong, nonatomic) IBOutlet UILabel *countLabelFour;
@property (strong, nonatomic) IBOutlet UILabel *countLabelFive;
@property (strong, nonatomic) IBOutlet UILabel *countLabelSix;
@property (strong, nonatomic) IBOutlet UIPageControl *page;

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backGroudViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingSpace;

@end
@implementation SecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initContentScrollView];
    [self setCountLabel];
}

- (void)initContentScrollView {
    
    //CGFloat height = _contentScrollView.bounds.size.height;
    CGFloat width = 6*(WIDTH-3)/4;
    _contentScrollView.contentSize = CGSizeMake(2*WIDTH, 0);
    _backGroudViewHeight.constant = (WIDTH-3)/4;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.directionalLockEnabled = YES;
    _trailingSpace.constant = 2*WIDTH-width;
}

- (void)setCountLabel {
   
    
    _countLabelTwo.layer.cornerRadius= 6;
    _countLabelTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabelTwo.layer.borderWidth = 1;
    
    _countLabelThree.layer.cornerRadius= 6;
    _countLabelThree.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabelThree.layer.borderWidth = 1;
    
    _coutLabelOne.layer.cornerRadius= 6;
    _coutLabelOne.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _coutLabelOne.layer.borderWidth = 1;
    
    _countLabelFour.layer.cornerRadius= 6;
    _countLabelFour.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabelFour.layer.borderWidth = 1;
    
    _countLabelFive.layer.cornerRadius= 6;
    _countLabelFive.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabelFive.layer.borderWidth = 1;
    
    _countLabelSix.layer.cornerRadius= 6;
    _countLabelSix.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabelSix.layer.borderWidth = 1;
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"----scrollW==%f-----===%f",scrollView.contentOffset.x,WIDTH);
    
    CGFloat page = scrollView.contentOffset.x/WIDTH;
    _page.currentPage = page;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
