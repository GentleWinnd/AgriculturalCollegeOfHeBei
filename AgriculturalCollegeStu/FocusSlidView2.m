//
//  FocusSlidView2.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/29.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#define FAKE_COUNT  100000;
#define TAB_IMG     0
#define TAB_DOT     1
#define DOT_CELL_H 15

#import <Foundation/Foundation.h>


#import "FocusSlidView2.h"
#import "HOMEHeader.h"
#import "FocusImgCell.h"
#import "UIImageView+AFNetworking.h"
#import "MainViewCycModel.h"
#import "DotCell.h"


@interface FocusSlidView2 () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FocusSlidView2
{
    NSMutableArray *cells;
    int currentSelectedIndex;
    int currentIndexPathRow;
    NSTimer *timer;
}

@synthesize tabv_imgs = _tabv_imgs;
@synthesize slidDelay = _slidDelay;
@synthesize cycModels = _cycModels;
@synthesize tabv_dots = _tabv_dots;


+ (instancetype) initViewLayout {
    
    FocusSlidView2 * view = [[[NSBundle mainBundle] loadNibNamed:@"focus_view_2" owner:nil options:nil] lastObject];
    
    return view;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    cells = [NSMutableArray array];
    _slidDelay = 5;
}

- (void) setFocusImgsList:(NSMutableArray *) cycModels {
    
    currentIndexPathRow = 0;
    _tabv_imgs.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
    _tabv_imgs.delegate = self;
    _tabv_imgs.dataSource = self;
    _tabv_imgs.separatorStyle = NO;
    _tabv_imgs.showsVerticalScrollIndicator = NO;
    _tabv_imgs.pagingEnabled = YES;
    _tabv_imgs.tag = TAB_IMG;
    if(cells.count != 0) [cells removeAllObjects];
    _cycModels = cycModels;
    [_tabv_imgs reloadData];
    
    _tabv_dots.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
    _tabv_dots.delegate = self;
    _tabv_dots.dataSource = self;
    _tabv_dots.separatorStyle = NO;
    _tabv_dots.showsVerticalScrollIndicator = NO;
    _tabv_dots.tag = TAB_DOT;
    [_tabv_dots reloadData];
    
    if(timer != nil) {
        [timer invalidate];
    }
    
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:_slidDelay target:self selector:@selector(toSild) userInfo:nil repeats:YES];
}
- (void) toSild {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndexPathRow inSection:0];
    [_tabv_imgs selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    currentIndexPathRow ++;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView.tag == TAB_IMG) ? 100000 : _cycModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.tag == TAB_IMG) {
    
        FocusImgCell *cell = nil;
        
        currentIndexPathRow = (int) indexPath.row;
        int realIndex = (int) indexPath.row % (int) _cycModels.count;
        NSLog(@"current index = %d, arr.count = %d", realIndex, (int) _cycModels.count);
        MainViewCycModel *cellEntity = nil;
        
        if(_cycModels.count > realIndex) {
            cellEntity = (MainViewCycModel *)[_cycModels objectAtIndex:realIndex];
        } else {
            cellEntity = [[MainViewCycModel alloc] init];
            cellEntity.Cover = @"http://";
            cellEntity.Title = @"";
        }
        
        currentSelectedIndex = realIndex;
        if(cells.count < _cycModels.count) {
            FocusImgCell *fic = [FocusImgCell initViewLayout];
            NSString *coverStr = cellEntity.Cover;
            [fic setImageUrl:coverStr];
            [cells addObject:fic];
            fic.transform = CGAffineTransformMakeRotation(M_PI /2.f);
        }
        
        NSString *title = cellEntity.Title;
        [_lbl_title setText:title];
        
        NSLog(@"cells count = %d", (int) cells.count);
        
        @try {
            if(realIndex < cells.count ) {
                
                cell = [cells objectAtIndex:realIndex];
            } else {
                
                cell = [cells objectAtIndex:(cells.count - 1)];
            }
        } @catch (NSException *exception) {
            
            FocusImgCell *fic = [FocusImgCell initViewLayout];
            NSString *coverStr = cellEntity.Cover;
            [fic setImageUrl:coverStr];
            [cells addObject:fic];
            fic.transform = CGAffineTransformMakeRotation(M_PI /2.f);
            cell = fic;
        }
        
        [_tabv_dots reloadData];
        return cell;
        
    } else if(tableView.tag == TAB_DOT) {
        
        DotCell *cell = [DotCell initViewLayout];
        cell.transform = CGAffineTransformMakeRotation(M_PI /2.f);
        
        if(currentSelectedIndex == indexPath.row) [cell.v_selected setHidden:NO];
        else [cell.v_selected setHidden:YES];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int) indexPath.row % (int) _cycModels.count;
    NSString *categoryId = @"69d9cf0e-98f8-452c-be23-2eb84315988a";
    if(index == 0) categoryId = @"69d9cf0e-98f8-452c-be23-2eb84315988a";
    else if(index == 1) categoryId = @"e2b60a32-df9d-454c-9b09-4589302d237e";
    else categoryId = @"40d9ebc5-7e11-488a-9670-5d761c1d8e7a";
    
    MainViewCycModel *model = _cycModels[index];
    [self pushToVideoPage:model.Id courseCover:model.Cover pageCategoryId:categoryId];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView.tag == TAB_IMG) {
        
        return WIDTH;
    } else {
        
        return DOT_CELL_H;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *) tableView:(UITableView *) tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    [v setFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollView.contentOffset.y /WIDTH inSection:0];
    NSLog(@"indexPath : %d", (int)indexPath.row);
}


@end
