//
//  RoomToolBarView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define BG_COLOR    RGB(242.0,243.0,244.0)

#import "RoomToolBarView.h"

@implementation RoomToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = BG_COLOR;
    }
    return self;
}


@end
