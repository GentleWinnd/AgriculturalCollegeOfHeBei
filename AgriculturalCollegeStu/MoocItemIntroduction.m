//
//  MoocItemIntroduction.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/17.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondPageCellD.h"
#import "SubTableViewModel.h"
#import "UIImageView+AFNetworking.h"
#import "MoocItemIntroduction.h"
#import "AFHTTPSessionManager.h"
#import "HOMEHEADER.h"
#import "TeacherModel.h"
#import "VideoPageFaceCourse2.h"
#import "OfflineCourseModel.h"
#import "Header_key.h"

#define URL_BATCH_INFO @"http://templmsapi.urart.cc/Batch/List?CourseId=%@"
#define URL_OFFLINE_COURSE @"http://www.bjdxxxw.cnOfflineCourse/Mobile?UserName=%@&Name=%@&PageNum=%@&PageSize=%@"
#define URL_OFFLINE_COURSE_SIGN @"http://www.bjdxxxw.cn/OfflineCourse/SignWithMobile"

@interface  MoocItemIntroduction()



@end

@implementation MoocItemIntroduction
{

    UITextView *_lbl_itemDesc;
    TeacherModel *teacher;
    AFHTTPSessionManager * _AFNManager;
}

@synthesize v_itemContainer = _v_itemContainer;
@synthesize entity = _entity;
@synthesize imgv_itemCover = _imgv_itemCover;
@synthesize scl_itemDescContainer = _scl_itemDescContainer;
@synthesize imgv_teacher = _imgv_teacher;
@synthesize v_avatarContainer = _v_avatarContainer;
@synthesize btn_toLearn = _btn_toLearn;
@synthesize imgv_address = _imgv_address;
@synthesize imgv_start = _imgv_start;
@synthesize imgv_date = _imgv_date;
@synthesize lbl_address = _lbl_address;
@synthesize lbl_unsignCount = _lbl_unsignCount;
@synthesize lbl_planCount = _lbl_planCount;
@synthesize entity2 = _entity2;
@synthesize userName = _userName;

+ (instancetype) initViewLayout {
    
    MoocItemIntroduction *cell = [[[NSBundle mainBundle] loadNibNamed:@"introduction2" owner:nil options:nil]  lastObject];
    return cell;
}

- (void) fillContent {
    
    NSURL *coverUrl = [[NSURL alloc] initWithString:_entity2.Pic];
    [_lbl_title setText:_entity2.Name];
    
    [_lbl_address setText:_entity2.Address];
    [_lbl_date setText:_entity2.Teacher];
    [_lbl_start setText:_entity2.StartDate];
    [_lbl_unsignCount setText:[NSString stringWithFormat:@"%@", _entity2.UserUnSignCount]];
    [_lbl_planCount setText:[NSString stringWithFormat:@" / %@", _entity2.PlanPersonNum]];
    
    _scl_itemDescContainer.contentSize = CGSizeMake(WIDTH * 0.8 - 16, 110);
    _lbl_itemDesc = [[UITextView alloc] init];
    [_lbl_itemDesc setFrame:CGRectMake(0, 0, WIDTH * 0.8 - 16, 110)];
    
    [_lbl_itemDesc setUserInteractionEnabled:NO];
    UIFont *font = [UIFont fontWithName:@"Microsoft Yahei" size:12];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _lbl_itemDesc.attributedText = [[NSAttributedString alloc] initWithString:_entity2.Desc attributes:attributes];
    [_lbl_itemDesc setTextColor:[UIColor darkGrayColor]];
    
    [_imgv_itemCover setImageWithURL:coverUrl];
    [_scl_itemDescContainer addSubview:_lbl_itemDesc];
    
    if(_entity2.IsEnd.integerValue == 1) {
        
        [_btn_toLearn setTitle:@"已截止报名" forState:UIControlStateNormal];
        [_btn_toLearn setBackgroundColor:OFFLINE_SIGN_BTN_BG_GRAY];
        _btn_toLearn.tag = 3;
    } else {
        
        [self setSignInBtnState:[[NSString stringWithFormat:@"%@", _entity2.IsUserSign] isEqualToString:@"1"]];
    }
    
//    [self requestBatchInfo];
//    [self requestDetailInfo];
}

- (void) setSignInBtnState:(BOOL) isSigned {
    
    if(isSigned) {
        [_btn_toLearn setTitle:@"已报名" forState:UIControlStateNormal];
        [_btn_toLearn setBackgroundColor:OFFLINE_SIGN_BTN_BG_BLUE];
        _btn_toLearn.tag = 1;
    } else {
        [_btn_toLearn setTitle:@"报名" forState:UIControlStateNormal];
        [_btn_toLearn setBackgroundColor:OFFLINE_SIGN_BTN_BG_MAIN_THEME];
        _btn_toLearn.tag = 0;
    }
}


/*-(void) requestDetailInfo
{
    AFHTTPRequestOperationManager * _AFNManager = [AFHTTPRequestOperationManager manager];
    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [_AFNManager GET:[NSString stringWithFormat:URL_MUKE_DETAIL, _entity.Id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if(![dic[@"Information"] isEqual:[NSNull null]]) {
            [_lbl_itemDesc setText:dic[@"Information"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.description);
    }];
}

- (void) requestBatchInfo {

    AFHTTPRequestOperationManager * _AFNManager = [AFHTTPRequestOperationManager manager];
    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_AFNManager GET:[NSString stringWithFormat:URL_BATCH_INFO, _entity.Id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if(arr != nil && arr.count != 0) {
            
            if([_entity.Name isEqualToString:@"动画短片创作"]) {
                
                [_imgv_address setImage: [UIImage imageNamed:@"c_addr_enable"]];
                [_imgv_start setImage: [UIImage imageNamed:@"c_start_enable"]];
                [_imgv_date setImage: [UIImage imageNamed:@"c_date_enable"]];
                
                [_lbl_address setTextColor:[UIColor grayColor]];
                [_lbl_date setTextColor:[UIColor grayColor]];
                [_lbl_start setTextColor:[UIColor grayColor]];
                
                [_lbl_address setText:@"大兴校区"];
                [_lbl_date setText:@"2015-12-3 开课"];
                [_lbl_start setText:@"今日有课"];
                
                _btn_toLearn.hidden = NO;
                
                NSArray *teachers = [arr objectAtIndex:0][@"Teachers"];
                NSDictionary *dic = [teachers objectAtIndex:0];
                teacher = [[TeacherModel alloc] init];
                teacher.FullName = dic[@"FullName"];
                teacher.Description = dic[@"Description"];
                teacher.Photo = dic[@"Photo"];
                
                NSURL *avatorUrl = [[NSURL alloc] initWithString:teacher.Photo];
                [_imgv_teacher setImageWithURL:avatorUrl];
                [_lbl_teacher setText:teacher.FullName];
            }
            
        } else {
            
            [_imgv_address setImage: [UIImage imageNamed:@"course_addr"]];
            [_imgv_start setImage: [UIImage imageNamed:@"c_start"]];
            [_imgv_date setImage: [UIImage imageNamed:@"c_date"]];
            
            [_lbl_address setTextColor:[UIColor lightGrayColor]];
            [_lbl_date setTextColor:[UIColor lightGrayColor]];
            [_lbl_start setTextColor:[UIColor lightGrayColor]];
            
            [_lbl_address setText:@"地点待定"];
            [_lbl_date setText:@"敬请期待"];
            [_lbl_start setText:@"正在筹备"];
            
            _btn_toLearn.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error.description);
    }];
    
}*/


- (void) awakeFromNib {
    [super awakeFromNib];
    
//    _AFNManager = [AFHTTPRequestOperationManager manager];
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];

    [_v_itemContainer setClipsToBounds:NO];
    
    _v_itemContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    _v_itemContainer.layer.shadowOffset = CGSizeMake(0, 1);
    _v_itemContainer.layer.shadowOpacity = 0.5;
    _v_itemContainer.layer.shadowRadius = 3;
    
    //添加四个边阴影
//    _v_avatarContainer.clipsToBounds = NO;
//    _v_avatarContainer.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//    _v_avatarContainer.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    _v_avatarContainer.layer.shadowOpacity = 0.5;//不透明度
//    _v_avatarContainer.layer.shadowRadius = 2.0;//半径
    
    _v_avatarContainer.hidden = YES;
   
    _btn_toLearn.hidden = NO;
    _btn_toLearn.layer.cornerRadius = 3;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction) toLearnAction:(id)sender {
    
    //[self pushToMoocVideoPage];
    int tag = (int) [sender tag];
    
    if(tag == 0) {
        
        if(_userName != nil && _userName.length != 0) {
            
            NSDictionary *para = @{@"UserName":_userName, @"Id":_entity2.Id};
            
//            [_AFNManager POST:URL_OFFLINE_COURSE_SIGN parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                
//                BOOL success = [dic[@"State"] integerValue] == 1;
//                
//                if (success) {
//                    
//                    [self setSignInBtnState:YES];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_USERSTATE_CHANGE object:nil];
//                    
//                } else {
//                    
//                    
//                }
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                
//                
//            }];
        } else {
            
//            LoginViewController *loginController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"login_page_vc"];
//            loginController.parentVc = _parentVController;
//            
//            CATransition *animation = [CATransition animation];
//            animation.duration = 0.5;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//            animation.type = kCATransitionPush;
//            animation.subtype = kCATransitionFromRight;
//            
//            [_parentVController.view.window.layer addAnimation:animation forKey:nil];
//            [_parentVController presentViewController:loginController animated:NO completion:nil];
            
        }
        
    } else if(tag == 1) {
        
        [self pushToOfflineVideoPage];
    }
    
}

- (void) pushToOfflineVideoPage {
    
    UIStoryboard* storyboard =
    [UIStoryboard storyboardWithName:@"video_page3" bundle:[NSBundle mainBundle]];
    
    VideoPageFaceCourse2 *faceCourse = (VideoPageFaceCourse2 *)[storyboard instantiateViewControllerWithIdentifier:@"video_page_controller_mooc2"];
    faceCourse.teacherDesc = _entity2.TeacherDescription;
    faceCourse.picUrl = _entity2.Pic;
    faceCourse.topTitle = _entity2.Name;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    faceCourse.parentVc = _parentVController;
    [_parentVController.view.window.layer addAnimation:animation forKey:nil];
    [_parentVController presentViewController:faceCourse animated:NO completion:nil];
}

//- (void) pushToMoocVideoPage {
//    
//    UIStoryboard* storyboard =
//    [UIStoryboard storyboardWithName:@"video_page2" bundle:[NSBundle mainBundle]];
//    
//    VideoPageFaceCourse *faceCourse = (VideoPageFaceCourse *)[storyboard instantiateViewControllerWithIdentifier:@"video_page_controller_mooc"];
//    faceCourse.teacherModel = teacher;
//    faceCourse.courseDesc = _entity.Description;
//    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.1;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromRight;
//    
//    faceCourse.parentVc = _parentVController;
//    [_parentVController.view.window.layer addAnimation:animation forKey:nil];
//    [_parentVController presentViewController:faceCourse animated:NO completion:nil];
//    
//}


@end
