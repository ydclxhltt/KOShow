//
//  MessageListCell.m
//  KOShow
//
//  Created by 陈磊 on 15/12/24.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (void)awakeFromNib
{
    // Initialization code
}

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
    _messageView = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    [self.contentView addSubview:_messageView];
}

- (void)setMessageWithText:(NSString *)message type:(int)type attributedString:(NSString *)attrString
{
    [_messageView showMessage:message messageType:type attributedString:attrString];
    float height = [MessageView getContentSizeWithMessage:message];
    CGRect frame = _messageView.frame;
    frame.size.height = height;
    _messageView.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
