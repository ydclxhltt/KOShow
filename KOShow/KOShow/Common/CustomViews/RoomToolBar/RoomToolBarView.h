//
//  RoomToolBarView.h
//  KOShow
//
//  Created by 陈磊 on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

typedef enum : NSUInteger {
    RoomToolBarViewTypeChat,
    RoomToolBarViewTypeComment,
} RoomToolBarViewType;

#import <UIKit/UIKit.h>

@interface RoomToolBarView : UIView

- (instancetype)initWithFrame:(CGRect)frame toolBarType:(RoomToolBarViewType)type;

@end
