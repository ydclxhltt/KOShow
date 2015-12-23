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


@protocol RoomToolBarViewDelegate;

#import <UIKit/UIKit.h>
#import "GiftListView.h"

@interface RoomToolBarView : UIView

@property (nonatomic, strong) id<RoomToolBarViewDelegate> delegate;
@property (nonatomic, strong) GiftListView *giftView;


- (instancetype)initWithFrame:(CGRect)frame toolBarType:(RoomToolBarViewType)type;
- (void)resetGiftView;

@end

@protocol RoomToolBarViewDelegate <NSObject>

@optional

- (void)roomToolBarView:(RoomToolBarView *)roomToolBarView sendMessage:(NSString *)message;

@end
