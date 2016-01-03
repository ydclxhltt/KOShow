//
//  LiveRoomViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/5.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ADD_Y               5.0
#define SPACE_X             5.0
#define ADD_X               15.0
#define ADD_X1              10.0
#define LABEL_HEIGHT        20.0
#define LABEL_WIDTH         200.0
#define R_LABEL_WIDTH       20.0
#define R_LABEL_HEIGHT      20.0
#define ICON_WIDTH          45.0
#define ICON_HEIGHT         20.0
#define ROW_HEIGHT          44.0
#define CHAT_ROW_HEIGHT     25.0
#define HEADER_HEIGHT       50.0
//chat
#define CHAT_HEADER_HEIGHT  35.0
#define HEADER_SPACE_X      15.0
#define LABEL_WIDTH         200.0
#define DETAIL_LINE_COLOR   RGB(233.0,233.0,233.0)
#define FOCUS_BUTTON_WH     20.0


#import "LiveRoomViewController.h"
#import "AnchorDetailView.h"
#import "BarrageHeader.h"
#import "BarrageSpriteUtility.h"
#import "UIImage+Barrage.h"
#import "KOShowSocketTool.h"
#import "MessageView.h"
#import "MessageListCell.h"
#import "GiftListCell.h"

@interface LiveRoomViewController()<UITableViewDataSource,UITableViewDelegate,KOShowSocketDelegate,RoomToolBarViewDelegate,GiftListViewDelegate>
{
    NSTimer * timer;
    NSInteger count;
   
}
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UITableView *rankTableView;
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;
@property (nonatomic, strong) BarrageRenderer *barrageRenderer;
@property (nonatomic, strong) KOShowSocketTool *socketTool;
@property (nonatomic, strong) NSMutableArray *chatDataArray;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;
@property (nonatomic, assign) BOOL detailIsLoading;
@property (nonatomic, assign) BOOL rankIsLoading;
@property (nonatomic, strong) NSString *anchorDetailText;
@property (nonatomic, strong) NSArray *rankArray;

@end

@implementation LiveRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGiftSucess) name:@"GetGiftSucess" object:nil];
    
    _chatDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_chatDataArray addObject:@{@"type":@(-1),@"message":@"正在连接服务器..."}];
    
    _rowHeightArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (self.roomToolBarView)
    {
        self.roomToolBarView.giftArray = [KOShowShareApplication shareApplication].giftArray;
    }
    
    _socketTool = [[KOShowSocketTool alloc] init];
    _socketTool.delegate = self;
    NSString *socketServerIP = [[KOShowShareApplication shareApplication] socketServerIP];
    NSString *socketPort = [[KOShowShareApplication shareApplication] socketPort];
    [_socketTool contentServerWithIp:socketServerIP port:[socketPort intValue]];
    
    // Do any additional setup after loading the view.
}

#pragma mark  功能按钮响应事件
- (void)buttonBarButtonPressed:(UIButton *)sender
{
    int tag = (int)sender.tag - 100;
    sender.selected = YES;
    self.roomToolBarView.hidden = (tag == 0) ? NO : YES;
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = (UIButton *)[self.downSideView viewWithTag:100 + i];
        UIView *view = (UIView *)[self.downSideView viewWithTag:1000 + i];
        if (i != tag)
        {
            if (button)
            {
                button.selected = NO;
            }
            if (view)
            {
                view.hidden = YES;
            }
        }
        else
        {
            if (view)
            {
                view.hidden = NO;
            }
        }
    }
    [self addViewWithIndex:tag];
}

#pragma mark 添加视图
- (void)addViewWithIndex:(int)index
{
    if (index == 0)
    {
        [self addChatTable];
    }
    else if (index == 1)
    {
        [self addAnchorView];
    }
    else if (index == 2)
    {
        [self addRankView];
    }
}

- (void)addChatTable
{
    if (_chatTableView)
    {
        [_chatTableView reloadData];
        return;
    }
    _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - TOOL_BAR_HEIGHT - ADD_Y) style:UITableViewStylePlain];
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    _chatTableView.backgroundColor = [UIColor whiteColor];
    _chatTableView.tag = 1000;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.downSideView addSubview:_chatTableView];
}

- (void)addAnchorView
{
    if (!_anchorDetailView)
    {
        _anchorDetailView = [[AnchorDetailView alloc] initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - ADD_Y)];
        _anchorDetailView.tag = 1001;
        [self.downSideView addSubview:_anchorDetailView];
    }
    [self getAnchorDetailRequest];
    [_anchorDetailView setAnchorDataWithImageUrl:[[KOShowShareApplication shareApplication] makeImageUrlWithRightHalfString:self.playDataDic[@"small_header_url"]] anchorName:self.playDataDic[@"nickname"] roomName:self.playDataDic[@"title"] anchorDetailText:self.anchorDetailText];
    
}

- (void)addRankView
{
    if (!_rankTableView)
    {
        _rankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - ADD_Y) style:UITableViewStylePlain];
        _rankTableView.dataSource = self;
        _rankTableView.delegate = self;
        _rankTableView.backgroundColor = [UIColor clearColor];
        _rankTableView.tag = 1002;
    }
    [self.downSideView addSubview:_rankTableView];
    [self getRankListRequest];
}


#pragma mark 设置弹幕
- (void)setBarrageRendererView
{
//    if (!_barrageRenderer)
//    {
//        _barrageRenderer = [[BarrageRenderer alloc]init];
//        [self.upSideView addSubview:_barrageRenderer.view];
//    }
//    
//    if (self.playerViewSize == PlayerViewSizeFullScreen)
//    {
//        [_barrageRenderer start];
//    }
//    else
//    {
//        [_barrageRenderer stop];
//    }
//    [self setTimer];
}

- (void)setTimer
{
    count = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoSendBarrage) userInfo:nil repeats:YES];
    if (self.playerViewSize == PlayerViewSizeSmallScreen)
    {
        [timer invalidate];
        timer = nil;
    }

}

- (void)autoSendBarrage
{
    if (count >= [self.chatDataArray count])
    {
        return;
    }
    [_barrageRenderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
}

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.chatDataArray[(long)count++][@"message"];
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
}


#pragma mark 登录房间
- (void)sendLoginRoomRequest
{
    [self.chatDataArray addObject:@{@"type":@(-1),@"message":@"正在连接房间..."}];
    NSString *userID = [[KOShowShareApplication shareApplication] userInfoDictionary][@"id"];
    NSString *nickName = [[KOShowShareApplication shareApplication] userInfoDictionary][@"nickname"];
    NSString *roomID = self.playDataDic[@"room_id"];
    [self.socketTool sendLoginRoomRequestWithUserID:userID nickName:nickName roomID:roomID];
}

#pragma mark 发送心跳包
- (void)sendHeartRequest
{
    [self.socketTool createHeartTimer];
}

#pragma mark 发送消息
- (void)roomToolBarView:(RoomToolBarView *)roomToolBarView sendMessage:(NSString *)message
{
    [self.socketTool sendRoomMessageRequestWithType:0 message:message];
}

#pragma mark 获取礼物
- (void)roomToolBarView:(RoomToolBarView *)roomToolBarView giftButtonPressed:(UIButton *)sender
{
    [DELEGATE getGiftListShowLoading:YES];
}

#pragma mark 获取礼物成功
- (void)getGiftSucess
{
    self.roomToolBarView.giftArray = [KOShowShareApplication shareApplication].giftArray;
    [self.roomToolBarView giftButtonPressed:self.roomToolBarView.giftButton];
}

#pragma mark 发送礼物
- (void)giftListView:(GiftListView *)giftView didSelectedGiftAtIndex:(int)index
{
    [self.roomToolBarView resetGiftView];
    NSString *giftID = giftView.giftArray[index][@"id"];
    giftID = giftID ? giftID : @"";
    if (giftID.length == 0)
    {
        return;
    }
    NSString *anchorID = self.playDataDic[@"anchor_id"];
    anchorID = anchorID ? anchorID : @"";
    [self.socketTool sendRoomGiftRequestWithGiftID:giftID anchorID:anchorID giftCount:1];
}

#pragma mark KOShowSocketDelegate
//已连接服务器
- (void)koShowSocketDidConnected:(KOShowSocketTool *)socket
{
    [self.chatDataArray addObject:@{@"type":@(-1),@"message":@"服务器连接成功."}];
    [self sendLoginRoomRequest];
    [self.chatTableView reloadData];
}


//登录房间成功
- (void)koShowSocketLoginRoomSucess:(KOShowSocketTool *)socket
{
    [self.chatDataArray addObject:@{@"type":@(-1),@"message":@"房间连接成功."}];
    [self.chatTableView reloadData];
    [self sendHeartRequest];
}

- (void)koShowSocket:(KOShowSocketTool *)socket revicedMessageWithDictionary:(NSDictionary *)dataDic
{
    NSString *message = dataDic[@"Message"];
    NSString *nickName = dataDic[@"nickName"] ? dataDic[@"nickName"] : @"";
    if ([message isEqualToString:@"进入房间"])
    {
         message = [NSString stringWithFormat:@"欢迎%@%@",nickName,message];
            [self.chatDataArray addObject:@{@"type":@(-1),@"message":message,@"nickName":dataDic[@"nickName"]}];
    }
    else
    {
        [self.chatDataArray addObject:@{@"type":dataDic[@"Type"],@"message":dataDic[@"Message"],@"nickName":dataDic[@"nickName"]}];
    }
    [self refreshChatTableView];
}


- (void)koShowSocket:(KOShowSocketTool *)socket revicedGiftWithDictionary:(NSDictionary *)dataDic
{
    NSString *anchorName = self.playDataDic[@"nickname"];
    anchorName = anchorName ? anchorName : @"";
    [self.chatDataArray addObject:@{@"type":@(3),@"giftID":dataDic[@"giftID"],@"nickName":dataDic[@"nickName"],@"anchorName":anchorName,@"count":dataDic[@"count"]}];
    [self refreshChatTableView];
}


#pragma mark 刷新chatTableView
- (void)refreshChatTableView
{
    [self.chatTableView reloadData];
    if (self.chatTableView && ![self.chatTableView isDragging])//手指在滑动聊天页面时不刷新
    {
        [self.chatTableView scrollRectToVisible:CGRectMake(0, self.chatTableView.contentSize.height - self.chatTableView.frame.size.height, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height) animated:YES];
    }
}


#pragma mark 获取主播详情
- (void)getAnchorDetailRequest
{
    __weak typeof(self) weakSelf = self;
    if (self.anchorDetailText || self.detailIsLoading)
    {
        return;
    }
    self.detailIsLoading = YES;
    NSString *urlString = ANCHOR_DETAIL_URL;
    NSDictionary *requestDic = @{@"id":self.playDataDic[@"anchor_id"]};
    [[RequestTool alloc] requestWithUrl:urlString
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"INDEX_PAGE_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [dataDic[@"errorCode"] intValue];
         //NSString *errorMessage = dataDic[@"errorMessage"];
         weakSelf.detailIsLoading = NO;
         if (errorCode == 200)
         {
             weakSelf.anchorDetailText = dataDic[@"result"][@"introduction"];
             [weakSelf.anchorDetailView setDetailText:weakSelf.anchorDetailText];
         }
         else
         {

         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         weakSelf.detailIsLoading = NO;
         NSLog(@"INDEX_PAGE_URL==%@",error);
     }];
}

#pragma mark 排行
- (void)getRankListRequest
{
    __weak typeof(self) weakSelf = self;
    if (self.rankArray || self.detailIsLoading)
    {
        return;
    }
    self.rankIsLoading = YES;
    NSString *urlString = RANK_LIST_URL;
    NSDictionary *requestDic = @{@"type":@"week"};
    [[RequestTool alloc] requestWithUrl:urlString
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"RANK_LIST_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [dataDic[@"errorCode"] intValue];
         //NSString *errorMessage = dataDic[@"errorMessage"];
         weakSelf.rankIsLoading = NO;
         if (errorCode == 200)
         {
             //weakSelf.anchorDetailText = dataDic[@"result"][@"introduction"];
             //[weakSelf.anchorDetailView setDetailText:weakSelf.anchorDetailText];
         }
         else
         {
             
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         weakSelf.rankIsLoading = NO;
         NSLog(@"RANK_LIST_URL==%@",error);
     }];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.chatTableView) ? [self.chatDataArray count] : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.chatTableView)
    {
        int chatRowHeight = CHAT_ROW_HEIGHT;
        if (indexPath.row < [self.rowHeightArray count])
        {
            chatRowHeight = [self.rowHeightArray[indexPath.row] floatValue];
        }
        else
        {
            NSDictionary *rowDic = self.chatDataArray[indexPath.row];
            int type = [rowDic[@"type"] intValue];
            NSString *message = rowDic[@"message"];
            NSString *nickName = rowDic[@"nickName"] ? rowDic[@"nickName"] : @"";
            NSString *messageText = @"";
            if (type == 2)
            {
                //主播
            }
            else if (type == 3)
            {
                chatRowHeight = GIFT_ROW_HEIGHT;
            }
            else
            {
                if (type == -1)
                {
                    messageText = message;
                }
                else if (type == 1 || type == 0)
                {
                    messageText = [NSString stringWithFormat:@"%@: %@",nickName,message];
                }
                chatRowHeight = [MessageView getContentSizeWithMessage:messageText];
            }
            [self.rowHeightArray addObject:@(chatRowHeight)];
        }
        return chatRowHeight;
    }
    else if (tableView == self.rankTableView)
    {
        return ROW_HEIGHT;
    }
    
    return ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, (tableView == self.rankTableView) ? HEADER_HEIGHT : CHAT_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    if (tableView == self.rankTableView)
    {
        UIImage *image = [UIImage imageNamed:@"rank_header"];
        UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake((headerView.frame.size.width - image.size.width/3)/2, (headerView.frame.size.height - image.size.height/3)/2, image.size.width/3, image.size.height/3) placeholderImage:image];
        [headerView addSubview:imageView];
    }
    else if (tableView == self.chatTableView)
    {
        float y = 0;
        float x = HEADER_SPACE_X;
        NSString *nickName = self.playDataDic[@"nickname"];
        nickName = nickName ? nickName : @"";
        UILabel *nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, headerView.frame.size.width, headerView.frame.size.height) textString:[NSString stringWithFormat:@"%@的直播间",nickName] textColor:DETAIL_TEXT_COLOR textFont:FONT(14.0)];
        [headerView addSubview:nameLabel];
        
        UIButton *collectButton = [CreateViewTool createButtonWithFrame:CGRectMake(headerView.frame.size.width -  x - FOCUS_BUTTON_WH, (nameLabel.frame.size.height - FOCUS_BUTTON_WH)/2, FOCUS_BUTTON_WH, FOCUS_BUTTON_WH) buttonImage:@"icon_focus" selectorName:@"" tagDelegate:self];
        [headerView addSubview:collectButton];
        
        y += nameLabel.frame.size.height;
        UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, headerView.frame.size.width, 1.0) placeholderImage:nil];
        lineImageView.backgroundColor = DETAIL_LINE_COLOR;
        [headerView addSubview:lineImageView];

    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (tableView == self.rankTableView) ? HEADER_HEIGHT : CHAT_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID1 = @"CellID1";
    static NSString *cellID2 = @"CellID2";
    static NSString *cellID3 = @"CellID3";
    UITableViewCell *cell;
    if (tableView == self.chatTableView)
    {
        NSDictionary *rowDic = self.chatDataArray[indexPath.row];
        int type = [rowDic[@"type"] intValue];
        NSString *message = rowDic[@"message"];
        NSString *nickName = rowDic[@"nickName"] ? rowDic[@"nickName"] : @"";
        NSString *messageText = @"";
        
        if (type == 2)
        {
            //主播
        }
        else if (type == 3)
        {
            //礼物
            GiftListCell *giftListCell = (GiftListCell *)[tableView dequeueReusableCellWithIdentifier:cellID2];
            if (!cell)
            {
                giftListCell = [[GiftListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                giftListCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *giftID = rowDic[@"giftID"];
            giftID = giftID ? giftID : @"";
            //NSString *giftName = [KOShowShareApplication shareApplication].giftDictionary[giftID];
            NSDictionary *imageDic = [self getImageUrlWithID:giftID];
            NSString *imageUrl = [[KOShowShareApplication shareApplication] makeImageUrlWithRightHalfString:imageDic[@"imageUrl"]];
            [giftListCell setMessageWithUserNickName:nickName anchorName:rowDic[@"anchorName"] giftName:imageDic[@"name"] giftImageUrl:imageUrl];
            return giftListCell;
        }
        else
        {
            if (type == -1)
            {
                messageText = message;
            }
            else if (type == 1 || type == 0)
            {
                messageText = [NSString stringWithFormat:@"%@: %@",nickName,message];
            }
            
            MessageListCell *messageCell = (MessageListCell *)[tableView dequeueReusableCellWithIdentifier:cellID1];
            if (!cell)
            {
                messageCell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
                messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [messageCell setMessageWithText:messageText type:type attributedString:[nickName stringByAppendingString:@":"]];
            return messageCell;
        }

       
    }
    if (tableView == self.rankTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        UILabel *rankLabel = (UILabel *)[cell.contentView viewWithTag:100];
        UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:101];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:102];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            rankLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, (cell.frame.size.height - R_LABEL_HEIGHT)/2, R_LABEL_WIDTH, R_LABEL_HEIGHT) textString:@"" textColor:[UIColor whiteColor] textFont:FONT(13.0)];
            rankLabel.tag = 100;
            rankLabel.adjustsFontSizeToFitWidth = YES;
            rankLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:rankLabel];
            
            iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(rankLabel.frame.origin.x + rankLabel.frame.size.width + ADD_X, (cell.frame.size.height - ICON_HEIGHT)/2, ICON_WIDTH, ICON_HEIGHT) placeholderImage:nil];
            iconImageView.tag = 101;
            [cell.contentView addSubview:iconImageView];
            
            nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + ADD_X1, (cell.frame.size.height - LABEL_HEIGHT)/2, LABEL_WIDTH, LABEL_HEIGHT) textString:@"" textColor:[UIColor blackColor] textFont:FONT(15.0)];
            nameLabel.tag = 102;
            [cell.contentView addSubview:nameLabel];
        }
        
        rankLabel.backgroundColor = (indexPath.row < 3) ? APP_MAIN_COLOR : [UIColor lightGrayColor];
        rankLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1];
        nameLabel.text = [NSString stringWithFormat:@"我是粉丝%d",(int)indexPath.row + 1];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%d",((int)indexPath.row + 1) % 5 + 1 ]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSDictionary *)getImageUrlWithID:(NSString *)giftID
{
    NSDictionary *imageDic;
    
    giftID = giftID ? giftID : @"";
    if (giftID.length == 0)
    {
        return nil;
    }

    NSArray *array = [[KOShowShareApplication shareApplication] giftArray];
    for (int i = 0; i < [array count]; i++)
    {
        NSDictionary *dic = array[i];
        NSString *curentGiftID = dic[@"id"];
        curentGiftID = curentGiftID ? curentGiftID : @"";
        if ([giftID isEqualToString:curentGiftID])
        {
            NSString * imageUrl = dic[@"img_url"];
            imageUrl = imageUrl ? imageUrl : @"";
            NSString *name = dic[@"gname"];
            name = name ? name : @"";
            imageDic = @{@"imageUrl":imageUrl,@"name":name};
            break;
        }
    }
    return imageDic;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.socketTool clearSocket];
    self.socketTool.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
