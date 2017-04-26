//
//  ChapterModel.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//


@interface ChapterModel : NSObject

@property (retain, nonatomic) NSString *Name;
@property (assign, nonatomic) BOOL isGroup;
@property (retain, nonatomic) NSMutableDictionary *videoDic;
@property (retain, nonatomic) NSMutableDictionary *handoutDic;

@end
