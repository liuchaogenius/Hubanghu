//
//  SImageUtil.m
//  Hubanghu
//
//  Created by  striveliu on 14/11/25.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "SImageUtil.h"

@implementation SImageUtil
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
