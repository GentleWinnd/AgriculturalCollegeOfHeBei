//
//  VideoEpisodesModel.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/22.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import "HOMEBaseModel.h"
#import "VideoEpisodesModel.h"

@interface VideoEpisodesModel : HOMEBaseModel


@property (copy, nonatomic) NSString *Id;
@property (copy, nonatomic) NSString *Title;
@property (assign, nonatomic) NSInteger OrderBy;
@property (copy, nonatomic) NSString *Url;

@end
