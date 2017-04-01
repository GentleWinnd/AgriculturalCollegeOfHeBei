//
//  ListCellMyCourse.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/19.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListCellMyCourse.h"
#import "VideoPageModel.h"
#import "UIImageView+AFNetworking.h"
#import "Header_key.h"

#define URL_CANCEL_SIGN @"http://www.bjdxxxw.cn/OfflineCourse/CancelSignWithMobile"


@interface  ListCellMyCourse()

@end

@implementation ListCellMyCourse
{
    
}



+ (instancetype) initViewLayout {
    
    ListCellMyCourse * cell = [[[NSBundle mainBundle] loadNibNamed:@"list_cell_mycourse" owner:nil options:nil] lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    [self bringSubviewToFront:_btn_cancelSign];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) fillContent:(OfflineCourseModel *) model {
    _entity = model;
    [_lbl_startDate setText:model.StartDate];
    [_lbl_teacherName setText:model.Teacher];
    [_lbl_address setText:model.Address];
    NSURL *picUrl = [[NSURL alloc] initWithString:model.Pic];
    [_imgv_pic setImageWithURL:picUrl];
}

- (IBAction) onCancelBtnClick:(id)sender {
    
    NSString *userName = nil;
    
    if(userName != nil && userName.length != 0) {
        
        NSDictionary *para = @{@"UserName":userName, @"Id":_entity.Id};
        
//        AFHTTPRequestOperationManager *_AFNManager = [AFHTTPRequestOperationManager manager];
//        _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
//        
//        [_AFNManager POST:URL_CANCEL_SIGN parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            
//            BOOL success = [dic[@"State"] integerValue] == 1;
//            
//            if (success) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_USERSTATE_CHANGE object:nil];
//                
//                [((MyCourseViewController *) _parentVc) notifListChange:_entity];
//                
//            } else {
//                
//                
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            
//        }];
    } else {
        
        
    }

}

@end
