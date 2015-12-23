//
//  MessageView.h
//  FaceBoardDome
//
//  Created by WhiZenBJ on 13-12-12.
//  Copyright (c) 2013年 Blue. All rights reserved.
//


#import <UIKit/UIKit.h>


#define KFacialSizeWidth    19

#define KFacialSizeHeight   19

#define KCharacterWidth     8


#define VIEW_LINE_HEIGHT    15

#define VIEW_LEFT           15

#define VIEW_RIGHT          15

#define VIEW_TOP            5


#define VIEW_WIDTH_MAX      SCREEN_WIDTH - VIEW_LEFT - VIEW_RIGHT

#define ATTRIBUTED_COLOR    RGB(73.0, 113.0, 246.0)

#define DEFAULT_COLOR       MAIN_TEXT_COLOR

#define SYSTEM_COLOR        APP_MAIN_COLOR

#define MESSAGE_FONT        [UIFont systemFontOfSize:14.0f]


@interface MessageView : UIView
{
    CGFloat upX;
    CGFloat upY;
    CGFloat lastPlusSize;
    BOOL isLineReturn;
}

- (void)showMessage:(NSString *)message messageType:(int)type attributedString:(NSString *)attrString;

/**
 * 解析输入的文本
 *
 * 根据文本信息分析出哪些是表情，哪些是文字
 */
+ (void)getMessageRange:(NSString*)message  messageArray:(NSMutableArray *)array;

/**
 *  获取文本尺寸
 */
+ (CGFloat)getContentSizeWithMessage:(NSString *)message;


@end
