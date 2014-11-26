//
//  FourthViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FourthViewController.h"
#import "FourthVCHeadView.h"
#import "HbhUser.h"
#import "HbhLoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HbhUserManager.h"
#import "HbhQRcodeViewController.h"
#import "HbhChangePswViewController.h"
#import "ThirdViewController.h"
#import "HbhModifyUserDetailViewController.h"

#define KSetionNumber 5
#define kcornerRadius 4
#define kHeaderHeight 114
#define kNumberLabelTag 55
#define kaImageViewTag 56
#define klabelTag 57

enum CellTag_Type
{
    CellTag_finishedOrder = 50,//已完成订单
    CellTag_notDoneOrder, //未完成订单
    CellTag_notCommentOrder,//待评价订单
    CellTag_QRcode,//二维码
    CellTag_changePassWord,//修改密码
};

@interface FourthViewController ()
{
    UILabel *_numberLabel; // cell右方提示数量的label
    UILabel *_notCommentNumberLabel;//待评价订单 提示数量label
    UILabel *_notDoneNumberLabel;//未完成订单 提示数量label
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *listArray; //页面列表数据
@property (strong, nonatomic) FourthVCHeadView *fHeadView;//用户信息headerView
@property (strong, nonatomic) UIView *logOutHeadView;//附退出登陆按钮 headerView

@end

@implementation FourthViewController

#pragma mark - getter and setter
- (NSArray *)listArray
{
    if (!_listArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FouthVCList" ofType:@"plist"];
        _listArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _listArray;
}

- (FourthVCHeadView *)fHeadView
{
    if (!_fHeadView) {
        FourthVCHeadView *view = [[FourthVCHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kHeaderHeight)];
        [view.loginButton addTarget:self action:@selector(touchLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _fHeadView = view;
    }
    return _fHeadView;
}

- (UIView *)logOutHeadView
{
    if (!_logOutHeadView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 35)];
        view.backgroundColor = [UIColor clearColor];
        //添加返回按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kMainScreenWidth-40.0, 35)];//[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(20, 0, kMainScreenWidth-40.0, 35)];
        button.backgroundColor = kIconSelectColor;
        [button addTarget:self action:@selector(touchLogoutButton) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        button.layer.cornerRadius = kcornerRadius;
        [view addSubview:button];
        _logOutHeadView = view;
    }
    return _logOutHeadView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //待完善刷新时机
    if ([HbhUser sharedHbhUser].isLogin) {
        [self refreshNumberLabels];
        if ([HbhUser sharedHbhUser].statusIsChanged) {
            [HbhUser sharedHbhUser].statusIsChanged = NO;
            [self loadUserPhoto];
            self.fHeadView.nickNameLabel.text = [HbhUser sharedHbhUser].nickName;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settitleLabel:@"我的"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-49-64) style:UITableViewStylePlain];
    tableView.backgroundColor = RGBCOLOR(249, 249, 249);
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundView = nil;
    tableView.tableHeaderView = self.fHeadView;
    [self setExtraCellLineHidden:self.tableView]; //隐藏多需的cell线
    [self updateUserHeadView];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = kViewBackgroundColor;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 数据源方法

#pragma mark Section Number
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count +2;//增加第一个head的section和最后退出登录的section
}

#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0||section == self.listArray.count+1) {//头像section 与 退出登录的section
        return 0;
    }else{
        NSArray *array = self.listArray[section-1];
        return array.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == self.listArray.count+1){
        return 35;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == self.listArray.count) return 10;
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        
//        HbhUser *user = [HbhUser sharedHbhUser];
//        if (user.isLogin) {
//            
//            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeadView)];
//            [self.fHeadView addGestureRecognizer:tapRecognizer];
//            
//            self.fHeadView.hasLoginView.hidden = NO;
//            self.fHeadView.notLoginView.hidden = YES;
//            self.fHeadView.nickNameLabel.text = user.nickName;
//            self.fHeadView.pointLabel.text = [NSString stringWithFormat:@"积分：%ld",(long)user.point];
////            [self.fHeadView.photoImageView setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto"]];
//            [self loadUserPhoto];
//            [self.fHeadView.changePhotoButton addTarget:self action:@selector(touchModifyUserDetail) forControlEvents:UIControlEventTouchUpInside];
//        }
//        self.fHeadView.hasLoginView.hidden = (user.isLogin ? NO:YES);
//        self.fHeadView.notLoginView.hidden = (user.isLogin ? YES:NO);
//        return self.fHeadView;
//        
//    }else
    if(section == self.listArray.count+1){
        self.logOutHeadView.hidden = ([HbhUser sharedHbhUser].isLogin ? NO : YES);
        
        return self.logOutHeadView;
    }else{
        return nil;
    }
}

- (void)updateUserHeadView
{
    HbhUser *user = [HbhUser sharedHbhUser];
    if (user.isLogin) {
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeadView)];
        [self.fHeadView addGestureRecognizer:tapRecognizer];
        
        self.fHeadView.hasLoginView.hidden = NO;
        self.fHeadView.notLoginView.hidden = YES;
        self.fHeadView.nickNameLabel.text = user.nickName;
        self.fHeadView.pointLabel.text = [NSString stringWithFormat:@"积分：%ld",(long)user.point];
        //            [self.fHeadView.photoImageView setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto"]];
        [self loadUserPhoto];
        [self.fHeadView.changePhotoButton addTarget:self action:@selector(touchModifyUserDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    self.fHeadView.hasLoginView.hidden = (user.isLogin ? NO:YES);
    self.fHeadView.notLoginView.hidden = (user.isLogin ? YES:NO);
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *HeadcellIdentifier = @"HeadCell";
    static NSString *cellIdentifier = @"cell";
    //static NSString *logoutCellIdentifier = @"logoutCell";
    
    if (indexPath.section == 0 || indexPath.section == self.listArray.count+1) { //第一个与最后一个section只使用header
        return nil;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            //图片
            UIImageView *aImageView = nil;
            aImageView = [[UIImageView alloc] init];
            if(kSystemVersion<7.0)
            {
                [aImageView setFrame:CGRectMake(20, (cell.height-25)/2.0, 22, 25)];
            }
            else
            {
                [aImageView setFrame:CGRectMake(10, (cell.height-25)/2.0, 22, 25)];
            }
            aImageView.tag = kaImageViewTag;
            [cell addSubview:aImageView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //显示文字的label
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kMainScreenWidth-40, cell.height)];
            //[label setTextAlignment:UITextAlignmentLeft];
            [label setFont:kFont13];
            label.tag = klabelTag;
            label.backgroundColor = kClearColor;
            [cell.contentView addSubview:label];
            
            //显示数量的label
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-40-20, cell.frame.size.height/2.0-7.5, 20, 15)];
            numberLabel.layer.cornerRadius = 2.0f;
            [numberLabel setTextAlignment:NSTextAlignmentCenter];
            numberLabel.font = kFont12;
            numberLabel.layer.masksToBounds = YES;
            numberLabel.backgroundColor = kIconSelectColor;
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.tag = kNumberLabelTag;
            _numberLabel = numberLabel;
            [cell.contentView addSubview:numberLabel];
        }
        NSArray *array = self.listArray[indexPath.section-1];
        NSDictionary *dic = array[indexPath.row];
        _numberLabel = (UILabel *)[cell viewWithTag:kNumberLabelTag];
        _numberLabel.hidden = YES;
        NSInteger typeTag = [dic[@"typeTag"] integerValue];//通过tag区分cell功能
        cell.tag = typeTag;
        switch (typeTag) {
            case CellTag_notCommentOrder:
            {
                _notCommentNumberLabel = _numberLabel;
    
            }
                break;
            case CellTag_notDoneOrder:
            {
                _notDoneNumberLabel = _numberLabel;
            }
                break;
            default:
                break;
        }
        UIImageView *aImageView = (UIImageView *)[cell viewWithTag:kaImageViewTag];
        aImageView.image = [UIImage imageNamed:dic[@"image"]];
        UILabel *textLabel = (UILabel *)[cell viewWithTag:klabelTag];
        textLabel.text = dic[@"name"];
        //cell.textLabel.text = dic[@"name"];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return cell;
    }
    
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![HbhUser sharedHbhUser].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginForUserMessage object:[NSNumber numberWithBool:NO]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:nil name:kLoginSuccessMessae object:nil];
    }else{
        switch ([tableView cellForRowAtIndexPath:indexPath].tag) {
            case CellTag_finishedOrder:
            {
                //push进入已完成订单页面
                ThirdViewController *thirdVC = [[ThirdViewController alloc] initWithCurrentTab:0];
                thirdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:thirdVC animated:YES];
            }
                break;
            case CellTag_notDoneOrder:
            {
                //push进入未完成订单页面
                ThirdViewController *thirdVC = [[ThirdViewController alloc] initWithCurrentTab:1];
                thirdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:thirdVC animated:YES];
            }
                break;
            case CellTag_notCommentOrder:
            {
                //push进入未提交订单页面
                ThirdViewController *thirdVC = [[ThirdViewController alloc] initWithCurrentTab:2];
                thirdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:thirdVC animated:YES];
            }
                break;
            case CellTag_QRcode:
            {
                //push进入二维码页面
                HbhQRcodeViewController *qrVC = [[HbhQRcodeViewController alloc] init];
                qrVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:qrVC animated:YES];
            }
                break;
            case CellTag_changePassWord:
            {
                //push进入修改密码页面
                HbhChangePswViewController *cpswVC = [[HbhChangePswViewController alloc] init];
                cpswVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cpswVC animated:YES];
                break;
            }
                break;
            default:
                break;
        }
    }
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma amrk 刷新订单等提示数字
- (void)refreshNumberLabels
{
    if ([HbhUser sharedHbhUser].isLogin) {
        [HbhUserManager profileRevalWithSuccess:^(int notDone, int notComment) {
            if(_notDoneNumberLabel && notDone){
                _notDoneNumberLabel.text = [NSString stringWithFormat:@"%d",notDone];
                _notDoneNumberLabel.hidden = NO;
            }
            if(_notCommentNumberLabel && notComment){
                _notCommentNumberLabel.text = [NSString stringWithFormat:@"%d",notComment];
                _notCommentNumberLabel.hidden = NO;
            }
        } failure:nil];
    }
}

#pragma mark - Action
#pragma mark 点击登录按钮
- (void)touchLoginButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginForUserMessage object:[NSNumber numberWithBool:NO]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessItem) name:kLoginSuccessMessae object:nil];
}

#pragma mark 登录成功返回调用方法
- (void)loginSuccessItem
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessMessae object:nil];
    [self updateUserHeadView];
    [self.tableView reloadData];
}

#pragma mark 点击退出登陆按钮
- (void)touchLogoutButton
{
    [[HbhUser sharedHbhUser] logoutUser];
    [self updateUserHeadView];
    [self.tableView reloadData];
}

#pragma mark 点击headView,用户信息/登陆_注册
- (void)touchHeadView
{
    if ([HbhUser sharedHbhUser].isLogin) { //进入修改用户信息界面
        [self touchModifyUserDetail];
    }else{
        [self touchLoginButton];
    }
}


#pragma mark 点击进入修改头像页面
- (void)touchModifyUserDetail
{
    HbhModifyUserDetailViewController *vc = [[HbhModifyUserDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 载入头像
- (void)loadUserPhoto
{
    HbhUser *user = [HbhUser sharedHbhUser];
    if (user.localPhoto && user.localPhoto.length > 3) {
        NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = storeFilePath[0];
        NSString *localPhotoUrl = [docPath stringByAppendingPathComponent:user.localPhoto];

        self.fHeadView.photoImageView.image = [UIImage imageWithContentsOfFile:localPhotoUrl];
    }else{
        [self.fHeadView.photoImageView setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto"]];
    }
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
