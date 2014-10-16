//
//  HbhQRcodeViewController.m
//  Hubanghu
//
//  Created by yato_kami on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhQRcodeViewController.h"
#import "HbhUser.h"
#import "UIImageView+AFNetworking.h"

@interface HbhQRcodeViewController ()

@end

@implementation HbhQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _UserPhotoImageView.layer.cornerRadius = _UserPhotoImageView.frame.size.height/2.0f;
    _UserPhotoImageView.layer.masksToBounds = YES;
    [_UserPhotoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_UserPhotoImageView setClipsToBounds:YES];
    
    HbhUser *user = [HbhUser sharedHbhUser];
    if (user.isLogin) {
        self.nickName.text = user.nickName;
        [self.UserPhotoImageView setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserPhoto_hightLight"]];
        [self.QRcodeImageView setImageWithURL:[NSURL URLWithString:user.QRCodeUrl]];
    }
    
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
