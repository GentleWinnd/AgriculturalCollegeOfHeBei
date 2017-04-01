//
//  TribeMemberViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/27.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "TribeMemberViewController.h"
#import "StusCollectionViewCell.h"
#import "SPKitExample.h"
#import "SPUtil.h"

#import "SignedStuView.h"


@interface TribeMemberViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) UICollectionView *stuCollectionView;


@end

static NSString *cellID = @"cellId";

@implementation TribeMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群成员列表";
    
    self.members = [[[self ywTribeService] fetchTribeMembers:self.tribe.tribeId] mutableCopy];
    [self creatCustomCollectioView];
    [self requestData];
}


#pragma mark - 下拉刷新数据

- (void)requestData {
    if (!self.tribe) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.ywTribeService requestTribeMembersFromServer:self.tribe.tribeId completion:^(NSArray *members, NSString *tribeId, NSError *error) {
        if( error == nil ) {
            weakSelf.members = [members mutableCopy];
            [weakSelf.stuCollectionView reloadData];
            
        }
        else {
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"更新群成员列表失败"
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeError];
        }
    }];
}

#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.stuCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layOut];
    self.stuCollectionView.delegate = self;
    self.stuCollectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.stuCollectionView.backgroundColor = [UIColor whiteColor];
    [self.stuCollectionView registerNib:[UINib nibWithNibName:@"StusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.view addSubview:self.stuCollectionView];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    [self configureTribeMemberCell:cell atIndexPath:indexPath requestProfileIfNotExists:YES];
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 0, 1);
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-9)/4;
    return CGSizeMake(width, width);
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)configureTribeMemberCell:(StusCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath requestProfileIfNotExists:(BOOL)requestProfileIfNotExists {
    
    if (!cell) {
        return;
    }
    
    YWTribeMember *tribeMember = [self.members objectAtIndex:(NSUInteger)indexPath.row];
    
    NSString *displayName = nil;
    UIImage *avatar = nil;
    
    __block NSString *cachedDisplayName = nil;
    __block UIImage *cachedAvatar = nil;
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:tribeMember
                                               completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                   cachedDisplayName = aDisplayName;
                                                   cachedAvatar = aAvatarImage;
                                               }];
    displayName = cachedDisplayName;
    avatar = cachedAvatar;
    
    if (tribeMember.nickname.length &&
        ![tribeMember.nickname isEqualToString:tribeMember.personId]) {
        displayName = tribeMember.nickname;
    }
    
    if ((displayName.length == 0 || !avatar) &&
        requestProfileIfNotExists) {  // 未获取到昵称或者头像需要获取个人 Profile
        
        __weak __typeof(self) weakSelf = self;
        YWFetchProfileCompletionBlock completionBlock = ^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
            if (aIsSuccess) {
                NSUInteger index = [weakSelf.members indexOfObject:aPerson];
                if (index != NSNotFound) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
                    StusCollectionViewCell *targetCell = (StusCollectionViewCell * )[weakSelf.stuCollectionView cellForItemAtIndexPath:indexPath];
                    [weakSelf configureTribeMemberCell:targetCell atIndexPath:indexPath requestProfileIfNotExists:NO];
                }
            }
        };
        
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:tribeMember
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      completionBlock(YES, aPerson, aDisplayName, aAvatarImage);
                                                  }
                                                completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                    completionBlock(aIsSuccess, aPerson, aDisplayName, aAvatarImage);
                                                }];
    }
    
    
    if (displayName.length == 0) {
        displayName = tribeMember.personId;
    }
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    cell.stuName.text = displayName;
    cell.headPortriat.image = avatar;
}


#pragma mark -

- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}

- (YWTribeMember *)myTribeMember {
    NSString *myPersonID = [[[self ywIMCore] getLoginService] currentLoginedUserId];
    
    YWTribeMember *myTribeMember = nil;
    for (YWTribeMember *tribeMember in self.members) {
        if ([tribeMember.personId isEqualToString:myPersonID]) {
            myTribeMember = tribeMember;
            break;
        }
    }
    return myTribeMember;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
