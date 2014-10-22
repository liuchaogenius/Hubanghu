//
//  HbhHotCityCell.h
//  Hubanghu
//
//  Created by yato_kami on 14/10/21.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define hCellHight 90.0

@interface HbhHotCityCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotCityButtons;

@end
