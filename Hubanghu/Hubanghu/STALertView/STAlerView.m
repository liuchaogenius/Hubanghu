//
//  STAlerView.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-14.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "STAlerView.h"

@interface STAlertView () <UIAlertViewDelegate>

@property (copy, nonatomic) void (^clickedBlock)(STAlertView *, BOOL, NSInteger);

@end

@implementation STAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       clickedBlock:(void (^)(STAlertView *alertView, BOOL cancelled, NSInteger buttonIndex))clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil ];
    
    if (self) {
        _clickedBlock = clickedBlock;
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _clickedBlock(self, buttonIndex==self.cancelButtonIndex, buttonIndex);
}

@end
