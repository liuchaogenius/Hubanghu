//
//  HbhCommentViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhCommentViewController.h"
#import "HbhWorkerCommentTableViewCell.h"
#import "HbhWorkerComment.h"
#import "UIImageView+WebCache.h"
#import "SVPullToRefresh.h"
#import "HbhWorkerCommentManage.h"
#import "SVProgressHUD.h"

@interface HbhCommentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *showCommentTableView;
@property(nonatomic, strong) NSMutableArray *commentArray;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, assign) int myWorkerId;
@property(nonatomic, strong) HbhWorkerCommentManage *workerCommentManage;
@property(nonatomic, strong) UIView *failView;
@end

@implementation HbhCommentViewController

//- (instancetype)initWithCommentArray:(NSArray *)aArray
//{
//    self = [super init];
//    self.commentArray = aArray;
//    return self;
//}

- (instancetype)initWithWorkerId:(int)aId
{
    self = [super init];
    self.myWorkerId = aId;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
//    self.title = @"用户评论";
    [self settitleLabel:@"用户评论"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.showCommentTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.showCommentTableView.dataSource = self;
    self.showCommentTableView.delegate = self;
    self.showCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showCommentTableView.tableHeaderView = view;
    self.showCommentTableView.backgroundColor = kViewBackgroundColor;
    [self.view addSubview:self.showCommentTableView];
    
    [self addTableViewTrag];
    
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
    
    [self tableViewTragDown];
    
}

- (UIActivityIndicatorView *)activityView
{
    if(!_activityView)
    {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-20, kMainScreenHeight/2-20, 40, 40)];
        _activityView.color = [UIColor blackColor];
    }
    return _activityView;
}

- (HbhWorkerCommentManage *)workerCommentManage
{
    if (!_workerCommentManage) {
        _workerCommentManage = [[HbhWorkerCommentManage alloc] init];
    }
    return _workerCommentManage;
}

- (UIView *)failView
{
    if (!_failView) {
        _failView = [[UIView alloc] init];
        _failView.frame = self.showCommentTableView.frame;
        UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-100, kMainScreenHeight/2-100, 200, 50)];
        failLabel.text = @"暂时没有数据";
        failLabel.font = kFont14;
        failLabel.textAlignment = NSTextAlignmentCenter;
        failLabel.textColor = [UIColor lightGrayColor];
        [_failView addSubview:failLabel];
        _failView.backgroundColor = RGBCOLOR(247, 247, 247);
    }
    return _failView;
}

- (NSMutableArray *)commentArray
{
    if (!_commentArray) {
        _commentArray = [NSMutableArray new];
    }
    return _commentArray;
}

- (void)tableViewTragDown
{
    [self.workerCommentManage getWorkerListWithWorkerId:self.myWorkerId SuccBlock:^(NSArray *aCommentArray) {
        self.commentArray = [aCommentArray mutableCopy];
        [self.showCommentTableView reloadData];
        [self.activityView stopAnimating];
    } andFailBlock:^{
        [self.view addSubview:self.failView];
        [SVProgressHUD showErrorWithStatus:@"网络请求失败,请稍后重试" cover:YES offsetY:kMainScreenHeight/2.0];
    }];
}

- (void)tableViewTragUp
{
    [self.workerCommentManage getNextWorkerListSuccBlock:^(NSArray *aCommentArray) {
        [self.commentArray addObjectsFromArray:aCommentArray];
        [self.showCommentTableView reloadData];
    } andFailBlock:^{
        [SVProgressHUD showErrorWithStatus:@"网络请求失败,请稍后重试" cover:YES offsetY:kMainScreenHeight/2.0];
    }];
}

#pragma mark 上拉下拉
#pragma mark 增加上拉下拉
- (void)addTableViewTrag
{
    __weak HbhCommentViewController *weakself = self;
    [weakself.showCommentTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.showCommentTableView.pullToRefreshView stopAnimating];
            [self tableViewTragDown];
        });
    }];
    
    
    [weakself.showCommentTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.showCommentTableView.infiniteScrollingView stopAnimating];
            [self tableViewTragUp];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.commentArray.count-1)
    {
        return 62;
    }
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentCellIdentifier";
    HbhWorkerCommentTableViewCell *cell = (HbhWorkerCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HbhWorkerCommentTableViewCell alloc] init];
    }
    HbhWorkerComment *model = [self.commentArray objectAtIndex:indexPath.row];
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:model.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto"]];
    cell.userNameLabel.text = model.username;
    cell.timeLabel.text = [self transformTime:model.time];
    cell.typeLabel.text = model.cate;
    cell.commentLabel.text = model.content;
    cell.workerNameLabel.text = model.worker;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSString *)transformTime:(int)aTime
{
    NSDate *newDate  = [NSDate dateWithTimeIntervalSince1970:aTime];
    MLOG(@"%@", newDate);
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *showtimeNew = [formatter1 stringFromDate:newDate];
    return showtimeNew;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
