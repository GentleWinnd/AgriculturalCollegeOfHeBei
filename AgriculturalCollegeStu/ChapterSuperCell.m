//
//  FirstPageSuperCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "MainViewCycModel.h"
#import "HOMEHeader.h"
#import "FirstPageContentModel.h"
#import "FocusSlidView.h"
#import "FirstPageCellA.h"
#import "FirstPageCellB.h"
#import "FirstPageTitleTableViewCell.h"
#import "FirstPageSearchBarCell.h"
#import "FocusSlidView2.h"
#import "ChapterSuperCell.h"
#import "ChapterCellA.h"
#import "ChapterModel.h"
#import "ChapterCellB.h"


@interface ChapterSuperCell ()

@end

@implementation ChapterSuperCell
{
    NSMutableArray *dataList;
    NSMutableArray *autoPlayList;
}

@synthesize tabv_chapterInfo = _tabv_chapterInfo;
@synthesize entity = _entity;

+ (instancetype) initViewLayout {
    
    ChapterSuperCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"chapter_super_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    _tabv_chapterInfo.delegate = self;
    _tabv_chapterInfo.dataSource = self;
    _tabv_chapterInfo.separatorStyle = NO;
    _tabv_chapterInfo.showsVerticalScrollIndicator = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) toProcess {
    
    if(dataList != nil) {
        [dataList removeAllObjects];
        dataList = nil;
    }
    
    dataList = [NSMutableArray array];
    autoPlayList = [NSMutableArray array];
    
    NSArray *groups = _entity.Groups;
    
    for(int i = 0; i < groups.count; i ++) {
        
        NSDictionary *group = [groups objectAtIndex:i];
        ChapterModel *groupModel = [[ChapterModel alloc] init];
        groupModel.isGroup = YES;
        groupModel.Name = group[@"Name"];
        [dataList addObject:groupModel];
        
        NSArray *units = group[@"Subjects"];
        
        for(int k = 0; k < units.count; k ++ ) {
            
            NSDictionary *unit = [units objectAtIndex:k];
            ChapterModel *unitModel = [[ChapterModel alloc] init];
            unitModel.isGroup = NO;
            unitModel.Name = unit[@"Name"];
            NSArray *unitInfos = unit[@"Units"];
            
            for(int o = 0; o < unitInfos.count; o ++) {
                
                NSDictionary *unitInfo = [unitInfos objectAtIndex:o];
                if([unitInfo[@"ContentType"] isEqualToString:@"Video"]) {
                    NSString *videoUrl = unitInfo[@"Content"];
                    [autoPlayList addObject:[[NSURL alloc] initWithString:videoUrl]];
                    unitModel.videoDic = [NSMutableDictionary dictionary];
                    [unitModel.videoDic setObject:videoUrl forKey:@"video"];
                    
                } else if([unitInfo[@"ContentType"] isEqualToString:@"Handout"]) {
                    NSString *handoutInfo = unitInfo[@"Content"];
                    unitModel.handoutDic = [NSMutableDictionary dictionary];
                    [unitModel.handoutDic setObject:handoutInfo forKey:@"handout"];
                    
                } else if([unitInfo[@"ContentType"] isEqualToString:@"Exercise"]) {
                    NSString *videoUrl = unitInfo[@"Content"];
                    
                }
            }
            [dataList addObject:unitModel];
        }
    }
    
    [self performSelectorOnMainThread:@selector(toProcessFinished) withObject:nil waitUntilDone:NO];
}

- (void) processChapterInfo {
    
    [self performSelectorInBackground:@selector(toProcess) withObject:nil];

}

- (void) toProcessFinished {
    
    [_tabv_chapterInfo reloadData];
    _videoView.hidden = NO;
    if(autoPlayList.count != 0) [_videoView videoToPlayList:autoPlayList];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"face_page_super_cell_content";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        ChapterModel *model = [dataList objectAtIndex:indexPath.row];
        if(model.isGroup) {
        
            ChapterCellA *sectionCell = [ChapterCellA initViewLayout];
            [sectionCell.lbl_groupName setText:model.Name];
            cell = sectionCell;
            
        } else {
            
            ChapterCellB *unitCell = [ChapterCellB initViewLayout];
            unitCell.hostCell = self;
            [unitCell.btn_toPlayVideo setTitle:model.Name forState:UIControlStateNormal];
            
            if(model.videoDic[@"video"]) {
                unitCell.videoUrl = model.videoDic[@"video"];
                unitCell.btn_toPlayVideo.hidden = NO;
            } else {
                if(model.handoutDic[@"handout"]) {
                    unitCell.btn_toPlayVideo.tag = 0x3;
                    [unitCell.imgv_left setImage:[UIImage imageNamed:@"handout"]];
                    unitCell.handoutContent = model.handoutDic[@"handout"];
                    return unitCell;
                }
            }
            
            if(model.handoutDic[@"handout"]) {
                unitCell.btn_toShowHandout.hidden = NO;
                unitCell.handoutContent = model.handoutDic[@"handout"];
            } else {
                [unitCell.imgv_left setImage:[UIImage imageNamed:@"lx"]];
                unitCell.btn_toShowHandout.hidden = YES;
                unitCell.imgv_right.hidden = YES;
            }
            
            cell = unitCell;
        }
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"000000000");
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (UIView *) tableView:(UITableView *) tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    [v setFrame:CGRectMake(0, 0, 0, 0)];
    return v;
}

@end
