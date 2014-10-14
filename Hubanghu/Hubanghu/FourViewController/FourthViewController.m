//
//  FourthViewController.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "FourthViewController.h"
#import "FourthVCHeadView.h"

#define KSetionNumber 5
#define kcornerRadius 4
#define kHeaderHeight 114

@interface FourthViewController ()

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSArray *listArray;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-44-64) style:UITableViewStyleGrouped];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
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
    if (section == 0) {
        return kHeaderHeight;
    } else if (section == self.listArray.count+1){
        return 35;
    } else {
        return 6;
    }
}



#pragma mark headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        FourthVCHeadView *view = [[FourthVCHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kHeaderHeight)];
        
        //带判断用户是否登录以及载入数据
        return view;
        
        
    }else if(section == self.listArray.count+1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 35)];
        //添加返回按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(20, 0, kMainScreenWidth-40.0, 35)];
        button.backgroundColor = KColor;
        [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        button.layer.cornerRadius = kcornerRadius;
        [view addSubview:button];
        return view;
    }else{
        return nil;
    }
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
        }
        NSArray *array = self.listArray[indexPath.section-1];
        NSDictionary *dic = array[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
        cell.textLabel.text = dic[@"name"];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return cell;
    }
    /*
     else if(indexPath.section == self.listArray.count+1){
     //退出按钮cell
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutCellIdentifier];
     if (!cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutCellIdentifier];
     
     //添加返回按钮
     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [button setFrame:CGRectMake(20, 5, kMainScreenWidth-40.0, 30)];
     button.backgroundColor = [UIColor redColor];
     [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
     [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [button setTitle:@"退出登录" forState:UIControlStateNormal];
     [cell.contentView addSubview:button];
     cell.backgroundColor = [UIColor clearColor];
     }
     
     return cell;
     */
}

#pragma mark - Action
#pragma mark 退出登录
- (void)logout
{
    
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
