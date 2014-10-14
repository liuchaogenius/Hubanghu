//
//  OrderTableViewCell.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-13.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbhOrderTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *typeLabel;
@property(nonatomic, strong) UILabel *workerLabel;
@property(nonatomic, strong) UILabel *workerNameLabel;
@property(nonatomic, strong) UILabel *urgentLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *orderStateLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
