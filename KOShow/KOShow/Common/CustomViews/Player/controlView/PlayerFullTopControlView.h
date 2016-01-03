//
//  PlayerFullTopControlView.h
//  KOShow
//
//  Created by 陈磊 on 15/12/7.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerFullTopControlViewDelegate;

@interface PlayerFullTopControlView : UIView

@property (nonatomic, assign) id<PlayerFullTopControlViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame roomName:(NSString *)name buttonArray:(NSArray *)array;
- (void)addRoomNameLabelWithName:(NSString *)name;

@end

@protocol PlayerFullTopControlViewDelegate <NSObject>

@optional

- (void)playerFullTopControlViewBackButtonPressed:(UIButton *)sender;

@end