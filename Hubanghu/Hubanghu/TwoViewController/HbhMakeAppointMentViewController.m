//
//  HbhMakeAppointMentViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/18.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhMakeAppointMentViewController.h"
#import "HbuCategoryViewController.h"

@interface HbhMakeAppointMentViewController ()

@property(nonatomic, strong)HbhWorkers *workerModel;
@property(nonatomic) int workerId;
@property(nonatomic, strong) NSString *workerName;
@property(nonatomic, strong) NSDictionary *workerDict;
@end

@implementation HbhMakeAppointMentViewController

- (instancetype)initWithWorkerModel:(HbhWorkers *)aModel
{
    self = [super init];
    self.workerModel = aModel;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预约";
    int Interval = 5;
    CGFloat btnWidth = kMainScreenWidth/2-2.5;
    CGFloat btnHeight = btnWidth/534*368;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 50)];
    label.text = @"请选择要预约的项目 :";
    label.font = kFont17;
    [self.view addSubview:label];
    
    for (int i=0; i<5; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%2*(btnWidth+Interval), 50+i/2*(btnHeight+Interval), btnWidth, btnHeight)];
        MLOG(@"%f%f%f%f", btn.left, btn.top , btn.right, btn.bottom);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"OrderType_%d", i+1]]
                       forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+11;
        [self.view addSubview:btn];
    }
}

- (void)push:(UIButton *)aBtn
{
    [self.navigationController pushViewController:[[HbuCategoryViewController alloc] initWithCateId:aBtn.tag-10] animated:YES];
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
