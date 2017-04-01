//
//  StuApprovalInfoTableViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/17.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "StuApprovalInfoTableViewController.h"
#import "ApprovalStateViewController.h"
#import "ApprovalInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SetNavigationItem.h"
#import "NSString+Date.h"



@interface StuApprovalInfoTableViewController ()
{
    NSArray *approvalsArray;
}
@end
static NSString *cellID = @"CellID";
@implementation StuApprovalInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"请假列表" subTitle:@""];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getMineApprovals];
    [self customTableView];
    
}

- (void)getMineApprovals {
    /**
     {
     "CreateDate": "2016-12-16T12:37:25.997",
     "Student": {
     "Id": "717408c9-8bd7-4ccf-a184-d8c375ab2972",
     "UserName": "Student9",
     "FullName": "暂缺"
     },
     "ApprovalUserName": null,
     "ApprovalStatus": 0,
     "ApprovalDate": null,
     "Reason": "生病了，请假",
     "TurndownReason": null,
     "Activity": {
     "Id": "6996789b-7280-4c3b-a003-f5e0741a5033",
     "StartDate": "2016-12-16T16:00:00",
     "EndDate": "2016-12-16T18:00:00",
     "Dependent": {
     "DependentId": "96ea5d28-4f23-47b4-bf8f-7eec67156717",
     "DependentType": "Batch",
     "DependentName": "测试群组1 "
     }
     }
     }
     */
    ///AskLeave/My?AccessToken=773daf60657f4bcaada90e5f5bd968ef
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getMyLeavedInfoListWithParameters:nil success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] integerValue] == 1) {
            approvalsArray = [NSArray safeArray:responseObject[@"AskLeaveModels"]];
            if (approvalsArray.count != 0) {
                [self.tableView reloadData];
            }
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

- (void)customTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ApprovalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return approvalsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *approvalInfo = approvalsArray[indexPath.row];
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSDictionary safeDictionary:approvalInfo[@"Student"]][@"Avatar"]] placeholderImage:[UIImage imageNamed:@"headerPortrait"]];
    cell.stuName.text = [NSDictionary safeDictionary:approvalInfo[@"Student"]][@"FullName"];
    cell.dateLabel.text = [NSString stringFromDate:[NSString dateFromSSSDateString:[NSString safeString:approvalInfo[@"ApprovalDate"]]]];
    cell.approvalReson.text = approvalInfo[@"Reason"];
    cell.agreeBtn.hidden = YES;
    cell.rejectBtn.hidden = YES;
    cell.approvalResult = ^(BOOL agreement){
        
        
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalStateViewController *infoView = [[ApprovalStateViewController alloc] initWithNibName:@"ApprovalStateViewController" bundle:nil];
           infoView.approvalInfo = [approvalsArray objectAtIndex:indexPath.row];
        infoView.approvalId = [approvalsArray  objectAtIndex:indexPath.row][@"Id"];
        infoView.approvalState = YES;
    [self.navigationController pushViewController:infoView animated:YES];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
