//
//  VideoPageModel.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/22.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import "VideoView.h"

@interface VideoPageModel : NSObject

@property (nonatomic, copy) NSString *parentCategoryId;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Cover;

@property (nonatomic, copy) NSString *Information;

@property (nonatomic, copy) NSString *Period;

@property (nonatomic, copy) NSString *Public;

@property (nonatomic, strong) NSMutableArray *episodesArray;

//@property (nonatomic, strong) VideoView *videoPlayer;

@end
