//
//  HubAreasModel.h
//  Hubanghu
//
//  Created by  striveliu on 14-10-15.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HubAreasModel : NSObject
@property(nonatomic, strong) NSString *strAreaid;
@property(nonatomic, strong) NSString *strName;
@property(nonatomic, assign) int iLevel;
@property(nonatomic, strong) NSString *strParent;
@property(nonatomic, strong) NSString *strTypeName;
@property(nonatomic, strong) NSString *strFirstchar;
@end
