//
//  OrderAppraiseViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderAppraiseViewController.h"
#import "NetManager.h"

@interface HbhOrderAppraiseViewController ()<UITextViewDelegate>
{
    UILabel *placeHolderLabel;
}

@property (strong, nonatomic) IBOutlet UIButton *agianBtn;
@property(nonatomic, strong) UITextView *appraiseTextView;
@property(nonatomic, strong) HbhOrderModel *myModel;
@property(nonatomic) int isAgian;
@end

@implementation HbhOrderAppraiseViewController

- (instancetype)initWithModel:(HbhOrderModel *)aModel
{
    self = [super init];
    self.myModel = aModel;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    self.title = @"评价";
    _isAgian = 0;
    
    self.appraiseTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 140, kMainScreenWidth-30, 168)];
    self.appraiseTextView.backgroundColor = kViewBackgroundColor;
    self.appraiseTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.appraiseTextView.layer.borderWidth = 0.5;
    self.appraiseTextView.delegate = self;
    self.appraiseTextView.returnKeyType = UIReturnKeyDone;
    self.appraiseTextView.font = kFont14;
    [self.view addSubview:self.appraiseTextView];
    
    [self.agianBtn addTarget:self action:@selector(chooseAgain) forControlEvents:UIControlEventTouchUpInside];
    
    placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.frame = CGRectMake(18, 140, kMainScreenHeight-30, 30);
    placeHolderLabel.text = @"请输入您的评价...";
    placeHolderLabel.font = kFont14;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:placeHolderLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.appraiseTextView.left, self.appraiseTextView.bottom+50, kMainScreenWidth-30, 30)];
    btn.backgroundColor = KColor;
    btn.layer.cornerRadius = 2.5;
    btn.titleLabel.font = kFont20;
    [btn addTarget:self action:@selector(commitComment) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)chooseAgain
{
    if (_isAgian==0)
    {
        _isAgian=1;
        [self.agianBtn setBackgroundImage:[UIImage imageNamed:@"rectangleUp"] forState:UIControlStateNormal];
    }
    else if(_isAgian==1)
    {
        _isAgian=0;
        [self.agianBtn setBackgroundImage:[UIImage imageNamed:@"rectangle"] forState:UIControlStateNormal];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        placeHolderLabel.text = @"请输入您的评价...";
    }else{
        placeHolderLabel.text = @"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 提交评价
- (void)commitComment
{
    NSString *commentUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", (int)self.myModel.orderId],@"orderId",@"4",@"skill",@"4",@"status",[NSString stringWithFormat:@"%d", _isAgian],@"again",self.appraiseTextView.text,@"commment", nil];
    kHubRequestUrl(@"submitComment.ashx", commentUrl);
    [NetManager requestWith:dict url:commentUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict){
        MLOG(@"%@", successDict);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
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
