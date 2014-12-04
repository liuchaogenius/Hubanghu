//
//  HbuCategoryViewController.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbuCategoryViewController.h"
#import "CategoryInfoModel.h"
#import "HbuCategoryListManager.h"
#import "CategoryChildInfoModel.h"
#import "HbhCategoryCell.h"
#import "UIButton+WebCache.h"
#import "HuhAppointmentVC.h"
#import "HbhUser.h"
#import "SVPullToRefresh.h"
#import "SVProgressHUD.h"
#import "HbhCategory.h"

#define kSgmBtnHeight 35
#define kBlankButtonTag 149 //当cate数量为奇数时，空白button的tag值
#define kSelectTagBase 200 //selectline的tag值的起步值

//需分栏下 返回选中种类的catemodel
#define depth2CateModel (self.categoryInfoModel.child[self.selectSgmButton.tag % kSelectTagBase])

@interface HbuCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_touchedButton;
    HbhCategory *_selectCateModel;
}
@property (strong ,nonatomic) HbhWorkers *worker; //if！=nil 代表有预先确定的工人

@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) CategoryInfoModel *categoryInfoModel;
//@property (strong, nonatomic) CategoryChildInfoModel *categoryChildInfoModel;

//分栏相关
@property (strong, nonatomic) NSMutableArray *segmentButtonArray; //上方分栏
@property (strong, nonatomic) UIScrollView *sgmBtmScrollView;
@property (weak, nonatomic) UIButton *selectSgmButton;//记录选中的sgmBtm
@property (assign, nonatomic) NSInteger sgmCount; //分栏数量,若=0，则表示不需要分栏
@property (strong, nonatomic) UIView *selectLine; //橙色选择表示线
//new changed
@property (strong, nonatomic) HbhCategory *categoryModel;
@property (strong, nonatomic) HbhCategory *categoryChildModel;
@property (assign, nonatomic) NSInteger depth; //顶级分类确定层级，0.直接是产品跳转到订单页面（二次翻新用），1.无二级分类，直接出来产品，2.含二级分类，二级分类下的产品

@end

@implementation HbuCategoryViewController

#pragma mark - getter and setter
//分栏用试图
- (UIView *)selectLine
{
    if (!_selectLine) {
        _selectLine = [[UIView alloc] init];
        _selectLine.backgroundColor = KColor;
    }
    return _selectLine;
}

- (NSInteger)getSgmCount
{
    _sgmCount = self.depth == 2 ? self.categoryModel.child.count : 0;
    return _sgmCount;
}

- (UIScrollView *)sgmBtmScrollView
{
    if (!_sgmBtmScrollView) {
        _sgmBtmScrollView = [[UIScrollView alloc] init];
        _sgmBtmScrollView.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor];
        _sgmBtmScrollView.layer.borderWidth = 0.7f;
        _sgmBtmScrollView.layer.masksToBounds = YES;
        _sgmBtmScrollView.showsHorizontalScrollIndicator = NO;
        [_sgmBtmScrollView setFrame:CGRectMake(0, 0, kMainScreenWidth, kSgmBtnHeight)];
        _sgmBtmScrollView.backgroundColor = RGBCOLOR(245, 245, 245);
        
        //通过分栏数量调整content宽度
        CGFloat contentWidth = (self.sgmCount > 5 ? self.sgmCount*kMainScreenWidth/5.0f : kMainScreenWidth);
        [_sgmBtmScrollView setContentSize:CGSizeMake(contentWidth, kSgmBtnHeight)];
        
        //添加sgmButton
        CGFloat buttonWidth = (self.sgmCount>=5 ? kMainScreenWidth/5.0f : kMainScreenWidth/(float)self.sgmCount);
        for (int i = 0; i < self.sgmCount; i++) {
            //CategoryChildInfoModel *childModel = self.categoryInfoModel.child[i];
            _categoryChildModel = [HbhCategory modelObjectWithDictionary:self.categoryModel.child[i]];
            UIButton *sgmButton = [self customButtonWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, kSgmBtnHeight) andTitle:_categoryChildModel.title];
            sgmButton.tag = i + kSelectTagBase;//用tag%kSelectTagBase 来记录选中的分类
            if (i == 0) {
                sgmButton.selected = YES; //默认选择第一个
                self.selectSgmButton = sgmButton;
            }
            [_sgmBtmScrollView addSubview:sgmButton];
        }
        //添加选择指示线
        self.selectLine.frame = CGRectMake(0, kSgmBtnHeight-2, buttonWidth, 2);
        [_sgmBtmScrollView addSubview:self.selectLine];
        
    }
    return _sgmBtmScrollView;
}


- (instancetype)initWithCateId:(int)cateId
{
    if (self = [super init]) {
        self.cateId = cateId;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithCateId:(int)cateId andWorker:(HbhWorkers *)worker
{
    if ((self = [self initWithCateId:cateId]) && worker) {
        self.worker = worker;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.depth = -1; //初始化depth
    _sgmCount = 0;
    
    self.view.backgroundColor = kViewBackgroundColor;
    //[self settitleLabel:@"加载中..."];
    /*
    if(self.cateId == 2)
    {
        [self settitleLabel:@"地板安装"];
    }
    if(self.cateId == 3)
    {
        [self settitleLabel:@"卫浴安装"];
    }
    if(self.cateId == 4)
    {
        [self settitleLabel:@"灯饰安装"];
    }
    if(self.cateId == 5)
    {
        [self settitleLabel:@"墙纸安装"];
    }*/

    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = kViewBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 7)];
//    //whiteView.backgroundColor = [UIColor blackColor];
//    self.tableView.tableHeaderView = whiteView;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[HbhCategoryCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    [self addTableViewTrag];
    __weak HbuCategoryViewController *weakSelf = self;
    
//    UIActivityIndicatorView *indictor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indictor.center = CGPointMake(kMainScreenWidth/2.0,100);
//    [self.view addSubview:indictor];
//    [indictor startAnimating];
    [SVProgressHUD showWithStatus:@"拼命加载中..." cover:YES offsetY:0];
    [HbuCategoryListManager getCategroryInfoWithCateId:self.cateId WithSuccBlock:^(HbhCategory *cModel) {
        //[indictor stopAnimating];
        [SVProgressHUD dismiss];
        [weakSelf refreshUIwithModel:cModel];
    } and:^{
        //错误处理
        //[indictor stopAnimating];
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络" cover:YES offsetY:kMainScreenHeight/2.0];
    }];
}

- (void)refreshUIwithModel:(HbhCategory *)cModel// isFirstTimeL:(BOOL)isfirst;
{
    self.categoryModel = cModel;
    self.depth = cModel.depth;
    //依靠depth区分，顶级分类确定层级，0.直接是产品跳转到订单页面（二次翻新用），1.无二级分类，直接出来产品，2.含二级分类，二级分类下的产品
    switch (self.depth) {
        case 0:
        {
            //0.直接是产品跳转到订单页面（二次翻新用）
            HuhAppointmentVC *appointVC = [[HuhAppointmentVC alloc] initWithCateModel:self.categoryModel andWorker:self.worker];
            [appointVC setCustomedVCofDepthisZero];
            appointVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:appointVC animated:YES];
            
        }
            break;
        case 1:
        {
            //1.无二级分类，直接出来产品
            [self settitleLabel:cModel.title];
            
            if(![self.tableView superview]) [self.view addSubview:self.tableView];
            self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth,kMainScreenHeight-20-44);
            
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            //2.含二级分类，二级分类下的产品
            [self settitleLabel:cModel.title];
            self.sgmCount = cModel.child.count;
            if(![self.sgmBtmScrollView superview]) [self.view addSubview:self.sgmBtmScrollView];
            self.tableView.frame = CGRectMake(0, 0+kSgmBtnHeight, kMainScreenWidth,kMainScreenHeight-20-44-kSgmBtnHeight);
            if(![self.tableView superview])  [self.view addSubview:self.tableView];
            //[self addTableViewTrag];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)addTableViewTrag
{
    __weak HbuCategoryViewController *weakSelf = self;
    [weakSelf.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [HbuCategoryListManager getCategroryInfoWithCateId:self.cateId WithSuccBlock:^(HbhCategory *cModel) {
                [weakSelf refreshUIwithModel:cModel];
            } and:nil];
        });
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法

#pragma mark Section Number
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.categoryModel) {
        return 1;
    }else{
        return 0;
    }
}

#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.depth == 1) {
        return self.categoryModel.child.count/2 + self.categoryModel.child.count%2;
    }else if (self.depth == 2){
        NSArray *childArray = self.categoryModel.child;
        if (childArray.count > self.selectSgmButton.tag % kSelectTagBase) {
            _categoryChildModel = [HbhCategory modelObjectWithDictionary:childArray[self.selectSgmButton.tag % kSelectTagBase]];
            return _categoryChildModel.child.count/2 +_categoryChildModel.child.count%2;
        }else return 0;
        
    }else{
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

#pragma mark 每行显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    MLOG(@"indexpath.row = %d",indexPath.row);
    HbhCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.rightImageButton.hidden = NO;
    
    HbhCategory *leftCateModel = (self.depth == 2 ? [self grandsonCateModelWithChildIndex:self.selectSgmButton.tag % kSelectTagBase grandsonIndex:indexPath.row*2] : [self childCateModelWithIndex:indexPath.row*2]);

    [cell.leftImageButton sd_setImageWithURL:[NSURL URLWithString:leftCateModel.imageUrl] forState:UIControlStateNormal];
    if (![cell respondsToSelector:@selector(touchImageButton:)]) {
        [cell.leftImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.leftImageButton.tag = indexPath.row*2;//leftCateModel.cateId;
    cell.leftTitleLable.text = leftCateModel.title;
    
    //当category总数为奇数个时，最后一排右侧部分处理
    if (((indexPath.row+1)*2 == (self.depth == 2 ? [self childCateModelWithIndex:self.selectSgmButton.tag % kSelectTagBase].child.count+1 : self.categoryModel.child.count+1))) {

        [cell.rightImageButton setImage:nil forState:UIControlStateNormal];
        cell.rightTitleLabel.text = @"";
        cell.rightImageButton.hidden = YES;
        cell.rightImageButton.tag = kBlankButtonTag;
    
    }else{
        HbhCategory *rightCateModel = (self.depth == 2 ? [self grandsonCateModelWithChildIndex:self.selectSgmButton.tag % kSelectTagBase grandsonIndex:indexPath.row * 2 + 1] : [self childCateModelWithIndex:indexPath.row * 2 + 1]);
        /*
        if (self.sgmCount) {
            rightCateModel = [self childDepthThreeCateModelWithIndex:indexPath.row * 2 + 1];
        }else{
            rightCateModel = self.categoryInfoModel.child[indexPath.row*2 + 1];
        }*/
        
        
        [cell.rightImageButton sd_setImageWithURL:[NSURL URLWithString:rightCateModel.imageUrl] forState:UIControlStateNormal ];
        
        [cell.rightImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightImageButton.tag = indexPath.row*2+1;//rightCateModel.cateId;
        cell.rightTitleLabel.text = rightCateModel.title;
    }
    
    [cell.rightImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - Action
#pragma mark 点击sgmButton切换分类 刷新页面
- (void)touchSgmButton : (UIButton *)sender
{
    if (!sender.selected) {
        self.selectSgmButton.selected = NO;
        self.selectSgmButton = sender;
        sender.selected = YES;
        [UIView animateWithDuration:0.3f animations:^{
            self.selectLine.centerX = sender.centerX;
        }];
        [self.tableView reloadData];
    }
}
#pragma mark push进入预定界面
- (void)touchImageButton:(UIButton *)sender
{
    _touchedButton = sender; //记录sender
    int tag = _touchedButton.tag;
    if (tag != kBlankButtonTag) {
        _selectCateModel = nil;
        _selectCateModel = self.depth == 2 ? [self grandsonCateModelWithChildIndex:self.selectSgmButton.tag % kSelectTagBase grandsonIndex:tag] : [self childCateModelWithIndex:tag];
        if(![HbhUser sharedHbhUser].isLogin)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginForUserMessage object:[NSNumber numberWithBool:NO]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushtoAppointVC) name:kLoginSuccessMessae object:nil];
        }else{
            ;
            [self PushtoAppointVC];
        }
    }
}

#pragma mark 用户登录后push进入预定界面
- (void)PushtoAppointVC
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessMessae object:nil];
    if (_touchedButton && _selectCateModel) {
        //double cateId = _touchedButton.tag;
        //UILabel *titileLable = (UILabel *)[_touchedButton viewWithTag:kTitleLabelTag];
        //NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:titileLable.text?:@"",@"title",[NSString stringWithFormat:@"%lf",cateId],@"cateId", nil];
        HuhAppointmentVC *appointVC = [[HuhAppointmentVC alloc] initWithCateModel:_selectCateModel andWorker:self.worker];//WithTitle:infoDic[@"title"] cateId:infoDic[@"cateId"] andWork:self.worker];
        //[appointVC setVCData:infoDic[@"title"] cateId:infoDic[@"cateId"] andWork:self.worker];
        appointVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:appointVC animated:YES];
    }
}


#pragma mark - customButtom构造
- (UIButton *)customButtonWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:KColor forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    button.titleLabel.font = kFont14;
    //button.layer.borderWidth = 0.7f;
    //button.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor];
    button.selected = NO;
    [button addTarget:self action:@selector(touchSgmButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//非分栏下，返回index子model
- (HbhCategory *)childCateModelWithIndex:(NSInteger)index
{
    NSArray *array = self.categoryModel.child;
    if (index < array.count) {
        return [HbhCategory modelObjectWithDictionary:self.categoryModel.child[index]];
    }else{
        return nil;
    }
    
}
////分栏下 返回选中cindex种类cateModel下 具体gindex的子cateModel
- (HbhCategory *)grandsonCateModelWithChildIndex:(NSInteger)cIndex grandsonIndex:(NSInteger)gIndex
{
    HbhCategory *childCateModel = [HbhCategory modelObjectWithDictionary:self.categoryModel.child[cIndex]];
    return [HbhCategory modelObjectWithDictionary:childCateModel.child[gIndex]];
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
