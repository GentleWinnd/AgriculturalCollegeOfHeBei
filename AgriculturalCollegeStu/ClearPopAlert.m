//
//  ClearPopAlert.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/26.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClearPopAlert.h"

#define TAG_CONFIRM 0
#define TAG_NEGTIVE 2

@interface  ClearPopAlert()

@end

@implementation ClearPopAlert
{
    
}

@synthesize lbl_messsage;
@synthesize btn_confirm;
@synthesize btn_negtive;
@synthesize v_btn_container;

+ (instancetype) initViewLayout {
    
    ClearPopAlert * view = [[[NSBundle mainBundle] loadNibNamed:@"pop" owner:nil options:nil] lastObject];
    
    return view;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1;
    
    [self bringSubviewToFront:v_btn_container];
    
    btn_negtive.tag = TAG_NEGTIVE;
    btn_confirm.tag = TAG_CONFIRM;
}

- (IBAction) onClickEvetn:(id)sender {
    
    switch ([sender tag]) {
        case TAG_CONFIRM:
            break;
        case TAG_NEGTIVE:
            break;
        default:
            break;
    }
    
}

@end
