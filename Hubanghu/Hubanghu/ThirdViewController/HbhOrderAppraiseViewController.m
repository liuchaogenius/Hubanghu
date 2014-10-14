//
//  OrderAppraiseViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhOrderAppraiseViewController.h"

@interface HbhOrderAppraiseViewController ()<UITextViewDelegate>
{
    UILabel *placeHolderLabel;
}
@property(nonatomic, strong) UITextView *appraiseTextView;
@end

@implementation HbhOrderAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    self.title = @"评价";
    
    self.appraiseTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 140, kMainScreenWidth-30, kMainScreenHeight-140-200-60)];
    self.appraiseTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.appraiseTextView.layer.borderWidth = 0.5;
    self.appraiseTextView.delegate = self;
    self.appraiseTextView.returnKeyType = UIReturnKeyDone;
    self.appraiseTextView.font = kFont14;
    [self.view addSubview:self.appraiseTextView];
    
    placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.frame = CGRectMake(18, 140, kMainScreenHeight-30, 30);
    placeHolderLabel.text = @"请输入您的评价...";
    placeHolderLabel.font = kFont14;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:placeHolderLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.appraiseTextView.left, kMainScreenHeight-200, kMainScreenWidth-30, 30)];
    btn.backgroundColor = KColor;
    [btn setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.view addSubview:btn];
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
