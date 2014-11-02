//
//  HuhAppointmentVC.m
//  Hubanghu
//
//  Created by  striveliu on 14-11-1.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HuhAppointmentVC.h"
#import "HbhWorkers.h"
#import "HbhAppointmentNetManager.h"
#import "HubInstallDesView.h"
#import "HubControlPriceView.h"
#import "HubAppointUserInfoView.h"

typedef NS_ENUM(int, AmountDesc)
{
    E_ACOUNT=1,//数量，面积，长度
    E_AREA,
    E_LENGHT
};
@interface HuhAppointmentVC ()
{
    NSString *strNavtitle;
    NSString *strCateId;
    HbhWorkers *workerModel;
    NSString *strInstallDesc;
    AmountDesc amounttype;
    
    UIScrollView *scrollview;
    HbhAppointmentNetManager *manager;
    HubInstallDesView *installDesView;
    HubControlPriceView *controlPriceView;
    HubAppointUserInfoView *userInfoView;
}
@end

@implementation HuhAppointmentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settitleLabel:strNavtitle];
    scrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollview];
}

- (void)getAppointInfo
{
    if(strCateId)
    {
        [manager getAppointmentInfoWith:strCateId succ:^(NSDictionary *succDic) {
            strInstallDesc = [succDic objectForKey:@"desc"];
            amounttype = [[succDic objectForKey:@"amountType"] integerValue];
            //[_activityView stopAnimating];
            //[_tableView reloadData];
        } failure:^{
            //[_activityView stopAnimating];
    #warning 获取失败了提醒用户
        }];
    }
}

- (void)setVCData:(NSString *)title cateId:(NSString *)cateId andWork:(HbhWorkers *)worker
{
    strNavtitle = title;
    strCateId = cateId;
    workerModel = worker;
}

#pragma mark 构造页面
- (void)createHeadInstallDesView
{
    if(!installDesView)
    {
        installDesView = [UILabel alloc];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
