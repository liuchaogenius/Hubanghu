//
//  HbhTopTableViewCell.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbhTopTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *workerIcon;
@property (strong, nonatomic) IBOutlet UILabel *workerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerMountLabel;

@property(nonatomic, strong) UILabel *personLabel;
@property(nonatomic, strong) UILabel *successLabel;
@property(nonatomic, strong) UILabel *honorLabel;
- (instancetype)init;
@end
