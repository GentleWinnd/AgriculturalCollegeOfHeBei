//
//  MainViewModel.h
//  OldUniversity
//
//  Created by mahaomeng on 15/7/23.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HOMEBaseModel.h"

@interface FirstPageContentModel : HOMEBaseModel

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, retain) NSArray *Courses;

@end
