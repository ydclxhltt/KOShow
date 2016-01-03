//
//  RegisterViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X                 15.0 * CURRENT_SCALE
#define SPACE_Y                 10.0 * CURRENT_SCALE
#define ROW_SPACE_X             5.0 * CURRENT_SCALE
#define ROW_SPACE_Y             5.0 * CURRENT_SCALE
#define SEGMENTVIEW_HEIGHT      35.0 * CURRENT_SCALE
#define HEADER_HEIGHT           SEGMENTVIEW_HEIGHT + SPACE_Y + ROW_SPACE_Y
#define TEXTFIELD_HEIGHT        40.0 * CURRENT_SCALE
#define ROW_HEIGHT              TEXTFIELD_HEIGHT + 2 * ROW_SPACE_Y
#define REG_LAYER_COLOR         RGB(230.0,230.0,230.0)
#define LEFT_VIEW_WIDTH         75.0 * CURRENT_SCALE
#define FOOT_SPACE_Y            20.0 * CURRENT_SCALE
#define FOOT_SPACE_X            20.0 * CURRENT_SCALE
#define BUTTON_SPACE_X          50.0 * CURRENT_SCALE
#define BUTTON_HEIGHT           40.0 * CURRENT_SCALE
#define FOOT_ADD_Y              35.0 * CURRENT_SCALE
#define FOOT_ADD_X              10.0 * CURRENT_SCALE
#define FOOT_VIEW_HEIGHT        270.0 * CURRENT_SCALE
#define AGREE_BUTTON_WH         15.0 * CURRENT_SCALE
#define AGREE_TIP_TEXT          @"阅读并同意该用户协议"
#define AGREE_TIP_COLOR         RGB(187.0,187.0,187.0)
#define CODE_BUTTON_WIDTH       120.0 * CURRENT_SCALE
#define CAPTCHAVIEW_WIDTH       70.0 * CURRENT_SCALE
#define CAPTCHAVIEW_HEIGHT      30.0 * CURRENT_SCALE
#define RIGHT_VIEW_WIDTH        80.0 * CURRENT_SCALE

#define CODE_TIP                @"获取验证码"
#define CODE_TIP1               @"重新获取"

#define LOADING_TIP             @"正在注册..."
#define LOADING_SUCESS          @"注册成功"
#define LOADING_FAIL            @"注册失败"

#define CODE_LOADING_TIP        @"正在获取..."
#define CODE_LOADING_SUCESS     @"获取成功"
#define CODE_LOADING_FAIL       @"获取失败"


#import "RegisterViewController.h"
#import "SegmentView.h"
#import "ThirdLoginView.h"
#import "CaptchaView.h"

@interface RegisterViewController ()<SegmentViewDelegate,UITextFieldDelegate>

@property (nonatomic, assign) RegisterType registerType;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *placeholdersArray;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) CaptchaView *captchaView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *codeString;
@property (nonatomic, strong) NSTimer  *countTimer;
@property (nonatomic, assign) int count;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBackItem];
    
    self.registerType = RegisterTypePhone;
    _titlesArray = @[@"手 机 号",@"昵      称",@"密      码",@"重复密码",@"验 证 码"];
    _placeholdersArray = @[@"+86",@"6位以上字符",@"6-15位",@"6-15位",@"手机收到的验证码"];
    self.count = 60;
    
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addHeaderView];
    [self addFooterView];
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//添加选项卡
- (void)addHeaderView
{
    UIImageView *headerView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, HEADER_HEIGHT) placeholderImage:nil];
    headerView.backgroundColor = [UIColor whiteColor];
    
    SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(SPACE_X, SPACE_Y, headerView.frame.size.width - 2 * SPACE_X, SEGMENTVIEW_HEIGHT)];
    segmentView.radius = 5.0;
    segmentView.delegate = self;
    [segmentView setItemTitleWithArray:@[@"手机注册",@"普通注册"]];
    [headerView addSubview:segmentView];
    
    self.table.tableHeaderView = headerView;
}

//添加按钮等
- (void)addFooterView
{
    UIImageView *footView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, FOOT_VIEW_HEIGHT) placeholderImage:nil];
    
    float x = FOOT_SPACE_X;
    float y = FOOT_SPACE_Y;
    UIButton *agreeButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, AGREE_BUTTON_WH, AGREE_BUTTON_WH) buttonTitle:@"" titleColor:nil normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:APP_MAIN_COLOR selectorName:@"agreeButtonPressed:" tagDelegate:self];
    [CommonTool setViewLayer:agreeButton withLayerColor:REG_LAYER_COLOR bordWidth:2.0];
    [footView addSubview:agreeButton];
    
    x += agreeButton.frame.size.width + FOOT_ADD_X;
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, footView.frame.size.width - x, agreeButton.frame.size.height) textString:AGREE_TIP_TEXT textColor:AGREE_TIP_COLOR textFont:FONT(16.0)];
    [footView addSubview:tipLabel];
    
    y += agreeButton.frame.size.height + FOOT_ADD_Y;
    x =  BUTTON_SPACE_X;
    _registerButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, footView.frame.size.width - 2 * x, BUTTON_HEIGHT) buttonTitle:@"注册" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:nil selectorName:@"registerButtonPressed:" tagDelegate:self];
    _registerButton.titleLabel.font = FONT(16.0);
    _registerButton.enabled = NO;
    [footView addSubview:_registerButton];
    
    y += _registerButton.frame.size.height + FOOT_ADD_Y;
    float height = footView.frame.size.height - y;
    ThirdLoginView *thirdLoginView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, y, footView.frame.size.width, height)];
    [footView addSubview:thirdLoginView];
    
    self.table.tableFooterView = footView;
}

#pragma mark 获取输入的数据
- (NSString *)getTextFieldTextWithIndex:(int)index
{
    NSString *text = @"";
    UITextField *textField = (UITextField *)[[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]] viewWithTag:100 + index];
    text = (textField.text) ? textField.text : @"";
    return text;
}

#pragma mark 取消键盘
- (void)textFieldsResignFirstResponder
{
    for (int i = 0; i < [self.titlesArray count]; i++)
    {
        UITextField *textField = (UITextField *)[[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] viewWithTag:100 + i];
        [textField resignFirstResponder];
    }
}
#pragma mark 协议勾选按钮
- (void)agreeButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _registerButton.enabled = sender.selected;
}


#pragma mark 获取验证码按钮
- (void)codeButtonPressed:(UIButton *)sender
{
    _userName = [self getTextFieldTextWithIndex:0];
    if ([CommonTool isEmailOrPhoneNumber:_userName])
    {
        [self getCodeRequest];
    }
    else
    {
        [CommonTool addAlertTipWithMessage:@"请输入正确的手机号"];
    }
}

#pragma mark 获取验证码请求
- (void)getCodeRequest
{
    [SVProgressHUD showWithStatus:CODE_LOADING_TIP];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic =  @{ @"phone":self.userName};
    [[RequestTool alloc] requestWithUrl:GET_CODE_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"GET_CODE_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [dataDic[@"errorCode"] intValue];
         NSString *errorMessage = dataDic[@"errorMessage"];
         errorMessage = errorMessage ? errorMessage : CODE_LOADING_FAIL;
         if (errorCode == 200)
         {
             [SVProgressHUD showSuccessWithStatus:CODE_LOADING_SUCESS];
             [weakSelf createTimer];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:errorMessage];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"GET_CODE_URL====%@",error);
         [SVProgressHUD showErrorWithStatus:CODE_LOADING_FAIL];
     }];
}

//创建Timer
- (void)createTimer
{
    self.codeButton.enabled = NO;
    if ([_countTimer isValid])
    {
        [_countTimer invalidate];
    }
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCount:) userInfo:nil repeats:YES];
}

//定时器执行方法
- (void)changeCount:(NSTimer *)timer
{
    self.count--;
    if (self.count == 0)
    {
        [self resetTimer];
        return;
    }
    NSString *titleStr = [NSString stringWithFormat:@"%@(%ds)",CODE_TIP1,self.count];
    [self.codeButton setTitle:titleStr forState:UIControlStateNormal];
    
}

//清掉定时器
- (void)resetTimer
{
    [self.countTimer invalidate];
    self.codeButton.enabled = YES;
    self.count = 60;
    [self.codeButton setTitle:CODE_TIP forState:UIControlStateNormal];
}

#pragma mark 注册
- (void)registerButtonPressed:(UIButton *)sender
{
    if (![self isCanCommit])
    {
        return;
    }
    [self registerRequest];
}

- (BOOL)isCanCommit
{
    NSString *message = @"";
    _userName = [self getTextFieldTextWithIndex:0];
    _nickName = [self getTextFieldTextWithIndex:1];
    NSString *password1 = [self getTextFieldTextWithIndex:2];
    NSString *password2 = [self getTextFieldTextWithIndex:3];
    _codeString = [self getTextFieldTextWithIndex:4];
    
    if (_userName.length == 0)
    {
        message = [NSString stringWithFormat:@"%@不能为空",(self.registerType == RegisterTypePhone) ? @"手机号" : @"账号"];
    }
    else if (_nickName.length == 0)
    {
        message = @"昵称不能为空";
    }
    else if (password1.length == 0 || password2.length == 0)
    {
        message = @"密码不能为空";
    }
    
    else if (_codeString.length == 0)
    {
        message = @"验证码不能为空";
    }
    else
    {
        if (self.registerType == RegisterTypePhone)
        {
            if (![CommonTool isEmailOrPhoneNumber:_userName])
            {
                message = @"验证码不能为空";
            }
        }
        else if (self.registerType == RegisterTypeNormal)
        {
            if (_userName.length < 6 || _userName.length > 15)
            {
                message = @"账号为6-15位";
            }
        }
        if (message.length > 0)
        {
            [CommonTool addAlertTipWithMessage:message];
            return NO;
        }
        
        if (_nickName.length > 15)
        {
            message = @"昵称不能大于15位";
        }
        else if (![password1 isEqualToString:password2])
        {
            message = @"密码不一致";
        }
        else
        {
            if (self.registerType == RegisterTypeNormal)
            {
                if (![[self.captchaView.changeString uppercaseString] isEqualToString:[_codeString uppercaseString]])
                {
                    message = @"验证码不正确";
                }
            }
        }
    }
    
    if (message.length > 0)
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    self.password = password1;
    return YES;
}

#pragma mark 注册请求
- (void)registerRequest
{
    [SVProgressHUD showWithStatus:LOADING_TIP];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic =  @{((self.registerType == RegisterTypeNormal) ? @"login_name" : @"mobilephone"):self.userName,@"passwd":self.password,@"nickname":self.nickName,@"code":self.codeString};
    [[RequestTool alloc] requestWithUrl:USER_REGISTER_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"USER_REGISTER_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [dataDic[@"errorCode"] intValue];
         NSString *errorMessage = dataDic[@"errorMessage"];
         errorMessage = errorMessage ? errorMessage : LOADING_FAIL;
         if (errorCode == 200)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterSucess" object:@{@"userName":weakSelf.userName,@"password":weakSelf.password}];
             [weakSelf.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:errorMessage];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"USER_LOGIN_URL====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
}


#pragma mark SegmentDelegate
- (void)segmentView:(SegmentView *)segmentView  selectedItemAtIndex:(int)index
{
    RegisterType type = (index == 0) ? RegisterTypePhone : RegisterTypeNormal;
    if (self.registerType == type)
    {
        return;
    }
    self.registerType = type;
    _titlesArray =  (index == 0) ? @[@"手 机 号",@"昵      称",@"密      码",@"重复密码",@"验 证 码"] : @[@"账      号",@"昵      称",@"密      码",@"重复密码",@""] ;
    _placeholdersArray = (index == 0) ? @[@"+86",@"6位以上字符",@"6-15位",@"6-15位",@"手机收到的验证码"] : @[@"6位以上字符",@"6位以上字符",@"6-15位",@"6-15位",@" 请输入右侧验证码"];
    [self textFieldsResignFirstResponder];
    [self.table reloadData];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titlesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:100 + indexPath.row];
    UILabel *leftLabel = (UILabel *)[cell.contentView viewWithTag:1000 + indexPath.row];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, ROW_SPACE_Y, self.table.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:self.placeholdersArray[indexPath.row]];
        textField.tag = 100 + indexPath.row;
        textField.delegate = self;
        [CommonTool setViewLayer:textField withLayerColor:REG_LAYER_COLOR bordWidth:1.0];
        [CommonTool clipView:textField withCornerRadius:5.0];
        
        if (indexPath.row < 4)
        {
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LEFT_VIEW_WIDTH, textField.frame.size.height)];
            
            leftLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, leftView.frame.size.width - 2 * ROW_SPACE_X, textField.frame.size.height) textString:self.titlesArray[indexPath.row] textColor:MAIN_TEXT_COLOR textFont:(SCREEN_WIDTH == 320.0) ? FONT(13.0) : FONT(15.0)];
            leftLabel.tag = 1000 + indexPath.row;
            leftLabel.textAlignment = NSTextAlignmentRight;
            [leftView addSubview:leftLabel];
            textField.leftView = leftView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        
            if (indexPath.row == 2 || indexPath.row == 3)
            {
                textField.secureTextEntry = YES;
            }
        }
        
        [cell.contentView addSubview:textField];
    }
    
    textField.placeholder = self.placeholdersArray[indexPath.row];
    leftLabel.text = self.titlesArray[indexPath.row];
    textField.text = @"";
    
    if (indexPath.row == 0)
    {
        textField.keyboardType = (self.registerType == RegisterTypePhone) ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
    }
    
    if (indexPath.row == 4)
    {
        textField.leftViewMode = (self.registerType == RegisterTypePhone) ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
        if (!_codeButton)
        {
            _codeButton = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, CODE_BUTTON_WIDTH, BUTTON_HEIGHT) buttonTitle:CODE_TIP titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:nil selectorName:@"codeButtonPressed:" tagDelegate:self];
            _codeButton.titleLabel.font = textField.font;
            [CommonTool clipView:_codeButton withCornerRadius:5.0];
        }
        if (!_rightView)
        {
            _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_VIEW_WIDTH, textField.frame.size.height)];
            float x = (_rightView.frame.size.width - CAPTCHAVIEW_WIDTH)/2;
            float y = (_rightView.frame.size.height - CAPTCHAVIEW_HEIGHT)/2;
            _captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(x, y, CAPTCHAVIEW_WIDTH, CAPTCHAVIEW_HEIGHT)];
            [_rightView addSubview:_captchaView];
        }
        if (!_leftView)
        {
            _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LEFT_VIEW_WIDTH, textField.frame.size.height)];
            
            UILabel *lastLeftLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0, _leftView.frame.size.width - 2 * ROW_SPACE_X, textField.frame.size.height) textString:self.titlesArray[indexPath.row] textColor:MAIN_TEXT_COLOR textFont:(SCREEN_WIDTH == 320.0) ? FONT(13.0) : FONT(15.0)];
            lastLeftLabel.textAlignment = NSTextAlignmentRight;
            [_leftView addSubview:lastLeftLabel];
        }
        if (self.registerType == RegisterTypePhone)
        {
            cell.accessoryView = _codeButton;
            textField.leftView = _leftView;
            textField.rightView = nil;
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.rightViewMode = UITextFieldViewModeNever;
        }
        else
        {
            textField.rightView = _rightView;
            textField.leftView = nil;
            textField.leftViewMode = UITextFieldViewModeNever;
            textField.rightViewMode = UITextFieldViewModeAlways;
            cell.accessoryView = nil;
        }
        CGRect frame = textField.frame;
        frame.size.width = (self.registerType == RegisterTypePhone) ? self.table.frame.size.width - 2 * SPACE_X - CODE_BUTTON_WIDTH - ROW_SPACE_X :  self.table.frame.size.width - 2 * SPACE_X;
        textField.frame = frame;
    }
    else
    {
        textField.leftViewMode = UITextFieldViewModeAlways;
        cell.accessoryView = nil;
        textField.frame = CGRectMake(SPACE_X, ROW_SPACE_Y, self.table.frame.size.width - 2 * SPACE_X, TEXTFIELD_HEIGHT);
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (SCREEN_HEIGHT == 480.0)
    {
        int index = (int)textField.tag - 100;
        if (index > 2)
        {
            [self moveTableViewTranslation:-2 * ROW_HEIGHT];
        }
        else
        {
            [self moveTableViewTranslation:-index * ROW_HEIGHT];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self moveTableViewTranslation:0];
    return YES;
}

- (void)moveTableViewTranslation:(float)height
{
    [UIView animateWithDuration:0.35 animations:^
     {
         //[self.table setContentOffset:CGPointMake(0, height)];
         self.table.transform = CGAffineTransformMakeTranslation(0, height);
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self resetTimer];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
