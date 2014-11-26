//
//  LeftView.m
//  Hubanghu
//
//  Created by  striveliu on 14-10-9.
//  Copyright (c) 2014年 striveliu. All rights reserved.
//

#import "LeftView.h"
#import "UIImageView+WebCache.h"
#import "HbhUser.h"
#import "ViewInteraction.h"

NSArray *itemArray;
@implementation LeftView
@synthesize selectItem;
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        itemArray = @[@"用户名",@"用户须知",@"服务承诺",@"服务标准",@"投诉反馈",@"关于户帮户",@"分享"];
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth*2/3, kMainScreenHeight)];
        self.leftTableView.scrollEnabled = NO;
        self.leftTableView.delegate = self;
        self.leftTableView.dataSource = self;
        UIImage *img = [[UIImage imageNamed:@"leftviewBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        self.leftTableView.backgroundColor = [UIColor colorWithPatternImage:img];//RGBCOLOR(47, 47, 47);
        self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.leftTableView];
    }
    return self;
}

#pragma mark tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 160;
    }else if(indexPath.row==1)
    {
        return 60;
    }
    else if (indexPath.row>1 && indexPath.row<7)
    {
        return 40;
    }
    else if (indexPath.row==7)
    {
        return kMainScreenHeight-160-60-40*5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = kClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth/3-40, 40, 80, 80)];
        imgView.layer.cornerRadius = 40;
        HbhUser *user = [HbhUser sharedHbhUser];
        [imgView sd_setImageWithURL:[NSURL URLWithString:user.photoUrl]
                   placeholderImage:[UIImage imageNamed:@"leftDefault"]];
        imgView.clipsToBounds = YES;
        imgView.backgroundColor = kClearColor;
        imgView.layer.borderWidth=1;
        imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell addSubview:imgView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/3-50, imgView.bottom+10, 100, 20)];
        label.font = kFont20;
        label.text = [itemArray objectAtIndex:indexPath.row];
        label.text = user.nickName;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(134, 134, 134);
        label.backgroundColor = kClearColor;
        [cell addSubview:label];
        UIView *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 159, kMainScreenWidth*2/3, 1)];
        lineView.backgroundColor = RGBCOLOR(74, 74, 74);
        [cell addSubview:lineView];
    }
    if (indexPath.row>=1&&indexPath.row<7)
    {
        UIImageView *imgView;
        UILabel *label;
        UIView *lineView;
        if (indexPath.row==1)
        {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 20, 20)];
            imgView.tag = 1;
            label = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 100, 20)];
            label.tag = 2;
            lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, kMainScreenWidth*2/3, 1)];
        }
        else if (indexPath.row>1&&indexPath.row<7)
        {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
            imgView.tag = 1;
            label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
            label.tag = 2;
            lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, kMainScreenWidth*2/3, 1)];
        }
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leftItem%d", (int)indexPath.row]]];
        imgView.backgroundColor = kClearColor;
        [cell addSubview:imgView];
        label.text = [itemArray objectAtIndex:indexPath.row];
        label.textColor = RGBCOLOR(147, 147, 147);
        label.font = kFont15;
        label.backgroundColor = kClearColor;
        [cell addSubview:label];
        lineView.backgroundColor = RGBCOLOR(74, 74, 74);
        [cell addSubview:lineView];
    }
    if (indexPath.row==7)
    {
        CGFloat cellHeight = kMainScreenHeight-160-60-40*5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/3-40, (cellHeight-50)/2, 80, 20)];
        label.font = kFont15;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBCOLOR(147, 147, 147);
        label.text = @"客服热线";
        label.backgroundColor = kClearColor;
        [cell addSubview:label];
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/3-70, label.bottom+10, 140, 20)];
        phoneLabel.textColor = RGBCOLOR(147, 147, 147);
        phoneLabel.textAlignment = NSTextAlignmentCenter;
        phoneLabel.font = kFont20;
        phoneLabel.text = @"400-663-8585";
        phoneLabel.backgroundColor = kClearColor;
        [cell addSubview:phoneLabel];
    }
    return cell;
}

#pragma mark tableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ViewInteraction viewDissmissAnimationToLeft:self isRemove:NO completeBlock:^(BOOL isComplete) {
        
    }];
    MLOG(@"%d",indexPath.row);
    if(indexPath.row == 1)
    {
        self.selectItem = E_USERINTRODUCE;
    }
    else if(indexPath.row == 2)
    {
        self.selectItem = E_SERVICECOMMIT;
    }
    else if(indexPath.row == 3)
    {
        self.selectItem = E_SERVICESTANDARD;
    }
    else if(indexPath.row == 4)
    {
        self.selectItem = E_FEEDBACK;
    }
    else if(indexPath.row == 5)
    {
        self.selectItem = E_ABOUTUS;
    }
    else if(indexPath.row == 6)
    {
        self.selectItem = E_SHAREHBH;
    }
}

+ (NSString *)getIntroduceUrl:(int)aIndex title:(NSString **)aTitle
{
    NSString *strUrl = nil;
    switch (aIndex) {
        case E_USERINTRODUCE:
            kHubRequestUrl(@"UserInstructions.html", strUrl);
            *aTitle = @"用户须知";
            break;
        case E_SERVICECOMMIT:
            kHubRequestUrl(@"ServicePromise.html", strUrl);
            *aTitle = @"服务承诺";
            break;
        case E_SERVICESTANDARD:
            kHubRequestUrl(@"ServiceStandards.html", strUrl);
            *aTitle = @"服务标准";
            break;
        case E_FEEDBACK:
            kHubRequestUrl(@"ComplaintsFeedback.html", strUrl);
            *aTitle = @"投诉反馈";
            break;
        case E_ABOUTUS:
            kHubRequestUrl(@"AboutH8H.html", strUrl);
            *aTitle = @"关于户帮户";
            break;
        case E_SHAREHBH:
            kHubRequestUrl(@"Share.htm", strUrl);
            *aTitle = @"分享";
            break;
        default:
            break;
    }
    return strUrl;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    CGRect tableRect = self.leftTableView.frame;
    if(!CGRectContainsPoint(tableRect, point))
    {
        [ViewInteraction viewDissmissAnimationToLeft:self isRemove:NO completeBlock:^(BOOL isComplete) {
            
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
