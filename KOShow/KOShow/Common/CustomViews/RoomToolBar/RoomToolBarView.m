//
//  RoomToolBarView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X             10.0
#define SPACE_Y             5.0
#define BG_COLOR            RGB(242.0,243.0,244.0)
#define ICON_WH             29.0
#define TEXTFIELD_HEIGHT    ICON_WH

#import "RoomToolBarView.h"

@interface RoomToolBarView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation RoomToolBarView

- (instancetype)initWithFrame:(CGRect)frame toolBarType:(RoomToolBarViewType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BG_COLOR;
        self.originFrame = frame;
        [self initUIWithType:type];
        [self addNotifications];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUIWithType:(RoomToolBarViewType)type
{
    float textFieldWidth = self.frame.size.width - 3 * SPACE_X - ((type == RoomToolBarViewTypeComment) ? ICON_WH : (2 * ICON_WH + SPACE_X));
    float x = SPACE_X;
    float y = (self.frame.size.height - ICON_WH)/2;
    
    _messageTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(x,y, textFieldWidth, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入您想说的话...."];
    _messageTextField.borderStyle = UITextBorderStyleRoundedRect ;
    _messageTextField.backgroundColor = [UIColor whiteColor];
    _messageTextField.delegate = self;
    _messageTextField.returnKeyType = UIReturnKeySend;
    [self addSubview:_messageTextField];
    
    x = self.frame.size.width - SPACE_X - ICON_WH;
    _shareButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, ICON_WH, ICON_WH) buttonImage:@"icon_share" selectorName:@"shareButtonPressed:" tagDelegate:self];
    [self addSubview:_shareButton];
    
    x = _messageTextField.frame.size.width + _messageTextField.frame.origin.x + SPACE_X;
    if (type == RoomToolBarViewTypeChat)
    {
        _giftButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, ICON_WH, ICON_WH) buttonImage:@"icon_gift" selectorName:@"giftButtonPressed:" tagDelegate:self];
        [self addSubview:_giftButton];
    }
}

#pragma mark 分享按钮
- (void)shareButtonPressed:(UIButton *)sender
{
    [self.messageTextField resignFirstResponder];
}

#pragma mark 礼物按钮
- (void)giftButtonPressed:(UIButton *)sender
{
    [self.messageTextField resignFirstResponder];
}


#pragma mark 添加通知
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotinficaiton:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotinficaiton:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppearanceNotinficaiton:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyBoardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = self.frame;
    frame.origin.y -= keyBoardSize.height;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                     animations:^{
                         self.frame = (notification.name == UIKeyboardWillShowNotification) ? frame : self.originFrame;
                     }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
