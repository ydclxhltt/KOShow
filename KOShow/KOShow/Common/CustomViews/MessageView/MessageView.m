//
//  MessageView.m
//  FaceBoardDome
//
//  Created by WhiZenBJ on 13-12-12.
//  Copyright (c) 2013年 Blue. All rights reserved.
//

#import "MessageView.h"

@interface MessageView()

@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSString *attrString;
@property (nonatomic, assign) float messageType;
@property (nonatomic, assign) BOOL isHasImage;

@end

@implementation MessageView

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showMessage:(NSString *)message messageType:(int)type attributedString:(NSString *)attrString
{
    _messageArray = [[NSMutableArray alloc] initWithCapacity:0];
    [MessageView getMessageRange:message messageArray:_messageArray];
    self.messageType = type;
    self.attrString = (attrString) ? attrString : @"";
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

	if (self.messageArray)
    {
        NSDictionary *faceMap = [KOShowShareApplication shareApplication].emojiDictionary;
        
        UIFont *font = MESSAGE_FONT;
        
        isLineReturn = NO;

        upX = VIEW_LEFT;
        upY = VIEW_TOP;

		for (int index = 0; index < [self.messageArray count]; index++)
        {

			NSString *str = [self.messageArray objectAtIndex:index];
			if ([str hasPrefix:@"["] && [str hasSuffix:@"]"])
            {
                NSArray *imageNames = [faceMap allKeysForObject:str];
                NSString *imageName = [imageNames objectAtIndex:0];

                UIImage *image = [UIImage imageNamed:imageName];

                if (image)
                {
//                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                    if ( upX > VIEW_WIDTH_MAX)
                    {
                        isLineReturn = YES;
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT + VIEW_TOP;
                    }

                    [image drawInRect:CGRectMake(upX, upY - (KFacialSizeHeight - VIEW_LINE_HEIGHT), KFacialSizeWidth, KFacialSizeHeight)];

                    upX += KFacialSizeWidth;

                    lastPlusSize = KFacialSizeWidth;
                }
                else
                {

                    [self drawText:str withFont:font];
                }
			}
            else
            {
                [self drawText:str withFont:font];
			}
        }
	}
}

- (void)drawText:(NSString *)string withFont:(UIFont *)font
{
    for ( int index = 0; index < string.length; index++)
    {
        UIColor *messageColor = DEFAULT_COLOR;
        if (self.messageType == -1)
        {
            messageColor = SYSTEM_COLOR;
        }
        else
        {
            if (self.attrString.length > 0 && self.attrString.length < string.length && [self.attrString isEqualToString:[string substringToIndex:self.attrString.length]])
            {
                messageColor = (index < self.attrString.length) ? ATTRIBUTED_COLOR : DEFAULT_COLOR;
            }
        }
        
        NSString *character = [string substringWithRange:NSMakeRange(index, 1)];
        
        CGSize size  = ([character boundingRectWithSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil]).size;

        if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) )
        {

            isLineReturn = YES;

            upX = VIEW_LEFT;
            upY += VIEW_LINE_HEIGHT + VIEW_TOP;
        }
        float y = upY;
        
        [character drawInRect:CGRectMake(upX, y, size.width, self.bounds.size.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:messageColor}];
        upX += size.width;

        lastPlusSize = size.width;
    }
}



/**
 * 解析输入的文本
 *
 * 根据文本信息分析出哪些是表情，哪些是文字
 */
+ (void)getMessageRange:(NSString*)message  messageArray:(NSMutableArray *)array
{

    NSRange rangeL=[message rangeOfString:@"["];
    NSRange rangeR=[message rangeOfString:@"]"];
    
    //判断当前字符串是否还有表情的标志。
    if (rangeL.length && rangeR.length)
    {
        
        if (rangeL.location > 0)
        {
            
            [array addObject:[message substringToIndex:rangeL.location]];
            [array addObject:[message substringWithRange:NSMakeRange(rangeL.location, rangeR.location + 1 - rangeL.location)]];
            
            NSString *str = [message substringFromIndex:rangeR.location + 1];
            [self getMessageRange:str messageArray:array];
        }
        else
        {
            NSString *nextstr = [message substringWithRange:NSMakeRange(rangeL.location, rangeR.location + 1 - rangeL.location)];
            //排除“”空字符串
            if (![nextstr isEqualToString:@""])
            {
                [array addObject:nextstr];
                
                NSString *str = [message substringFromIndex:rangeR.location + 1];
                [self getMessageRange:str messageArray:array];
            }
            else
            {
                return;
            }
        }
    }
    else
    {
        [array addObject:message];
    }
}

/**
 *  获取文本尺寸
 */
+ (CGFloat)getContentSizeWithMessage:(NSString *)message
{
    CGFloat x = 0.0;
    
    CGFloat y = 0.0;
    
    CGFloat lastAddSize;
    
    CGFloat viewHeight;
    
    int returnCount = 1.0;
    
    NSMutableArray *messageRange = [[NSMutableArray alloc] initWithCapacity:0];
    [MessageView getMessageRange:message messageArray:messageRange];
    
    NSDictionary *faceMap = [KOShowShareApplication shareApplication].emojiDictionary;
    
    UIFont *font = MESSAGE_FONT;
    
    x = VIEW_LEFT;
    y = VIEW_TOP;
    
    for (int index = 0; index < [messageRange count]; index++)
    {
        NSString *str = [messageRange objectAtIndex:index];
        if ([str hasPrefix:@"["] && [str hasSuffix:@"]"])
        {
            NSArray *imageNames = [faceMap allKeysForObject:str];
            NSString *imageName = [imageNames objectAtIndex:0];
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
            
            if (imagePath)
            {
                if ( x > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) )
                {
                    
                    returnCount++;
                    
                    x = VIEW_LEFT;
                    y += VIEW_LINE_HEIGHT + VIEW_TOP;
                }
                
                x += KFacialSizeWidth;
                
                lastAddSize = KFacialSizeWidth;
            }
            else
            {
                for ( int index = 0; index < str.length; index++)
                {
                    
                    NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                    
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                    
                    if ( x > ( VIEW_WIDTH_MAX - KCharacterWidth ) )
                    {
                        
                        returnCount++;
                        
                        x = VIEW_LEFT;
                        y += VIEW_LINE_HEIGHT + VIEW_TOP;
                    }
                    
                    x += size.width;
                    
                    lastAddSize = size.width;
                }
            }
        }
        else
        {
            
            for ( int index = 0; index < str.length; index++)
            {
                
                NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                
                CGSize size = [character sizeWithFont:font
                                    constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                
                if ( x > ( VIEW_WIDTH_MAX - KCharacterWidth ) )
                {
                    
                    returnCount++;
                    
                    x = VIEW_LEFT;
                    y += VIEW_LINE_HEIGHT + VIEW_TOP;
                }
                
                x += size.width;
                
                lastAddSize = size.width;
            }
        }
    }
    
    viewHeight = y + VIEW_LINE_HEIGHT + VIEW_TOP;
    
    return viewHeight;
}

@end
