//
//  HbhAppointmentDetailsTableViewCell.h
//  Hubanghu
//
//  Created by qf on 14/10/17.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HbhAppointmentDelegate <NSObject>

- (void)didDatePickerAppear;
- (void)didDatePickerDisappear;
@end

@interface HbhAppointmentDetailsTableViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *detailAreaTF;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic) id<HbhAppointmentDelegate> delegate;
@end
