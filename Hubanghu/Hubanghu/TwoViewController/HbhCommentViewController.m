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

@interface HbhCommentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *showCommentTableView;
@property(nonatomic, strong) NSArray *commentArray;
@end

@implementation HbhCommentViewController

- (instancetype)initWithCommentArray:(NSArray *)aArray
{
    self = [super init];
    self.commentArray = aArray;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户评论";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.showCommentTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.showCommentTableView.dataSource = self;
    self.showCommentTableView.delegate = self;
    self.showCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showCommentTableView.tableHeaderView = view;
    [self.view addSubview:self.showCommentTableView];
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

//- (NSDate*)getNSDate:(NSString *)aStrTime
//{
//    if(!calendar)
//    {
//        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    }
//    if(!inputFormatter)
//    {
//        inputFormatter = [[NSDateFormatter alloc] init] ;
//        [inputFormatter setLocale:[NSLocale currentLocale]];
//        [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    }
//    NSDate* inputDate = [inputFormatter dateFromString:aStrTime];
//    return inputDate;
//}
//
//- (NSString *)strTimeToNSInteger:(NSString *)aStrTime
//{
//    /////NSString* string = @"20110826134106";
//    NSDate* inputDate = [self getNSDate:aStrTime];
//    //    NSLog(@"date = %@", inputDate);
//    if(!comps)
//    {
//        comps = [[NSDateComponents alloc] init];
//    }
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:inputDate];
//}


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
