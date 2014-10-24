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
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*381/1080.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_headView.frame];
        [imageView setImage:[UIImage imageNamed:@"OrderHeader"]];
        [_headView addSubview:imageView];
    }
    return _headView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //更改右上button 城市titile
    NSString *rightBtnTitle;
    if ([HbhUser sharedHbhUser].isLogin && [HbhUser sharedHbhUser].currentArea) { //登陆状态
        rightBtnTitle = [HbhUser sharedHbhUser].currentArea.name;
    }else if([HbuAreaLocationManager sharedManager].currentAreas){ //未登录
        rightBtnTitle = [HbuAreaLocationManager sharedManager].currentAreas.name;
    }else{
        rightBtnTitle = @"城市";
    }
<<<<<<< Updated upstream
    [self setRightButton:nil title:rightBtnTitle target:self action:@selector(showSelCityVC)];

    MLOG(@"navgationBarHeight=%f",self.navigationController.navigationBar.frame.size.height);
    //self.title = @"预约";
    [self settitleLabel:@"预约"];
=======
    [self.rightButton setTitle:rightBtnTitle forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton:nil title:@"left" target:self action:@selector(showLeftView)];
    
    //右侧button
    [self setRightButton:nil title:@"城市" target:self action:@selector(showSelCityVC)];
    
    self.title = @"预约";
>>>>>>> Stashed changes
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-49-64) style:UITableViewStyleGrouped];
    MLOG(@"%lf",self.tableView.height);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HbhFirstVCCell class] forCellReuseIdentifier:@"FirstVCCell"];
    
    //定位相关
    _areaLocationManager = [HbuAreaLocationManager sharedManager];
    [self.areaLocationManager getAreasDataAndSaveToDBifNeeded];

    //定位处理
    __weak FirstViewController *weakSelf = self;
    [self.areaLocationManager getUserLocationWithSuccess:^{
        [weakSelf setRightButton:nil title:[HbuAreaLocationManager sharedManager].currentAreas.name target:self action:@selector(showSelCityVC)];
        
    } Fail:^(NSString *failString) {
        if (![weakSelf isHaveUserOldAreaCheck]){
            [SVProgressHUD showErrorWithStatus:failString duration:1.2f cover:YES offsetY:kMainScreenHeight/2.0f];
            HbhSelCityViewController *selCityVC = [[HbhSelCityViewController alloc] init];
            selCityVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:selCityVC animated:YES];
        }
    }];
}

- (void)showLeftView
{
    [ViewInteraction viewPresentAnimationFromLeft:self.view toView:[[LeftView alloc] init]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headView.height;
    
}



#pragma mark headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headView;
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
    
    NSDictionary *leftCategory = self.allCategoryInfo[indexPath.row*2];
    [cell.leftImageButton setImage:[UIImage imageNamed:leftCategory[@"image"]] forState:UIControlStateNormal];
    [cell.leftImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)showSelCityVC
{
    HbhSelCityViewController *selCityVC = [[HbhSelCityViewController alloc] init];
    selCityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selCityVC animated:YES];
}

#pragma mark 点击图片button进入对应type页面
- (void)touchImageButton:(UIButton *)sender
{
    if (sender.tag != kBlankButtonTag) {
        [self.navigationController pushViewController:[[HbuCategoryViewController alloc] initWithCateId:sender.tag] animated:YES];
    }
}


#pragma 检查用户模型中是否有定位/手选 的地区
- (BOOL)isHaveUserOldAreaCheck
{
    if ([HbhUser sharedHbhUser].isLogin) {
        return  ([HbhUser sharedHbhUser].currentArea ? YES:NO);
    }
    return NO;
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
