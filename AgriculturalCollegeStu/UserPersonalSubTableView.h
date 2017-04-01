//
//  UserPersonalSubTableView.h
//  OldUniversity
//
//  Created by mahaomeng on 15/8/7.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

//#import "BaseTableView.h"

@interface UserPersonalSubTableView : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIViewController *superViewController;
@property (nonatomic, strong) UITableView *subTableView;
@property (nonatomic, assign) NSInteger tagNum;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withViewController:(UIViewController *)viewController andTagNum:(NSInteger)num;

@end
