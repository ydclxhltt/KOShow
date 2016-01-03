//
//  MessageListCell.h
//  KOShow
//
//  Created by 陈磊 on 15/12/24.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageView.h"

@interface MessageListCell : UITableViewCell

@property (nonatomic, strong) MessageView *messageView;

- (void)setMessageWithText:(NSString *)message type:(int)type attributedString:(NSString *)attrString;

@end
