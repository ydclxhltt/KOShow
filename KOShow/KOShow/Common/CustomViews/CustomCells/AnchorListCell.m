//
//  AnchorListCell.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "AnchorListCell.h"

@implementation AnchorListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //初始化视图
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addAnchorView];
}

- (void)addAnchorView
{
    _anchorListView = [[AnchorListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ANCHORVIEW_HEIGHT)];
    [self.contentView addSubview:_anchorListView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
