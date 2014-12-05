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
#import "HuhAppointmentVC.h"
#import "HbhBanners.h"
#import "HbhFirstPageManager.h"
#import "IntroduceViewController.h"
#import "UIImageView+WebCache.h"
#import "SImageUtil.h"
#define kBlankButtonTag 149 //当cate数量为奇数时，空白button的tag值
#define KimageHeight kMainScreenWidth*381/1080.0f+kBlankWidth


@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UILabel *_rightBtnLabel;
}
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray *allCategoryInfo;//所有预约类型info数组
@property (strong, nonatomic) UIView *headView; //headView
@property (weak, nonatomic) UIPageControl *pageControl; //分页
@property (strong, nonatomic) UIScrollView *headScrollView;
@property (strong, nonatomic) UIView *headAdView; //顶部广告view
@property (strong, nonatomic) NSMutableArray *bannersArray;//banner数组
@property (strong, nonatomic) HbuAreaLocationManager *areaLocationManager;
@property (strong, nonatomic) HbuAreaListModelBaseClass *areaListModel;
@property (strong, nonatomic) HbhFirstPageManager *fpManager;

@end

@implementation FirstViewController

#pragma mark - getter and setter
- (HbhFirstPageManager *)fpManager
{
    if (!_fpManager) {
        _fpManager = [[HbhFirstPageManager alloc] init];
    }
    return _fpManager;
}

- (NSArray *)allCategoryInfo
{
    if (!_allCategoryInfo) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HbhAllCategory" ofType:@"plist"];
        _allCategoryInfo = [NSArray arrayWithContentsOfFile:path];
    }
    return _allCategoryInfo;
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
    [self creatLeftButton];
    //[self setLeftButton:[UIImage imageNamed:@"leftButtonBg"] title:@"" target:self action:@selector(showLeftView)];
    //self.leftButton.frame = CGRectMake(self.leftButton.frame.origin.x, self.leftButton.frame.origin.y, 60, 60);
    
    [self creatRightBtn];
    //[self setRightButton:nil title:@"城市" target:self action:@selector(showSelCityVC)];
    [self settitleLabel:@"户帮户"];
    UIImage *img = [SImageUtil imageWithColor:RGBCOLOR(234, 234, 234) size:CGSizeMake(10, 10)];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64-49) style:UITableViewStylePlain];
    MLOG(@"%lf",self.tableView.height);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HbhFirstVCCell class] forCellReuseIdentifier:@"FirstVCCell"];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:img];//[UIColor whiteColor];
    //定位
    [self localtion];
    //顶部ad
    [self creatAdView];
    self.tableView.tableHeaderView = self.headAdView;
    [self loadBanners];
    
}
#pragma mark 定位处理
- (void)localtion
{
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
            alertView.tag = (self.areaLocationManager.currentAreas ? errorType_hadData_notOpService : errorType_notOpenService);
            [alertView show];
        }else if (errorType == errorType_matchCityFailed || errorType == errorType_hadData_matchCfail){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"城市尚未开通" message:failString delegate:self cancelButtonTitle:@"选择其他城市" otherButtonTitles:@"知道了", nil];
            alertView.tag = errorType_matchCityFailed;
            [alertView show];
        }else{
            [SVProgressHUD showErrorWithStatus:@"定位失败,请检查网络" cover:YES offsetY:0];
        }
    }];

}

#pragma mark 顶部广告网络请求
- (void)loadBanners
{
    __weak FirstViewController *weakself = self;
    [self.fpManager getBannersWithSucc:^(NSMutableArray *succArray) {
        weakself.bannersArray = succArray;
        [weakself refreshAddViewWithImageNum:weakself.bannersArray.count];
    } failure:^{
        
    }];
}

//顶部浮动广告view
- (void)creatAdView
{
    UIView *headAdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KimageHeight)];
    headAdView.backgroundColor = [UIColor whiteColor];
    _headAdView = headAdView;
    
    UITapGestureRecognizer *tapgz = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBanners)];
    [headAdView addGestureRecognizer:tapgz];
    
    UIScrollView *headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*381/1080.0f+kBlankWidth)];
    [headScrollView setBounces:NO];
    headScrollView.backgroundColor = [UIColor whiteColor];
    [headScrollView setShowsHorizontalScrollIndicator:NO];
    [headScrollView setContentSize:CGSizeMake(kMainScreenWidth, KimageHeight)];
    headScrollView.delegate = self;
    [headAdView addSubview:headScrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, KimageHeight)];
    //设置image
    imageView.image = [UIImage imageNamed:@"OrderHeader"];
    [headScrollView addSubview:imageView];
    imageView.backgroundColor = RGBCOLOR(58, 155, 9);
    [headScrollView setPagingEnabled:YES];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setBounds:CGRectMake(0, 0, 150.0, 50.0)];
    [pageControl setBounds:CGRectMake(0, 0, 150.0, 50.0)];
    [pageControl setCenter:CGPointMake(kMainScreenWidth/2, KimageHeight - 10)];
    [pageControl setNumberOfPages:1];
    [pageControl setCurrentPage:0];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setPageIndicatorTintColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:0.8]];
    [_headAdView addSubview:pageControl];
    self.pageControl = pageControl;
    self.headScrollView = headScrollView;
}

//载入banners的网络数据
- (void)refreshAddViewWithImageNum:(NSInteger)imageNum
{
    [self.headScrollView setContentSize:CGSizeMake(imageNum * kMainScreenWidth, KimageHeight)];
    
    for (NSInteger i = 0; i < imageNum; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kMainScreenWidth, 0, kMainScreenWidth, KimageHeight)];
        imageView.backgroundColor = [UIColor whiteColor];
        HbhBanners *banner = self.bannersArray[i];
        //设置image
        [imageView sd_setImageWithURL:[NSURL URLWithString:banner.bannerImg]];
        [self.headScrollView addSubview:imageView];
        imageView.tag = i;
    }
    [self.pageControl setNumberOfPages:imageNum];
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
#pragma mark 点击head的Banner 广告
- (void)touchBanners
{
    NSInteger number = self.pageControl.currentPage;
    if (number < self.bannersArray.count) {
        HbhBanners *banner = self.bannersArray[number];
        IntroduceViewController *iVC = [[IntroduceViewController alloc] init];
        iVC.isSysPush = YES;
        iVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:iVC animated:YES];
        [iVC setUrl:banner.bannerHref title:banner.bannerText];
    }
}

#pragma mark 点击图片button进入对应type页面
- (void)touchImageButton:(UIButton *)sender
{
//    if (sender.tag == CateId_renovate) { //二次翻新
//        HuhAppointmentVC *appointVC = [[HuhAppointmentVC alloc] init];
//        appointVC.hidesBottomBarWhenPushed = YES;
//        [appointVC setCustomedVCofRenovateWithCateId:[NSString stringWithFormat:@"%d",sender.tag]];
//        [self.navigationController pushViewController:appointVC animated:YES];
//    }else
//    if (sender.tag == CateId_niceWorker){
//        self.tabBarController.selectedIndex = 1;
//    }else
    if (sender.tag != kBlankButtonTag)
    {
        [self.navigationController pushViewController:[[HbuCategoryViewController alloc] initWithCateId:sender.tag] animated:YES];
    }
}

#pragma mark -alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == errorType_notOpenService) {
        if (buttonIndex == 0) {
            [self showSelCityVC];
        }
    }else if (alertView.tag == errorType_matchCityFailed){
        if (buttonIndex == 0) {
            [self showSelCityVC];
        }
    }
    
}

#pragma mark scrollView delegat
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNo = scrollView.contentOffset.x / kMainScreenWidth;
    [self.pageControl setCurrentPage:pageNo];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)creatLeftButton
{
    CGRect buttonFrame = CGRectMake(0, 0, 48, 44);
    CGRect viewFrame = CGRectMake(-5, 0, 48, 44);
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    
    UIButton *button = [[UIButton alloc] initWithFrame:viewFrame];
    [button addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = kClearColor;
    //[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:buttonFrame];
    [imgview setImage:[UIImage imageNamed:@"leftButtonBg"]];
    [view addSubview:imgview];
    [view addSubview:button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
}

@end
