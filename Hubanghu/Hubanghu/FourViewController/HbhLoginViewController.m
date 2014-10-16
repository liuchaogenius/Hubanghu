//
//  HbhLoginViewController.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhLoginViewController.h"
#import "HbhUserManager.h"
#import "HbhUser.h"
#define sgmButtonHeight 40
enum SegmentBtn_Type
{
    SegmentBtn_login = 100, //登陆
    SegmentBtn_register     //注册
};

enum TextField_Type
{
    TextFiled_phoneNumber = 130,//账号文本框
    TextField_password //密码框
};

@interface HbhLoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *sgmLoginButton; //登陆选项按钮
@property (nonatomic,strong) UIButton *sgmRegisterButton; //注册选项按钮
@property (nonatomic,strong) UIView *loginView;//注册界面
@property (nonatomic,strong) UIView *registerView;//注册界面
@property (nonatomic,strong) UIView *selectedLine;//选择表示线
@property (nonatomic, weak) UITextField *phoneNumberTextField;
@property (nonatomic, weak) UITextField *passwordTextField;
@property (nonatomic, weak) UIButton *LoginButton;//登陆按钮
@property (nonatomic, weak) UIButton *forgetPasswordBtn;//忘记密码按钮
@end

@implementation HbhLoginViewController

#pragma mark - getter and setter
- (UIButton *)sgmLoginButton
{
    if (!_sgmLoginButton) {
        _sgmLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sgmLoginButton setFrame:CGRectMake(0, 0, kMainScreenWidth/2.0f, sgmButtonHeight)];
        [_sgmLoginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sgmLoginButton setTitleColor:KColor forState:UIControlStateSelected];
        [_sgmLoginButton setTitle:@"账号登陆" forState:UIControlStateNormal];
        _sgmLoginButton.tag = SegmentBtn_login;
        _sgmLoginButton.layer.borderWidth = 0.7f;
        _sgmLoginButton.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor];
        _sgmLoginButton.selected = NO;
        [_sgmLoginButton addTarget:self action:@selector(touchSgmButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sgmLoginButton;
}

- (UIButton *)sgmRegisterButton
{
    if (!_sgmRegisterButton) {
        _sgmRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sgmRegisterButton setFrame:CGRectMake(kMainScreenWidth/2.0f, 0, kMainScreenWidth/2.0f, sgmButtonHeight)];
        [_sgmRegisterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sgmRegisterButton setTitleColor:KColor forState:UIControlStateSelected];
        [_sgmRegisterButton setTitle:@"注册" forState:UIControlStateNormal];
        _sgmRegisterButton.tag = SegmentBtn_register;
        _sgmRegisterButton.layer.borderWidth = 0.7f;
        _sgmRegisterButton.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor];
        _sgmRegisterButton.selected = NO;
        [_sgmRegisterButton addTarget:self action:@selector(touchSgmButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sgmRegisterButton;
}

- (UIView *)selectedLine
{
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, sgmButtonHeight-2, kMainScreenWidth/2.0, 2)];
        _selectedLine.backgroundColor = KColor;
    }
    return _selectedLine;
}

- (UIView *)loginView
{
    if (!_loginView) {
        _loginView = [[UIView alloc] initWithFrame:CGRectMake(0, sgmButtonHeight, kMainScreenWidth, kMainScreenHeight-sgmButtonHeight-64)];
        _loginView.backgroundColor = RGBCOLOR(249, 249, 249);
        
        UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, kMainScreenWidth-40, 105)];
        whiteBackView.backgroundColor = [UIColor whiteColor];
        whiteBackView.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor];
        whiteBackView.layer.borderWidth = 1.0f;
        whiteBackView.layer.cornerRadius = 4.0;
        [_loginView addSubview:whiteBackView];
        
        UITextField *phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, whiteBackView.bounds.size.width-10, 35)];
        [phoneNumberTextField setBorderStyle:UITextBorderStyleRoundedRect];
        phoneNumberTextField.layer.masksToBounds = YES;
        phoneNumberTextField.layer.cornerRadius = 4.0f;
        phoneNumberTextField.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor];//[KColor CGColor];
        phoneNumberTextField.layer.borderWidth = 0.7f;
        phoneNumberTextField.placeholder = @"用户名/邮箱/手机号";
        phoneNumberTextField.delegate = self;
        phoneNumberTextField.tag = TextFiled_phoneNumber;
        [phoneNumberTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [phoneNumberTextField setReturnKeyType:UIReturnKeyNext];
        _phoneNumberTextField = phoneNumberTextField;
        [whiteBackView addSubview:phoneNumberTextField];
        
        UITextField *passWordTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 60, whiteBackView.bounds.size.width-10, 35)];
        [passWordTextField setBorderStyle:UITextBorderStyleRoundedRect];
        passWordTextField.layer.masksToBounds = YES;
        passWordTextField.layer.cornerRadius = 4.0f;
        passWordTextField.layer.borderColor = [RGBCOLOR(207, 207, 207) CGColor]; //[KColor CGColor];
        passWordTextField.layer.borderWidth = 0.7f;
        passWordTextField.placeholder = @"密码";
        passWordTextField.delegate = self;
        passWordTextField.tag = TextField_password;
        [passWordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [passWordTextField setReturnKeyType:UIReturnKeyGo];
        passWordTextField.secureTextEntry = YES;
        _passwordTextField = passWordTextField;
        [whiteBackView addSubview:passWordTextField];

        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.backgroundColor = KColor;
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton setFrame:CGRectMake(20, 125+45, kMainScreenWidth-40.0, 40)];
        loginButton.layer.cornerRadius = 5.0f;
        [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(touchLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _LoginButton = loginButton;
        [_loginView addSubview:loginButton];
        
        _forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_forgetPasswordBtn setFrame:CGRectMake(kMainScreenWidth - 20-50, 125+85+20, 50, 20)];
        _forgetPasswordBtn.titleLabel.font = kFont12;
        [_loginView addSubview:_forgetPasswordBtn];
    }
    return _loginView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
#warning 带隐藏tabbar
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sgmLoginButton];
    [self.view addSubview:self.sgmRegisterButton];
    self.sgmLoginButton.selected = YES;
    
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.selectedLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)touchSgmButton:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = YES;
        switch (sender.tag) {
            case SegmentBtn_login:
            {
                self.sgmRegisterButton.selected = NO;
                [UIView animateWithDuration:0.5f animations:^{
                    self.selectedLine.centerX -= kMainScreenWidth/2.0f;
                }];
            }
                break;
            case SegmentBtn_register:
            {
                self.sgmLoginButton.selected = NO;
                [UIView animateWithDuration:0.5f animations:^{
                    self.selectedLine.centerX += kMainScreenWidth/2.0f;
                }];
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.phoneNumberTextField isFirstResponder]) {
        [self.phoneNumberTextField resignFirstResponder];
    }
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

#pragma mark 点击登陆按钮
- (void)touchLoginButton
{
    if (self.phoneNumberTextField.text.length && self.passwordTextField.text.length) {
        [HbhUserManager loginWithPhone:self.phoneNumberTextField.text andPassWord:self.passwordTextField.text withSuccess:^{
            //登陆状态处理
            [HbhUser sharedHbhUser];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^{
            //错误状态处理
        }];
    }

}


#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [KColor CGColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [RGBCOLOR(207, 207, 204) CGColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    switch (textField.tag) {
        case TextFiled_phoneNumber:
        {
            [self.passwordTextField becomeFirstResponder];
        }
            break;
        case TextField_password:
        {
            [self touchLoginButton]; //登陆
        }
            break;
        default:
            break;
    }
    return YES;
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
