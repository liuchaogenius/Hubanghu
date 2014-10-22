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
#import "HbhUser.h"
#import "SVProgressHUD.h"
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
@property (assign, nonatomic) NSInteger lastArrayNum;
@property (strong, nonatomic) NSMutableArray *firstCharArray; //首字母数组
@property (strong, nonatomic) NSArray *hotCityName; //热门城市名字数组

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    [self setExtraCellLineHidden:self.tableView]; //隐藏多需的cell线
    
    UINib *nib = [UINib nibWithNibName:@"HbhHotCityCell" bundle:[NSBundle mainBundle]];
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
        }
        cell.textLabel.text = ([HbuAreaLocationManager sharedManager].currentAreas ? [HbuAreaLocationManager sharedManager].currentAreas.name : @"定位失败,点击重新定位");
        return cell;
    }else if(indexPath.section == 1){
        HbhHotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCellIdentifier forIndexPath:indexPath];

        if (![((UIButton *)cell.hotCityButtons[0]) respondsToSelector:@selector(touchHotCityButton:)]) {
            for (UIButton *button  in cell.hotCityButtons) {
                [button addTarget:self action:@selector(touchHotCityButton:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        //TODO：设备cell内容
        HbuAreaListModelAreas *area = ((NSArray *)self.cityDict[self.firstCharArray[indexPath.section - 2]])[indexPath.row];
        cell.textLabel.text = area.name;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //定位
        [_locationIndictorView startAnimating];
        [[HbuAreaLocationManager sharedManager] getUserLocationWithSuccess:^{
            [_locationIndictorView stopAnimating];
            _localCityLable.text = [HbuAreaLocationManager sharedManager].currentAreas.name;
        } Fail:^(NSString *failString) {
            [_locationIndictorView stopAnimating];
            _localCityLable.text = @"定位失败,点击重新定位";
        }];
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
            [SVProgressHUD showErrorWithStatus:@"发生错误，选择失败" cover:YES offsetY:kMainScreenHeight/2.0];
        }
    }];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark actionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case kActionSheet_selectCity:
        {
            if (buttonIndex == 0) {
                if ([HbhUser sharedHbhUser].isLogin) {
                    [HbhUser sharedHbhUser].currentArea = _selectArea;
                }
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
