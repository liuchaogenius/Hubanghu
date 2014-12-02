//
//  HbhChangePswViewController.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhChangePswViewController.h"
#import "HbhUserManager.h"
#import "SVProgressHUD.h"
enum TextField_Type
{
    TextField_oldPsw = 50,
    TextField_newPsw,
    TextField_ConfirmPsw
};

@interface HbhChangePswViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *oldPswTextField; //旧密码文本框
@property (strong, nonatomic) UITextField *aNewPswTextField;//新密码文本框
@property (strong, nonatomic) UITextField *confirmPswTextField;//确认密码文本框
@property (strong, nonatomic) UIButton *ConfirmButton;//确认按钮

@end

@implementation HbhChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"修改密码";
    [self settitleLabel:@"修改密码"];
    self.view.backgroundColor = kViewBackgroundColor;//
    [self setUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI
{
    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 165+40)];
    whiteBackView.backgroundColor = [UIColor whiteColor];
    whiteBackView.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 207) CGColor];
    whiteBackView.layer.borderWidth = 1.0f;
    //whiteBackView.layer.cornerRadius = 4.0;
    [self.view addSubview:whiteBackView];
    
    _oldPswTextField = [self customedTextFieldWithFrame:CGRectMake(5+20, 15+20, whiteBackView.bounds.size.width-10-40, 35)  andPlaceholder:@"原密码" andTag:TextField_oldPsw andReturnKeyType:UIReturnKeyNext];
    [whiteBackView addSubview:self.oldPswTextField];
    
    _aNewPswTextField = [self customedTextFieldWithFrame:CGRectMake(5+20, 65+20, whiteBackView.bounds.size.width-10-40, 35) andPlaceholder:@"新密码" andTag:TextField_newPsw andReturnKeyType:UIReturnKeyNext];
    self.aNewPswTextField.secureTextEntry = YES;
    [whiteBackView addSubview:self.aNewPswTextField];
    
    _confirmPswTextField = [self customedTextFieldWithFrame:CGRectMake(5+20, 115+20, whiteBackView.bounds.size.width-10-40, 35) andPlaceholder:@"确认新密码" andTag:TextField_ConfirmPsw andReturnKeyType:UIReturnKeyGo];
    self.confirmPswTextField.secureTextEntry = YES;
    [whiteBackView addSubview:self.confirmPswTextField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 205+5, 150, 25)];
    label.textColor = [UIColor lightGrayColor];
    label.text = @"至少6位的数字和字母组成";
    label.font = kFont11;
    if (kSystemVersion < 7.0) {
        label.backgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:label];
    
    _ConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ConfirmButton.backgroundColor = kIconSelectColor;
    [_ConfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ConfirmButton setFrame:CGRectMake(20, 190+60, kMainScreenWidth-40.0, 40)];
    _ConfirmButton.layer.cornerRadius = 5.0f;
    [_ConfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_ConfirmButton addTarget:self action:@selector(changePsw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ConfirmButton];
    
    

}

#pragma mark - Action
#pragma mark 修改密码
- (void)changePsw
{
    if (self.oldPswTextField.text.length && self.aNewPswTextField.text.length && self.confirmPswTextField.text.length) {
        if (![self.oldPswTextField.text isEqualToString:self.aNewPswTextField.text]) {
            if ([self.aNewPswTextField.text isEqualToString:self.confirmPswTextField.text]) {
                [HbhUserManager changePassWordWithOldPwd:self.oldPswTextField.text andNewPwd:self.aNewPswTextField.text andComfirmPwd:self.confirmPswTextField.text Success:^{
                    [SVProgressHUD showSuccessWithStatus:@"修改密码成功!" cover:YES offsetY:kMainScreenHeight/2.0];
                } failure:^(NSInteger result, NSString *resultString) {
                    [SVProgressHUD showErrorWithStatus:resultString cover:YES offsetY:kMainScreenHeight/2.0];
                }];

            }else{
                [SVProgressHUD showErrorWithStatus:@"两次输入新密码不一致，请重输" cover:YES offsetY:kMainScreenHeight/2.0];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"新旧密码一样，请重新输入" cover:YES offsetY:kMainScreenHeight/2.0];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入完整" cover:YES offsetY:kMainScreenHeight/2.0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.oldPswTextField isFirstResponder]) {
        [self.oldPswTextField resignFirstResponder];
    }
    if ([self.aNewPswTextField isFirstResponder]) {
        [self.aNewPswTextField resignFirstResponder];
    }
    if ([self.confirmPswTextField isFirstResponder]) {
        [self.confirmPswTextField resignFirstResponder];
    }
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [kIconSelectColor CGColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 204) CGColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    switch (textField.tag) {
        case TextField_oldPsw:
        {
            [self.aNewPswTextField becomeFirstResponder];
        }
            break;
        case TextField_newPsw:
        {
            [self.confirmPswTextField becomeFirstResponder];
        }
            break;
        case TextField_ConfirmPsw:
        {
            [self changePsw];
        }
        default:
            break;
    }
    return YES;
}


//定制的textField
- (UITextField *)customedTextFieldWithFrame:(CGRect)frame andPlaceholder:(NSString *)placeholder andTag:(NSInteger)TextField_Type andReturnKeyType:(UIReturnKeyType)returnKeyType
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    if (kSystemVersion < 7.0) {
        [textField setBorderStyle:UITextBorderStyleBezel];
    }
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4.0f;
    textField.layer.borderColor = [kLineColor CGColor];//[RGBCOLOR(207, 207, 207) CGColor];//[KColor CGColor];
    textField.layer.borderWidth = 0.7f;
    textField.placeholder = placeholder;
    textField.delegate = self;
    textField.tag = TextField_Type;
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setReturnKeyType:returnKeyType];
    return textField;
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
