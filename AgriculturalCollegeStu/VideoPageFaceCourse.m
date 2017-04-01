//
//  VideoPageFaceCourse.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/9.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoPageFaceCourse.h"
#import "VideoPageModel.h"
#import "VideoEpisodesModel.h"
#import "VideoView.h"
#import "Header_key.h"
#import "ChapterSuperCell.h"
#import "FaceCourseModel.h"
#import "ChapterSuperCellB.h"

#define CONTENTSIZE_HEIGHT_2 000



@interface VideoPageFaceCourse () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VideoPageFaceCourse
{
    FaceCourseModel *_entity;
    VideoView *videoView;
    ChapterSuperCell *_csc;
    bool isfirstAppear;
}

@synthesize teacherModel = _teacherModel;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    _tabv_mainContentTabview.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
    _tabv_mainContentTabview.delegate = self;
    _tabv_mainContentTabview.dataSource = self;
    _tabv_mainContentTabview.separatorStyle = NO;
    _tabv_mainContentTabview.pagingEnabled = YES;
    _tabv_mainContentTabview.showsVerticalScrollIndicator = NO;

    _entity = [[FaceCourseModel alloc] init];
    
    _v_indactorChatperLine.hidden = NO;
    _v_indactorIntroducationLine.hidden = YES;
    isfirstAppear = YES;
    
    videoView = [VideoView initViewLayout];
    videoView.videoPageViewController = self;
    
    [self loadDetailInfo];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(isfirstAppear) {
        isfirstAppear = NO;
        _v_buttomContainer_topv.clipsToBounds = NO;
        _v_buttomContainer_topv.layer.shadowColor = [UIColor blackColor].CGColor;
        _v_buttomContainer_topv.layer.shadowOffset = CGSizeMake(0, 1);
        _v_buttomContainer_topv.layer.shadowOpacity = 0.5;
        _v_buttomContainer_topv.layer.shadowRadius = 1;
        
        videoView.hidden = YES;
        videoView.frame = _v_topContainer.frame;
        videoView.v_referenceBunds = _v_topContainer;
        [self.view addSubview:videoView];
        [self.view bringSubviewToFront:videoView];
    }
    
}

- (void) loadDetailInfo {
    [NetServiceAPI getMoocInfoWithParameters:nil success:^(id responseObject) {
        _entity.Id = responseObject[@"Id"];
        _entity.Name = responseObject[@"Name"];
        _entity.Groups = responseObject[@"Groups"];
        
        _csc = [ChapterSuperCell initViewLayout];
        _csc.transform = CGAffineTransformMakeRotation(M_PI /2.f);
        _csc.entity = _entity;
        _csc.videoView = videoView;
        _csc.parentVc = self;
        [_csc processChapterInfo];
        
        [_tabv_mainContentTabview reloadData];

    } failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        
        static NSString *CellIdentifier = @"chapter_page_super_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            if(_csc == nil) {
                cell = [[UITableViewCell alloc] init];
            } else {
                cell = _csc;
            }
        }
        
        return cell;
        
    } else if(indexPath.row == 1) {
        
        static NSString *CellIdentifier = @"chapter_page_super_cell_2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            ChapterSuperCellB *cscb = [ChapterSuperCellB initViewLayout];
            cscb.transform = CGAffineTransformMakeRotation(M_PI /2.f);
            cscb.teacherModel = _teacherModel;
            cscb.courseDesc = _courseDesc;
            [cscb fillContent];
            cell = cscb;
        }
        
        return cell;
        
    }
    
    return nil;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WIDTH;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollView.contentOffset.y /WIDTH inSection:0];
    if(indexPath.row == 0) {
        _v_indactorIntroducationLine.hidden = YES;
        _v_indactorChatperLine.hidden = NO;
    } else if(indexPath.row == 1) {
        _v_indactorIntroducationLine.hidden = NO;
        _v_indactorChatperLine.hidden = YES;
    }
}

- (IBAction) onGobackClicked:(id)sender {

    [_parentVc dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction) onPageclick:(id)sender {
    
    int tag = (int)[sender tag];
    NSIndexPath *path = nil;
    
    if(tag == 11) {
        
        _v_indactorIntroducationLine.hidden = YES;
        _v_indactorChatperLine.hidden = NO;
        path = [NSIndexPath indexPathForItem:0 inSection:0];
        [_tabv_mainContentTabview scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    } else if (tag == 22) {
        
        _v_indactorIntroducationLine.hidden = NO;
        _v_indactorChatperLine.hidden = YES;
        path = [NSIndexPath indexPathForItem:1 inSection:0];
        [_tabv_mainContentTabview scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
    }
}

@end
