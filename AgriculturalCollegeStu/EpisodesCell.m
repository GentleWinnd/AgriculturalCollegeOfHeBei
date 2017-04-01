//
//  EpisodesCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/22.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EpisodesCell.h"


@interface  EpisodesCell()

@end

@implementation EpisodesCell

+ (instancetype) initViewLayout {
    
    EpisodesCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"video_episodes" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end