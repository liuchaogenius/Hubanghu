//
//  FirstViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FirstViewController.h"
#import "HbhFirstVCCell.h"
#import "HbuCategoryViewController.h"
#import "HbuAreaListModelBaseClass.h"
#import "HbuAreaLocationManager.h"
#import "LeftView.h"
#import "ViewInteraction.h"
#import "SVProgressHUD.h"
#import "HbhUser.h"
#import "HbhSelCityViewController.h"

#define kBlankButtonTag 149 //当cate数量为奇数时，空白button的tag值
enum CateId_Type
{
    CateId_floor = 1,//地板
    CateId_bathroom,//卫浴
    CateId_light,//灯饰
    CateId_wallpaper,//墙纸
    CateId_renovate//二次翻新
};

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_rightBtnLabel;
}
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray *allCategoryInfo;//所有预约类型info数组
@property (strong, nonatomic) UIView *headView; //headView
@property (strong, nonatomic) HbuAreaLocationManager *areaLocationManager;
@property (strong, nonatomic) HbuAreaListModelBaseClass *areaListModel;

@end

@implementation FirstViewController

#pragma mark - getter and setter
- (NSArray *)allCategoryInfo
{
    if (!_allCategoryInfo) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HbhAllCategory" ofType:@"plist"];
        _allCategoryInfo = [NSArray arrayWithContentsOfFile:path];
    }
    return _allCategoryInfo;
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*381/1080.0f+kBlankWidth) ];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headView.width, _headView.height)];
        [imageView setImage:[UIImage imageNamed:@"OrderHeader"]];
        [_headView addSubview:imageView];
    }
    return _headView;
}

- (HbuAreaLocationManager *)areaLocationManager
{
    if (!_areaLocationManager) {
        _areaLocationManager = [HbuAreaLocationManager sharedManager];
    }
    return _areaLocationManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //更改右上button 城市titile
    NSString *rightBtnTitle = (self.areaLocationManager.currentAreas.name.length ?
                               self.areaLocationManager.currentAreas.name : @"城市");
    _rightBtnLabel.text = rightBtnTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton:[UIImage imageNamed:@"leftButtonBg"] title:@"" target:self action:@selector(showLeftView)];
    [self creatRightBtn];
    //[self setRightButton:nil title:@"城市" target:self action:@selector(showSelCityVC)];
    [self settitleLabel:@"户帮户"];
    self.view.backgroundColor = kViewBackgroundColor;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49) style:UITableViewStylePlain];
    MLOG(@"%lf",self.tableView.height);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HbhFirstVCCell class] forCellReuseIdentifier:@"FirstVCCell"];
    self.tableView.backgroundColor = kViewBackgroundColor;//[UIColor whiteColor];
    //self.tableView.bounces = NO;
    self.tableView.tableHeaderView = self.headView;
    //定位相关
    _areaLocationManager = [HbuAreaLocationManager sharedManager];
    [self.areaLocationManager getAreasDataAndSaveToDBifNeeded];

    //定位处理
    __weak FirstViewController *weakSelf = self;
    [self.areaLocationManager getUserLocationWithSuccess:^{
        _rightBtnLabel.text = weakSelf.areaLocationManager.currentAreas.name;
        //weakSelf.rightButton.titleLabel.text = weakSelf.areaLocationManager.currentAreas.name;
    } Fail:^(NSString *failString, int errorType) {
        if (errorType == errorType_notOpenService) { //未开启定位服务
            //区分是否有之前的定位城市
            NSString *cancelButtonTiltle = (weakSelf.areaLocationManager.currentAreas ? @"知道了":@"手动选择城市");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置->隐私->定位服务->开启互帮互）" delegate:self cancelButtonTitle:cancelButtonTiltle otherButtonTitles:nil, nil];
            alertView.tag = (self.areaLocationManager.currentAreas ? 1 : 2);
            [alertView show];
        }else if(errorType == errorType_locationFailed || errorType == errorType_matchCityFailed){
            [self showSelCityVC];
            [SVProgressHUD showErrorWithStatus:failString cover:YES offsetY:kMainScreenHeight/2.0];
        }
    }];
}

#pragma mark 创建navigation右侧button
- (void)creatRightBtn
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(showSelCityVC) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = rightView.frame;
    [rightView addSubview:rightButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, (44-14)/2.0, 60-14, 14)];
    title.textAlignment = NSTextAlignmentRight;
    title.backgroundColor = [UIColor clearColor];
    title.font = kFont14;
    title.textColor = [UIColor whiteColor];
    title.text = @"城市";
    _rightBtnLabel = title;
    [rightView addSubview:title];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(title.right+4, 0, 10, 6)];
    imageView.centerY = title.centerY;
    imageView.image = [UIImage imageNamed:@"downArrow"];
    [rightView addSubview:imageView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)showLeftView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeftViewPushMessage object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据源方法

#pragma mark Section Number
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allCategoryInfo.count/2 + self.allCategoryInfo.count%2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FirstVCCell";
    HbhFirstVCCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *leftCategory = self.allCategoryInfo[indexPath.row*2];
    [cell.leftImageButton setImage:[UIImage imageNamed:leftCategory[@"image"]] forState:UIControlStateNormal];
    if (![cell respondsToSelector:@selector(touchImageButton:)]) {
        [cell.leftImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.leftImageButton.tag = [leftCategory[@"cateId"] doubleValue];
    
    //当category总数为奇数个时，最后一排右侧部分处理
    if (self.allCategoryInfo.count%2 && ((indexPath.row+1)*2 == self.allCategoryInfo.count+1)) {
        [cell.rightImageButton setImage:nil forState:UIControlStateNormal];
        cell.rightImageButton.tag = kBlankButtonTag; //
    }else{
        NSDictionary *rightCategory = self.allCategoryInfo[indexPath.row*2+1];
        [cell.rightImageButton setImage:[UIImage imageNamed:rightCategory[@"image"]] forState:UIControlStateNormal];
        cell.rightImageButton.tag = [rightCategory[@"cateId"] doubleValue];
    }
    
    [cell.rightImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - Action
#pragma mark show SelCityVC
- (void)showSelCityVC
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelCityMessage object:nil];
}

#pragma mark 点击图片button进入对应type页面
- (void)touchImageButton:(UIButton *)sender
{
    if (sender.tag != kBlankButtonTag) {
        [self.navigationController pushViewController:[[HbuCategoryViewController alloc] initWithCateId:sender.tag] animated:YES];
    }
}

#pragma mark -alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self showSelCityVC];
        }
    }
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
