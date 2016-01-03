//
//  VideoView.h
//  KOShow
//
//  Created by 陈磊 on 15/11/27.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoView : UIView

@property (nonatomic, strong) UIButton *clickButton;

- (void)setVideoDataWithImageUrl:(NSString *)imageUrl anchorName:(NSString *)name onlineCount:(int)count roomName:(NSString *)roomName;


@end
