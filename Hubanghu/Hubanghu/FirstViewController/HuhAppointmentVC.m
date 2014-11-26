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
#import "HbhWorkers.h"
#import "HbhConfirmOrderViewController.h"
#import "SecondViewController.h"
#import "SVProgressHUD.h"
#import "HubOrder.h"
#import "HbhSelCityViewController.h"


typedef NS_ENUM(int, AmountDesc)
{
    E_ACOUNT=1,//数量，面积，长度
    E_AREA,
    E_LENGHT
};
@interface HuhAppointmentVC ()<controlPriceDelegate,appointUserInfoDelegate>
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
    UIView *toolBarView;//下方确认页面
    UIButton *_selectWorkerBtn;
    
    UILabel *_totalPriceLabel;
    BOOL _isRenovate;
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
    scrollview.contentSize = CGSizeMake(kMainScreenWidth, 600);
    [self.view addSubview:scrollview];
    scrollview.backgroundColor = RGBCOLOR(249, 249, 249);
    
    [self createHeadInstallDesView];
    [self getAppointInfo];
    [self creatControlPriceView];
    [self creatUserInfoView];
    [self creatToolBarView];
    
    if(_isRenovate) [controlPriceView customedOfRenovate]; //二次翻新项目页面处理
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
   // #warning 获取失败了提醒用户
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
- (void)setCustomedVCofRenovateWithCateId:(NSString *)cateId //二次翻新的定制方法
{
    strNavtitle = @"二次翻新";
    strCateId = cateId;
    _isRenovate = YES;
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
        controlPriceView = [[HubControlPriceView alloc] initWithFrame:CGRectMake(0, installDesView.bottom+10, kMainScreenWidth, 196.0+40)];
        [controlPriceView setCateId:strCateId];
        controlPriceView.delegate = self;
        [scrollview addSubview:controlPriceView];
    }
}


- (void)creatUserInfoView
{
    if (!userInfoView) {
        userInfoView = [[HubAppointUserInfoView alloc] initWithFrame:CGRectMake(0, controlPriceView.bottom+20, kMainScreenWidth, 260)];
        userInfoView.delegate = self;
    
        [scrollview addSubview:userInfoView];
    }
}

- (void)creatToolBarView
{
    if (!toolBarView) {
        toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-65.0-64.0, kMainScreenWidth, 65)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-40-100, 2, 40, 25)];
        titleLabel.text = @"合计:￥";
        titleLabel.font = kFont12;
        titleLabel.textColor = KColor;
        toolBarView.backgroundColor = [UIColor whiteColor];
        [toolBarView addSubview:titleLabel];
        
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, 5, 100, 16)];
        totalPriceLabel.textColor = KColor;
        totalPriceLabel.text = @"0.00";
        _totalPriceLabel = totalPriceLabel;
        [toolBarView addSubview:totalPriceLabel];
        
        UIButton *selectWorkerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectWorkerBtn setFrame:CGRectMake(10, 25, (kMainScreenWidth-20-20)/2.0, 30)];
        [selectWorkerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectWorkerBtn setBackgroundColor:KColor];
        [selectWorkerBtn addTarget:self action:@selector(touchSelectWorkerBtn) forControlEvents:UIControlEventTouchUpInside];
        [selectWorkerBtn setTitle:@"选师傅" forState:UIControlStateNormal];
        if (workerModel && workerModel.name) {
            [selectWorkerBtn setTitle:workerModel.name forState:UIControlStateNormal];
        }
        [toolBarView addSubview:selectWorkerBtn];
        _selectWorkerBtn = selectWorkerBtn;
        
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
    [self pickWorker];
}

- (void)touchOrderBtn
{
    if ([self infoCheck]) {
        [self submitOrder];
    }
}

//跳转到选择工人列表
- (void)pickWorker{
    SecondViewController *vc = [[SecondViewController alloc] initAndUseWorkerDetailBlock:^(HbhWorkers *aWorkerModel) {
        if (aWorkerModel) {
            workerModel = aWorkerModel;
            [_selectWorkerBtn setTitle:workerModel.name forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 数据完整性检查
- (BOOL)infoCheck
{
    if (![controlPriceView infoCheck]) {
        [SVProgressHUD showErrorWithStatus:@"请输入安装数量(㎡/个/长度)" cover:YES offsetY:kMainScreenHeight/2.0];
        return NO;
    }else if (![userInfoView infoCheck]){
        [SVProgressHUD showErrorWithStatus:@"请输入完整信息" cover:YES offsetY:kMainScreenHeight/2.0];
        return NO;
    }else if ([_totalPriceLabel.text isEqualToString:@"0.00"]){
        [SVProgressHUD showErrorWithStatus:@"价格读取中.." cover:YES offsetY:kMainScreenHeight/2.0];
        return NO;
    }
//    else if (!workerModel)
//    {
//        [SVProgressHUD showErrorWithStatus:@"你还没有选择工人" cover:YES offsetY:kMainScreenHeight/2.0];
//        return NO;
//    }
    else{
        return YES;
    }
}
#pragma mark 提交订单,进入下个页面
- (void)submitOrder
{
    NSDictionary *orderDic = @{@"cateId":strCateId,
                               @"username":[userInfoView getUserName],
                               @"time":[userInfoView getTime],
                               @"amount":[controlPriceView getAmount],
                               //@"workerId":@(workerModel.workersIdentifier),
                               @"mountType":[controlPriceView getCateButtonType],
                               @"amountType":[controlPriceView getMountType],
                               @"comment":[controlPriceView getComment],
                               @"phone":[userInfoView getPhone],
                               @"areaId":[userInfoView getAreaId],
                               @"location":[userInfoView getLocation],
                               @"price":_totalPriceLabel.text,
                               //@"workerName":workerModel.name,
                               @"urgent":[controlPriceView getUrgent],
                               @"name":strNavtitle};
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:orderDic];
    if(workerModel && workerModel.workersIdentifier)
    {
        [mutDict setObject:[NSString stringWithFormat:@"%d",(int)workerModel.workersIdentifier] forKey:@"workerId"];
        if(workerModel.name)
        {
            [mutDict setObject:workerModel.name forKey:@"workerName"];
        }
    }
    HubOrder *order = [[HubOrder alloc] initWithDictionary:mutDict];
    HbhConfirmOrderViewController * covc = [[HbhConfirmOrderViewController alloc] initWithOrder:order];
    [self.navigationController pushViewController:covc animated:YES];
}

#pragma mark - delegate
#pragma mark 价格改动
- (void)priceChangedWithPrice:(NSString *)price
{
    if (price) {
        _totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf",[price doubleValue]];
    }
}

- (void)shouldScrolltoPointY:(CGFloat)pointY
{
    if ((int)pointY == 0) {
        //复原
        CGFloat thFitY = scrollview.contentSize.height - (kMainScreenHeight - toolBarView.height - 64);
        [scrollview setContentOffset:CGPointMake(0, thFitY>0 ? thFitY : 0)];
    }else{
        CGFloat y = 200 +50+ (userInfoView.frame.origin.y + pointY) - (kMainScreenHeight-64);
        CGPoint thePoint = CGPointMake(0, y);
        MLOG(@"%lf %lf",thePoint.x,thePoint.y);
        [scrollview setContentOffset:thePoint animated:YES];
    }
    
//    self.view.frame = CGRectMake(0, (int)pointY ? self.view.frame.origin.y - pointY : 64, self.view.width, self.view.height);
}

#pragma mark resign first resp
- (void)shouldResignAllFirstResponds
{
    [controlPriceView allTextFieldsResignFirstRespond];
}

#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        HbhSelCityViewController *vc = [[HbhSelCityViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 键盘事件
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    if([userInfoView getCurrentTextField])
    {
        self.view.frame = CGRectMake(0, self.view.frame.origin.y - keyboardRect.size.height, self.view.width, self.view.height);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
