//
//  FocusSlidView.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/1.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FocusSlidView.h"
#import "SliderView.h"
#import "HOMEHeader.h"

@interface FocusSlidView ()

@end

@implementation FocusSlidView

@synthesize mainView = _mainView;
@synthesize entity = _entity;
@synthesize list = _list;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

+ (instancetype) initViewLayout {
    
    FocusSlidView *cell = [[[NSBundle mainBundle] loadNibNamed:@"focus_view" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    //[self setBackgroundColor:[UIColor grayColor]];
    
}

- (void) fillLayout {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    for (MainViewCycModel *model in _list) {
        [arr addObject:model.Cover];
        [titles addObject:[NSString stringWithFormat:@" %@", model.Title]];
    }
    
    _mainView = [SliderView adScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 190) imageLinkURL:arr placeHoderImageName:@"logo_setting" pageControlShowStyle:UIPageControlShowStyleRight];
    [_mainView setAdTitleArray:titles withShowStyle:AdTitleShowStyleLeft];
    _mainView.adMoveTime = 4;
    _mainView.callBack = ^(NSInteger index,NSString * imageURL)
    {
        NSString *categoryId = @"69d9cf0e-98f8-452c-be23-2eb84315988a";
        if(index == 0) categoryId = @"69d9cf0e-98f8-452c-be23-2eb84315988a";
        else if(index == 1) categoryId = @"e2b60a32-df9d-454c-9b09-4589302d237e";
        else categoryId = @"40d9ebc5-7e11-488a-9670-5d761c1d8e7a";
        
        MainViewCycModel *model = _list[index];
        [self pushToVideoPage:model.Id courseCover:model.Cover pageCategoryId:categoryId];
    };
    
    [self addSubview:_mainView];
    [self bringSubviewToFront:_mainView];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    NSLog(@"initWithFrame");
    return self;
}

@end