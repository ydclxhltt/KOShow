//
//  PlayerFullTopControlView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X         PLAYER_SPACE_X
#define SPACE_Y         10.0
#define ADD_X           SPACE_X
#define BUTTON_WIDTH    60.0


#import "PlayerFullTopControlView.h"

@interface PlayerFullTopControlView()
{
    float start_x;
    float right_x;
}

@property (nonatomic, strong) UILabel *roomNameLabel;

@end

@implementation PlayerFullTopControlView

- (instancetype)initWithFrame:(CGRect)frame roomName:(NSString *)name buttonArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = PLAYER_CONTROL_VIEW_COLOR;
        start_x = SPACE_X;
        [self initUIWithRoomName:name buttonArray:array];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUIWithRoomName:(NSString *)name buttonArray:(NSArray *)array
{
    [self backButton];
    [self addButtonsWithArray:array];
    [self addRoomNameLabelWithName:name];
}

- (void)backButton
{
    UIImage *backImage = [UIImage imageNamed:@"player_back_up"];
    float y = (NAVBAR_HEIGHT - backImage.size.height/3)/2 + STATUS_BAR_HEIGHT;
    UIButton *backButton = [CreateViewTool createButtonWithFrame:CGRectMake(start_x, y, backImage.size.width/3, backImage.size.height/3) buttonImage:@"player_back" selectorName:@"backButtonPressed:" tagDelegate:self];
    [self addSubview:backButton];
    start_x += backButton.frame.size.width + ADD_X;
}

- (void)addButtonsWithArray:(NSArray *)array
{
    if ([array count] == 0 || !array)
    {
        return;
    }
    for (int i = 0; i < [array count]; i ++)
    {
        float x = self.frame.size.width - (i + 1) * BUTTON_WIDTH;
        float y = STATUS_BAR_HEIGHT;
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, BUTTON_WIDTH, self.frame.size.height - y) buttonTitle:array[i] titleColor:[UIColor whiteColor] normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:[UIColor clearColor] selectorName:@"buttonPressed:" tagDelegate:self];
        button.showsTouchWhenHighlighted = YES;
        button.titleLabel.font = FONT(15.0);
        button.tag = 100 + i;
        [self addSubview:button];
        
        if (i != [array count] - 1)
        {
            UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, button.frame.origin.y + SPACE_Y, LINT_WIDTH, button.frame.size.height - 2 * SPACE_Y) placeholderImage:nil];
            imageView.backgroundColor = LINE_COLOR;
            [self addSubview:imageView];
        }
        right_x = x;
    }
}

- (void)addRoomNameLabelWithName:(NSString *)name
{
    name = name ? name : @"";
    if (!_roomNameLabel)
    {
        UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(start_x, STATUS_BAR_HEIGHT + SPACE_Y, LINT_WIDTH, self.frame.size.height - STATUS_BAR_HEIGHT - 2 * SPACE_Y) placeholderImage:nil];
        imageView.backgroundColor = LINE_COLOR;
        [self addSubview:imageView];
        start_x += 10.0;
        float width = right_x - start_x - ADD_X;
        _roomNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, STATUS_BAR_HEIGHT, width, self.frame.size.height - STATUS_BAR_HEIGHT) textString:name textColor:[UIColor whiteColor] textFont:FONT(15.0)];
        [self addSubview:_roomNameLabel];
    }
    else
    {
        _roomNameLabel.text = name;
    }

}

#pragma mark 返回按钮
- (void)backButtonPressed:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerFullTopControlViewBackButtonPressed:)])
    {
        [self.delegate playerFullTopControlViewBackButtonPressed:sender];
    }
}


@end
