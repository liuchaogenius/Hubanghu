//
//  HbhModifyUserDetailViewController.m
//  Hubanghu
//
//  Created by Johnny's on 14/10/19.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhModifyUserDetailViewController.h"
#import "HbhUser.h"
#import "UIImageView+WebCache.h"
#import "NetManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HbhModifyUserDetailViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIImage *photoImg;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation HbhModifyUserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    [self settitleLabel:@"编辑个人信息"];
    HbhUser *user = [HbhUser sharedHbhUser];
    
    self.imgView = [[UIImageView alloc]
                            initWithFrame:CGRectMake(kMainScreenWidth/2-40, 20, 80, 80)];
    self.imgView.layer.cornerRadius = 40;
    self.imgView.layer.borderWidth = 1;
    self.imgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imgView.clipsToBounds = YES;
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrImageClicked)];
    [self.imgView addGestureRecognizer:self.tapGesture];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto"]];
    [self.view addSubview:self.imgView];
        
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2-50, self.imgView.bottom+10, 100, 20)];
    [modifyBtn setTitle:@"点击修改头像" forState:UIControlStateNormal];
    [modifyBtn setTitleColor:RGBCOLOR(176, 176, 176) forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = kFont15;
    [modifyBtn addTarget:self action:@selector(UesrImageClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBtn];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, modifyBtn.bottom+40, 40, 40)];
    [headImgView setImage:[UIImage imageNamed:@"headImg"]];
    [self.view addSubview:headImgView];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, headImgView.bottom+10, 30, 40)];
    [phoneImgView setImage:[UIImage imageNamed:@"phoneImg"]];
    [self.view addSubview:phoneImgView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(headImgView.right+5, headImgView.top, kMainScreenWidth-20-headImgView.right-5, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 5;
    [self.view addSubview:backView];
    
    UIImageView *pencilImgView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.right-30, backView.top+10, 20, 20)];
    [pencilImgView setImage:[UIImage imageNamed:@"pencilImg"]];
    [self.view addSubview:pencilImgView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(backView.left+10, backView.top+5, pencilImgView.left-10-backView.left, 30)];
    self.textField.font = kFont15;
    self.textField.placeholder = @"输入用户名";
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textField.textColor = RGBCOLOR(176, 176, 176);
    [self.view addSubview:self.textField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(phoneImgView.right+10, phoneImgView.top, kMainScreenWidth-20-phoneImgView.right, 40)];
    label.font = kFont20;
    label.text = user.phone;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(headImgView.left, phoneImgView.bottom+70, kMainScreenWidth-headImgView.left*2, 35)];
    btn.backgroundColor = KColor;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = kFont20;
    [self.view addSubview:btn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchBtn
{
    if (![self.textField.text isEqualToString:@""])
    {
        [self changeUserName:self.textField.text];
    }
    if (self.photoImg) {
        [self uploadImg];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//upload image
- (void)uploadImg
{
    NSString *uploadPhototUrl = nil;
    kHubRequestUrl(@"uploadPhoto.ashx", uploadPhototUrl);
    [NetManager uploadImg:self.photoImg parameters:nil uploadUrl:uploadPhototUrl uploadimgName:@"headImg" parameEncoding:AFJSONParameterEncoding progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
        
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

//change username
- (void)changeUserName:(NSString *)aNewName
{
    NSString *changeUserNameUrl = nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:aNewName,@"newname", nil];
    kHubRequestUrl(@"changeProfile.ashx", changeUserNameUrl);
    [NetManager requestWith:dict url:changeUserNameUrl method:@"POST" operationKey:nil parameEncoding:AFJSONParameterEncoding succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

//load user image
- (void)UesrImageClicked
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.photoImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.imgView.image = image;
    
//    self.photoUrl = [[info objectForKey:@"UIImagePickerControllerMediaURL"] absoluteString];
    //    NSData *imageData = UIImageJPEGRepresentation(image, COMPRESSED_RATE);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    //    [HttpRequestManager uploadImage:compressedImage httpClient:self.httpClient delegate:self];
    
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
