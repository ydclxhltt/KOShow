//
//  AdvView.h
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdvViewClickedDelegate;

@interface AdvView : UIView

@property (nonatomic, strong) NSMutableArray *advArray;
@property (nonatomic, assign) id<AdvViewClickedDelegate> delegate;

-(void)setAdvData:(id)advData;

@end

@protocol AdvViewClickedDelegate <NSObject>

@optional

- (void)advView:(AdvView *)advView clickedAtIndex:(int)index;

@end