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
#define ICON_WH             30.0
#define TEXTFIELD_HEIGHT    35.0
#define EMOJIVIEW_HEIGHT    216.0
#define GIFTVIEW_HEIGHT     240.0

#import "RoomToolBarView.h"
#import "EmojiView.h"
#import "GiftListView.h"

@interface RoomToolBarView()<UITextFieldDelegate,EmojiViewDelegate>

@property (nonatomic, strong) UITextField *messageTextField;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) EmojiView *emojiView;


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
    
    _messageTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(x,(self.frame.size.height - TEXTFIELD_HEIGHT)/2, textFieldWidth, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"说点什么吧...."];
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
        
        UIImageView *rightView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, TEXTFIELD_HEIGHT, TEXTFIELD_HEIGHT) placeholderImage:nil];
        _faceButton = [CreateViewTool createButtonWithFrame:CGRectMake((rightView.frame.size.width - ICON_WH)/2, (rightView.frame.size.height - ICON_WH)/2, ICON_WH, ICON_WH) buttonImage:@"icon_face" selectorName:@"faceButtonPressed:" tagDelegate:self];
        [rightView addSubview:_faceButton];
        _messageTextField.rightView = rightView;
        _messageTextField.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void)addGiftView
{
    if (!_giftView)
    {
        NSDictionary *giftDic = [KOShowShareApplication shareApplication].giftDictionary;
        _giftView = [[GiftListView alloc] initWithFrame:CGRectMake(0, self.superview.frame.size.height, self.frame.size.width, GIFTVIEW_HEIGHT) giftArray:[giftDic allValues]];
        _giftView.backgroundColor = [UIColor whiteColor];
        _giftView.delegate = self.delegate;
        [self.superview addSubview:_giftView];
        //_giftView.delegate = self;
    }
}

- (void)addEmojiView
{
    if (!_emojiView)
    {
        _emojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, EMOJIVIEW_HEIGHT)];
        _emojiView.backgroundColor = self.backgroundColor;
        _emojiView.delegate = self;
    }
}

#pragma mark 分享按钮
- (void)shareButtonPressed:(UIButton *)sender
{
    [self.messageTextField resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^
     {
         self.frame = CGRectMake(self.originFrame.origin.x, self.originFrame.origin.y, self.originFrame.size.width,self.originFrame.size.height);
     }];
}

#pragma mark 礼物按钮
- (void)giftButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.messageTextField resignFirstResponder];
    [self addGiftView];
    [UIView animateWithDuration:0.25 animations:^
     {
         self.frame = CGRectMake(self.originFrame.origin.x, self.originFrame.origin.y, self.originFrame.size.width,self.originFrame.size.height);
     }
     completion:^(BOOL finish)
     {
         
         float y = (sender.selected) ? self.superview.frame.size.height - self.frame.size.height - GIFTVIEW_HEIGHT : self.superview.frame.size.height;
         self.giftView.frame = CGRectMake(self.giftView.frame.origin.x, y, self.giftView.frame.size.width,self.giftView.frame.size.height);
     }];
  
}

- (void)resetGiftView
{
    [self giftButtonPressed:self.giftButton];
}

#pragma mark 表情按钮
- (void)faceButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [sender setBackgroundImage:[UIImage imageNamed:(sender.selected) ? @"icon_keyboard_up" : @"icon_face_up"] forState:UIControlStateNormal];
    [self.messageTextField resignFirstResponder];

    [self addEmojiView];
    self.messageTextField.inputView = (sender.selected) ? _emojiView : nil;
    
    NSLog(@"=====%@",NSStringFromCGRect(self.originFrame));

    [UIView animateWithDuration:0.25 animations:^
    {
        self.frame = CGRectMake(self.originFrame.origin.x, self.originFrame.origin.y, self.originFrame.size.width,self.originFrame.size.height);
    }
    completion:^(BOOL finish)
    {
        if ((sender.selected))
        {
            self.frame = CGRectMake(self.originFrame.origin.x, self.originFrame.origin.y - _emojiView.frame.size.height, self.originFrame.size.width,self.originFrame.size.height);
        }
        [self.messageTextField becomeFirstResponder];
    }];
    
    
}

#pragma mark 添加通知
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotinficaiton:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotinficaiton:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppearanceNotinficaiton:(NSNotification *)notification
{
    if (self.faceButton.selected)
    {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyBoardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect frame = self.frame;
    frame.origin.y -= keyBoardSize.height;
    NSTimeInterval time = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:time
                     animations:^{
                         self.frame = (notification.name == UIKeyboardWillShowNotification) ? frame : self.originFrame;
                     }];
}


#pragma mark EmojiViewDelegate
-(void)emojiView:(EmojiView *)emojiView didSelectEmoji:(NSString *)emoji
{
    self.messageTextField.text = [self.messageTextField.text stringByAppendingString:emoji];
}

-(void)emojiView:(EmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton
{
    NSString *inputString;
    inputString = self.messageTextField.text;
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0)
    {
        
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]])
        {
            
            if ([inputString rangeOfString:@"["].location == NSNotFound)
            {
                
                string = [inputString substringToIndex:stringLength - 1];
            }
            else
            {
                string = [inputString substringToIndex:
                          [inputString rangeOfString:@"["
                                             options:NSBackwardsSearch].location];
            }
        }
        else
        {
            
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.messageTextField.text = string;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSString *message = textField.text ? textField.text : @"";
    if (message.length == 0)
    {
        return YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomToolBarView:sendMessage:)])
    {
        [self.delegate roomToolBarView:self sendMessage:message];
    }
    textField.text = @"";
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //点击了非删除键
    if( [string length] == 0 )
    {
        if (range.length > 1 )
        {
            return YES;
        }
        else
        {
            [self emojiView:self.emojiView didPressDeleteButton:nil];
            return NO;
        }
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
