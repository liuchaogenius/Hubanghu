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
@interface HuhAppointmentVC ()<controlPriceDelegate>
{
    NSString *strNavtitle;
    NSString *strCateId;
    HbhWorkers *workerModel;
    NSString *strInstallDesc;
    AmountDesc amounttype;
    
    UIScrollView *scrollview;
    //HbhAppointmentNetManager *manager;
    HubInstallDesView *installDesView; //top描述
    HubControlPriceView *controlPriceView; //price相关部分
    HubAppointUserInfoView *userInfoView; //用户信息部分
    UIToolbar *toolBarView;//下方确认页面
    
    UILabel *_totalPriceLabel;
}
@property(strong, nonatomic) HbhAppointmentNetManager *manager;

@end

@implementation HuhAppointmentVC

#pragma mark - getter and setter
- (HbhAppointmentNetManager *)manager
{
    if (!_manager) {
        _manager = [[HbhAppointmentNetManager alloc] init];
    }
    return _manager;
}

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
    self.view.backgroundColor = [UIColor whiteColor];
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-65)];
    scrollview.contentSize = CGSizeMake(kMainScreenWidth, kMainScreenHeight + 100);
    [self.view addSubview:scrollview];
    scrollview.backgroundColor = RGBCOLOR(249, 249, 249);
    
    [self createHeadInstallDesView];
    [self getAppointInfo];
    [self creatControlPriceView];
    [self creatUserInfoView];
    [self creatToolBarView];
}

- (void)getAppointInfo
{
    if(strCateId)
    {
        [self.manager getAppointmentInfoWith:strCateId succ:^(NSDictionary *succDic) {
            strInstallDesc = [succDic objectForKey:@"desc"];
            amounttype = [[succDic objectForKey:@"amountType"] intValue];
            
            [installDesView setContent:strInstallDesc];
            [controlPriceView setCountType:amounttype];
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
    if (worker) {
        workerModel = worker;
    }
}

#pragma mark 构造页面
- (void)createHeadInstallDesView
{
    if(!installDesView)
    {
        installDesView = [[HubInstallDesView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 65)];
        [scrollview addSubview:installDesView];
    }
}

- (void)creatControlPriceView
{
    if (!controlPriceView) {
        controlPriceView = [[HubControlPriceView alloc] initWithFrame:CGRectMake(0, installDesView.bottom+10, kMainScreenWidth, 200.0)];
        [controlPriceView setCateId:strCateId];
        controlPriceView.delegate = self;
        [scrollview addSubview:controlPriceView];
    }
}


- (void)creatUserInfoView
{
    if (!userInfoView) {
        userInfoView = [[HubAppointUserInfoView alloc] initWithFrame:CGRectMake(0, controlPriceView.bottom+20, kMainScreenWidth, 260)];
        [scrollview addSubview:userInfoView];
    }
}

- (void)creatToolBarView
{
    if (!toolBarView) {
        toolBarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-65.0-64.0, kMainScreenWidth, 65)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-30-100, 2, 30, 25)];
        titleLabel.text = @"合计:";
        titleLabel.font = kFont12;
        titleLabel.textColor = KColor;
        [toolBarView addSubview:titleLabel];
        
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, 5, 100, 16)];
        totalPriceLabel.textColor = KColor;
        totalPriceLabel.text = @"￥0.00";
        _totalPriceLabel = totalPriceLabel;
        [toolBarView addSubview:totalPriceLabel];
        
        UIButton *selectWorkerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectWorkerBtn setFrame:CGRectMake(10, 25, (kMainScreenWidth-20-20)/2.0, 30)];
        [selectWorkerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectWorkerBtn setBackgroundColor:KColor];
        [selectWorkerBtn addTarget:self action:@selector(touchSelectWorkerBtn) forControlEvents:UIControlEventTouchUpInside];
        [selectWorkerBtn setTitle:@"选师傅" forState:UIControlStateNormal];
        [toolBarView addSubview:selectWorkerBtn];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setFrame:CGRectMake(kMainScreenWidth-10-(kMainScreenWidth-20-20)/2.0, 25, (kMainScreenWidth-20-20)/2.0, 30)];
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderBtn.backgroundColor = KColor;
        [orderBtn addTarget:self action:@selector(touchOrderBtn) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setTitle:@"预约" forState:UIControlStateNormal];
        [toolBarView addSubview:orderBtn];
        
        //toolBarView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:toolBarView];
    }
    
}

#pragma mark - action
- (void)touchSelectWorkerBtn
{
    
}

- (void)touchOrderBtn
{
    
}

#pragma mark - delegate
#pragma mark 价格改动 
- (void)priceChangedWithPrice:(NSString *)price
{
    if (price) {
        _totalPriceLabel.text = [NSString stringWithFormat:@"￥%@",price];
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
