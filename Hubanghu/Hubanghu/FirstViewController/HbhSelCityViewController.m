//
//  HbhSelCityViewController.m
//  Hubanghu
//
//  Created by yato_kami on 14/10/20.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhSelCityViewController.h"
#import "HbuAreaLocationManager.h"
#import "HbhHotCityCell.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"
enum kActionSheet_Type
{
    kActionSheet_selectCity = 100
};

enum kHotCity_tag //与xib的cell中的button的tag对应
{
    kHotCity_NanChang = 1,
    kHotCity_ShangHai,
    kHotCity_ShenZheng,
    kHotCity_TianJing,
    kHotCity_GuangZhou,
    kHotCity_XiAn,
    kHotCity_ChengDu,
    kHotCity_HangZhou
};

@interface HbhSelCityViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    HbuAreaListModelAreas *_selectArea;
    UIActivityIndicatorView *_locationIndictorView;
    UILabel *_localCityLable;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) AreasDBManager *areaDBManager;
@property (strong, nonatomic) NSMutableDictionary *cityDict; //地区数组
@property (strong, nonatomic) NSMutableArray *firstCharArray; //首字母数组
@property (strong, nonatomic) NSArray *hotCityName; //热门城市名字数组
@property (strong, nonatomic) UIView *selectorView;//首字母检索view

@end

@implementation HbhSelCityViewController

#pragma mark - getter and setter

- (NSMutableDictionary *)cityDict
{
    if (!_cityDict) {
        [self.areaDBManager selGroupAreaCity:^(NSMutableDictionary *cityDict) {
            _cityDict = cityDict;
            self.firstCharArray = [NSMutableArray arrayWithCapacity:26];
            NSEnumerator *enumerator = [cityDict keyEnumerator];
            for (NSString *str in enumerator) {
                [self.firstCharArray addObject:str];
            }
        }];
    }
    return _cityDict;
}

- (NSArray *)hotCityName
{
    if (!_hotCityName) {
        _hotCityName = @[@"南昌",@"上海",@"深圳",@"天津",@"广州",@"西安",@"成都",@"杭州"];
    }
    return _hotCityName;
}

- (AreasDBManager *)areaDBManager
{
    if (!_areaDBManager) {
        _areaDBManager = [[AreasDBManager alloc] init];
    }
    return _areaDBManager;
}

- (UIView *)selectorView
{
    if (!_selectorView) {
        _selectorView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth -20, 0, 20, kMainScreenHeight-64)];
        //_selectorView.backgroundColor = [UIColor blackColor];
        NSUInteger firstCharCount = self.cityDict.count + 2; //加上定位 热门城市 2个 #与*
        for (int i = 0; i < firstCharCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnHeight = (kMainScreenHeight - 64) / firstCharCount * 1.0;
            [button setFrame:CGRectMake(0, i * btnHeight, 20, btnHeight)];
            [button.titleLabel setFont:kFont11];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitle:@"#" forState:UIControlStateNormal]; //定位城市section
            }else if(i == 1){
                [button setTitle:@"*" forState:UIControlStateNormal]; //热门城市section
            }else{
                [button setTitle:self.firstCharArray[i-2] forState:UIControlStateNormal];
            }
            button.tag = i;
            [button addTarget:self action:@selector(touchFirstChar:) forControlEvents:UIControlEventTouchUpInside];
            [_selectorView addSubview:button];
        }
    }
    return _selectorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectorView];
    
    __weak HbhSelCityViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf refreshData];
        });
    }];
    [self setLeftButton:[UIImage imageNamed:@"back"] title:nil target:self action:@selector(touchBackItem)];
    [self setRightButton:[UIImage imageNamed:@"refresh"] title:nil target:self action:@selector(reLocationUserArea)];
    
    [self setExtraCellLineHidden:self.tableView]; //隐藏多需的cell线
    
    UINib *nib = [UINib nibWithNibName:@"HbhHotCityCell" bundle:[NSBundle mainBundle]];
    //[self.tableView registerClass:[HbhHotCityCell class] forCellReuseIdentifier:@"hCell"];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"hCell"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate datasource 方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityDict.count + 2;
    MLOG(@"number of section = %lu",(unsigned long)self.cityDict.count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"定位城市";
    }else if(section == 1){
        return @"热门城市";
    }else{
        return self.firstCharArray[section - 2];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return hCellHight;
    }else{
        return 40;
    }
}

#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return ((NSArray *)self.cityDict[self.firstCharArray[section - 2]]).count;
    }
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    static NSString *locationCellIdentifier = @"lCell";
    static NSString *hotCellIdentifier = @"hCell";
    
    if (indexPath.section == 0) {
        //定位城市
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCellIdentifier];
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView.center = CGPointMake(kMainScreenWidth - 50, cell.height/2.0f);
            [cell.contentView addSubview:indicatorView];
            _locationIndictorView = indicatorView;
            cell.textLabel.textColor = KColor;
            _localCityLable = cell.textLabel;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.textLabel.text = ([HbuAreaLocationManager sharedManager].currentAreas.name.length ? [HbuAreaLocationManager sharedManager].currentAreas.name : @"定位失败,点击重新定位");
        return cell;
    }else if(indexPath.section == 1){
        HbhHotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCellIdentifier forIndexPath:indexPath];

        if (![((UIButton *)cell.hotCityButtons[0]) respondsToSelector:@selector(touchHotCityButton:)]) {
            for (UIButton *button  in cell.hotCityButtons) {
                [button addTarget:self action:@selector(touchHotCityButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        HbuAreaListModelAreas *area = ((NSArray *)self.cityDict[self.firstCharArray[indexPath.section - 2]])[indexPath.row];
        cell.textLabel.text = area.name;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //定位
        [self reLocationUserArea];
    }else if(indexPath.section == 1){
        //热门城市不做处理
    }else{
        HbuAreaListModelAreas *area = ((NSArray *)self.cityDict[self.firstCharArray[indexPath.section - 2]])[indexPath.row];
        _selectArea = area;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@作为您所在的城市？",area.name] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.tag = kActionSheet_selectCity;
        [actionSheet showInView:self.tableView];
        
        
    }
}

#pragma mark - Action
#pragma mark 点击热门城市中的具体城市
- (void)touchHotCityButton:(UIButton *)sender
{
    //热门城市各个按钮tag从1开始
    [[HbuAreaLocationManager sharedManager].areasDBManager selHbuArealistModel:self.hotCityName[sender.tag-1] resultBlock:^(HbuAreaListModelAreas *model) {
        if (model) {
            _selectArea = model;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@作为您所在的城市？",model.name] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            actionSheet.tag = kActionSheet_selectCity;
            [actionSheet showInView:self.tableView];
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂不支持该城市，选择失败" cover:YES offsetY:kMainScreenHeight/2.0];
        }
    }];
}
//刷新数据
- (void)refreshData
{
    [[HbuAreaLocationManager sharedManager] shouldGetAreasDataAndSaveToDBWithSuccess:^{
        self.firstCharArray = nil;
        self.cityDict = nil;
        [self.selectorView removeFromSuperview];
        self.selectorView = nil;
        [self.tableView reloadData];
        [self.view addSubview:self.selectorView];
        [self reLocationUserArea];

    } Fail:^{
        [SVProgressHUD showErrorWithStatus:@"刷新失败" cover:YES offsetY:kMainScreenHeight/2.0];
    }];
}
//重新定位
- (void)reLocationUserArea
{
    [_locationIndictorView startAnimating];
    [[HbuAreaLocationManager sharedManager] getUserLocationWithSuccess:^{
        [_locationIndictorView stopAnimating];
        _localCityLable.text = [HbuAreaLocationManager sharedManager].currentAreas.name;
    } Fail:^(NSString *failString, int errorType) {
        [_locationIndictorView stopAnimating];
        
        if (errorType == errorType_hadData_matchCfail || errorType == errorType_matchCityFailed) {
            _localCityLable.text = @"匹配城市失败，请手动选择城市";
        }else{
            _localCityLable.text = @"定位失败,点击重新定位";
        }
    }];
}

//点击首字母
- (void)touchFirstChar : (UIButton *)sender
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]  atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//back
- (void)touchBackItem
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.isOnScreen = NO;
    }];
}

#pragma mark actionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case kActionSheet_selectCity:
        {
            if (buttonIndex == 0) {
                [HbuAreaLocationManager sharedManager].currentAreas = _selectArea;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
            
        default:
            break;
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
