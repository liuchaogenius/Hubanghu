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

#define kSgmBtnHeight 35
#define kBlankButtonTag 149 //当cate数量为奇数时，空白button的tag值
#define kSelectTagBase 200 //selectline的tag值的起步值

//需分栏下 返回选中种类的catemodel
#define depth2CateModel (self.categoryInfoModel.child[self.selectSgmButton.tag % kSelectTagBase])

@interface HbuCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_touchedButton;
}
@property (strong ,nonatomic) HbhWorkers *worker; //if！=nil 代表有预先确定的工人

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CategoryInfoModel *categoryInfoModel;
@property (strong, nonatomic) CategoryChildInfoModel *categoryChildInfoModel;

//分栏相关
@property (strong, nonatomic) NSMutableArray *segmentButtonArray; //上方分栏
@property (strong, nonatomic) UIScrollView *sgmBtmScrollView;
@property (weak, nonatomic) UIButton *selectSgmButton;//记录选中的sgmBtm
@property (assign, nonatomic) NSInteger sgmCount; //分栏数量,若=0，则表示不需要分栏
@property (strong, nonatomic) UIView *selectLine; //橙色选择表示线

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
    CategoryChildInfoModel *childCateModel = nil;
    if(self.categoryInfoModel.child &&self.categoryInfoModel.child.count >1)
    {
        childCateModel = self.categoryInfoModel.child[0];
    }
    MLOG(@"%@",childCateModel);
    _sgmCount = (childCateModel ? self.categoryInfoModel.child.count : 0);//判断是否多层
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
            CategoryChildInfoModel *childModel = self.categoryInfoModel.child[i];
            UIButton *sgmButton = [self customButtonWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, kSgmBtnHeight) andTitle:childModel.title];
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


- (instancetype)initWithCateId:(double)cateId
{
    if (self = [super init]) {
        self.cateId = cateId;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithCateId:(double)cateId andWorker:(HbhWorkers *)worker
{
    if ((self = [self initWithCateId:cateId]) && worker) {
        self.worker = worker;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    //[self settitleLabel:@"加载中..."];
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
    }

    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = kViewBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _sgmCount = 0;
    [self.tableView registerClass:[HbhCategoryCell class] forCellReuseIdentifier:@"Cell"];
    __weak HbuCategoryViewController *weakSelf = self;
    
    UIActivityIndicatorView *indictor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indictor.center = CGPointMake(kMainScreenWidth/2.0,100);
    [self.view addSubview:indictor];
    [indictor startAnimating];
    
    [HbuCategoryListManager getCategroryInfoWithCateId:self.cateId WithSuccBlock:^(CategoryInfoModel *cModel) {
        [indictor stopAnimating];
        weakSelf.categoryInfoModel = cModel;
        //weakSelf.title = weakSelf.categoryInfoModel.title;
        //[weakSelf settitleLabel:weakSelf.categoryInfoModel.title];
        weakSelf.sgmCount = [weakSelf getSgmCount];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 7)];
        //whiteView.backgroundColor = [UIColor blackColor];
        weakSelf.tableView.tableHeaderView = whiteView;
        [weakSelf.view addSubview:weakSelf.tableView];
        
        //判断是否需要分栏，并作处理
        if (weakSelf.sgmCount) {
            [weakSelf.view addSubview:weakSelf.sgmBtmScrollView];
            
        }
        weakSelf.tableView.frame = CGRectMake(0, (self.sgmCount ? kSgmBtnHeight+0:0), kMainScreenWidth, (self.sgmCount ? kMainScreenHeight-20-44-kSgmBtnHeight : kMainScreenHeight-20-44) );
        [weakSelf addTableViewTrag];
        [weakSelf.tableView reloadData];
    } and:^{
        //错误处理
        [indictor stopAnimating];
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络" cover:YES offsetY:kMainScreenHeight/2.0];
    }];
}

- (void)addTableViewTrag
{
    __weak HbuCategoryViewController *weakSelf = self;
    [weakSelf.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [HbuCategoryListManager getCategroryInfoWithCateId:self.cateId WithSuccBlock:^(CategoryInfoModel *cModel) {
                weakSelf.categoryInfoModel = cModel;
                _sgmCount = [weakSelf getSgmCount];
                if (weakSelf.sgmCount && !_sgmBtmScrollView) {
                    [self.view addSubview:weakSelf.sgmBtmScrollView];
                }
                
                //weakSelf.title = weakSelf.categoryInfoModel.title;
                //[self settitleLabel:weakSelf.categoryInfoModel.title];
                [weakSelf.view addSubview:weakSelf.tableView];
                
                //判断是否需要分栏，并作处理
                
                weakSelf.tableView.frame = CGRectMake(0, (self.sgmCount ? kSgmBtnHeight:0), kMainScreenWidth, (self.sgmCount ? kMainScreenHeight-20-44-kSgmBtnHeight : kMainScreenHeight-20-44) );
                [weakSelf.tableView reloadData];
            } and:nil];
        });
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法

#pragma mark Section Number
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.categoryInfoModel) {
        return 1;
    }else{
        return 0;
    }
}

#pragma mark 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *childArray = (self.sgmCount ? (((CategoryChildInfoModel *)depth2CateModel).child) : self.categoryInfoModel.child);
    MLOG(@"");
    return childArray.count/2 + childArray.count%2;
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
    CategoryChildInfoModel *leftCateModel =(self.sgmCount ? [self childDepthThreeCateModelWithIndex:indexPath.row * 2] : self.categoryInfoModel.child[indexPath.row*2]);
    
    [cell.leftImageButton sd_setImageWithURL:[NSURL URLWithString:leftCateModel.imageUrl] forState:UIControlStateNormal];
    if (![cell respondsToSelector:@selector(touchImageButton:)]) {
        [cell.leftImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.leftImageButton.tag = leftCateModel.cateId;
    cell.leftTitleLable.text = leftCateModel.title;
    
    //当category总数为奇数个时，最后一排右侧部分处理
    //self.categoryInfoModel.child.count%2 &&

    if (((indexPath.row+1)*2 == (self.sgmCount ? ((CategoryChildInfoModel *)depth2CateModel).child.count+1 : self.categoryInfoModel.child.count+1))) {

        [cell.rightImageButton setImage:nil forState:UIControlStateNormal];
        cell.rightTitleLabel.text = @"";
        cell.rightImageButton.hidden = YES;
        cell.rightImageButton.tag = kBlankButtonTag;
    
    }else{
        CategoryChildInfoModel *rightCateModel;
        if (self.sgmCount) {
            rightCateModel = [self childDepthThreeCateModelWithIndex:indexPath.row * 2 + 1];
        }else{
            rightCateModel = self.categoryInfoModel.child[indexPath.row*2 + 1];
        }
        
        
        [cell.rightImageButton sd_setImageWithURL:[NSURL URLWithString:rightCateModel.imageUrl] forState:UIControlStateNormal ];
        
        [cell.rightImageButton addTarget:self action:@selector(touchImageButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightImageButton.tag = rightCateModel.cateId;
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
    double cateId = _touchedButton.tag;
    if (cateId != kBlankButtonTag) {
        if(![HbhUser sharedHbhUser].isLogin)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginForUserMessage object:[NSNumber numberWithBool:NO]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PushtoAppointVC) name:kLoginSuccessMessae object:nil];
        }else{
            [self PushtoAppointVC];
        }
    }
}

#pragma mark 用户登录后push进入预定界面
- (void)PushtoAppointVC
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessMessae object:nil];
    if (_touchedButton) {
        double cateId = _touchedButton.tag;
        UILabel *titileLable = (UILabel *)[_touchedButton viewWithTag:kTitleLabelTag];
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:titileLable.text?:@"",@"title",[NSString stringWithFormat:@"%lf",cateId],@"cateId", nil];
        HuhAppointmentVC *appointVC = [[HuhAppointmentVC alloc] init];//WithTitle:infoDic[@"title"] cateId:infoDic[@"cateId"] andWork:self.worker];
        [appointVC setVCData:infoDic[@"title"] cateId:infoDic[@"cateId"] andWork:self.worker];
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

//分栏下 返回选中种类下cateModel下 具体index的子cateModel
- (CategoryChildInfoModel *)childDepthThreeCateModelWithIndex:(NSInteger)index
{
    CategoryChildInfoModel *childModel = self.categoryInfoModel.child[self.selectSgmButton.tag % kSelectTagBase];
    MLOG(@"%d",childModel.child.count)
    ;
    return [CategoryChildInfoModel modelObjectWithDictionary:childModel.child[index]];
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
