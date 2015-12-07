//
//  VideoListCell.m
//  KOShow
//
//  Created by 陈磊 on 15/11/28.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_Y     10.0 * CURRENT_SCALE
#define ADD_Y       5.0 * CURRENT_SCALE
#define ADD_X       15.0 * CURRENT_SCALE

#import "VideoListCell.h"


@interface VideoListCell()

@end

@implementation VideoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    float x = SPACE;
    float y = SPACE_Y;
    float width = (SCREEN_WIDTH - 2 * SPACE - ADD_X)/2;
    float height = ROOM_LIST_HEIGHT - 2 * SPACE_Y;
    _leftView = [[VideoView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.contentView addSubview:_leftView];
    
    x += _leftView.frame.size.width + ADD_X;
    
    _rightView = [[VideoView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self.contentView addSubview:_rightView];
}

@end
