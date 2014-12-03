//
//  HbhWorkerTableViewCell.h
//  Hubanghu
//
//  Created by Johnny's on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbhWorkerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *workerMountLabel;
@property (strong, nonatomic) IBOutlet UILabel *workYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *workerIcon;
@property (strong, nonatomic) IBOutlet UILabel *workerDistanceCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *workerScoreLabel;

- (instancetype)init;
@end
