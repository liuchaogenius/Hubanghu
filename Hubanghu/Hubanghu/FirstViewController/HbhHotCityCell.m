//
//  HbhHotCityCell.m
//  Hubanghu
//
//  Created by yato_kami on 14/10/21.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "HbhHotCityCell.h"

@implementation HbhHotCityCell

- (void)awakeFromNib {
    // Initialization code 90
    UIButton *button = self.hotCityButtons[0];
    for (button in self.hotCityButtons) {
        int i = button.tag;
        button.center = CGPointMake(0, 0);
        [button setFrame:CGRectMake(kMainScreenWidth - 40 + (i-1)*(kMainScreenWidth-40-60*4)/3.0f, i < 5 ? 10.0 : (90-10-32), 60, 32)];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
