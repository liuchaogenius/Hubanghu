//
//  HbhWorkerCommentTableViewCell.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-16.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbhWorkerCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;


- (instancetype)init;
@end
