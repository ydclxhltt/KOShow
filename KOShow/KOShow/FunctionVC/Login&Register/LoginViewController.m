//
//  LoginViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define HEAD_VIEW_HEIGHT        140.0 * CURRENT_SCALE
#define TABLE_LINE_COLOR        RGB(230.0,230.0,230.0)
#define ROW_HEIGHT              50 * CURRENT_SCALE
#define SPACE_X                 15.0
#define ROW_ICON_WIDTH          15.0
#define CAPTCHAVIEW_WIDTH       80.0 * CURRENT_SCALE
#define CAPTCHAVIEW_HEIGHT      30.0 * CURRENT_SCALE

#define FOOT_VIEW_HEIGHT        245.0 * CURRENT_SCALE
#define FOOT_SPACE_X            25.0 * CURRENT_SCALE
#define FOOT_SPACE_Y            40.0 * CURRENT_SCALE
#define LOGIN_BUTTON_WIDTH      175.0 * CURRENT_SCALE
#define LOGIN_BUTTON_HEIGHT     40.0 * CURRENT_SCALE
#define FOOT_ADD_Y              35.0 * CURRENT_SCALE

#define LOADING_TIP             @"正在登录..."
#define LOADING_SUCESS          @"登录成功"
#define LOADING_FAIL            @"登录失败"


#import "LoginViewController.h"
#import "CaptchaView.h"
#import "ThirdLoginView.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *placeholdersArray;
@property (nonatomic, strong) CaptchaView *captchaView;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *codeString;
@property (nonatomic, strong) NSMutableArray *textFieldsArray;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBarItemWithImageName:@"icon_close" navItemType:RightItem selectorName:@"backButtonPressed:"];
    
    _userName = @"";
    _password = @"";
    _codeString = @"";
    _imagesArray = @[@"icon_name",@"icon_pwd",@"icon_valicode"];
    _placeholdersArray = @[@"账号或手机号",@"密码6位以上英文字母+数字",@"请填写验证码"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSucess:) name:@"RegisterSucess" object:nil];
    
    [self initUI];

    // Do any additional setup after loading the view.
}

#pragma mark 返回按钮
- (void)backButtonPressed:(UIButton *)sender
{
    [self textFieldsResignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:Nil];
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
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.table setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _textFieldsArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [self.imagesArray count]; i++)
    {
        UITextField *textField = (UITextField *)[[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] viewWithTag:100 + i];
        [_textFieldsArray addObject:textField];
    }
}

//添加头像视图
- (void)addHeaderView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEAD_VIEW_HEIGHT)placeholderImage:nil];
    
    UIImage *image = [UIImage imageNamed:@"icon_notlogin"];
    float icon_WH = image.size.width/3.0 * CURRENT_SCALE;
    float x = (bgImageView.frame.size.width - icon_WH)/2;
    float y = (bgImageView.frame.size.height - icon_WH)/2;
    
    UIImageView *iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, icon_WH, icon_WH) placeholderImage:image];
    [bgImageView addSubview:iconImageView];
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, bgImageView.frame.size.height - 0.5, bgImageView.frame.size.width, 0.5) placeholderImage:nil];
    lineImageView.backgroundColor = TABLE_LINE_COLOR;
    [bgImageView addSubview:lineImageView];
    
    
    self.table.tableHeaderView = bgImageView;
}

//添加相关按钮
- (void)addFooterView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FOOT_VIEW_HEIGHT)placeholderImage:nil];
    
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, bgImageView.frame.size.width, 0.5) placeholderImage:nil];
    lineImageView.backgroundColor = TABLE_LINE_COLOR;
    [bgImageView addSubview:lineImageView];
    
    float x = FOOT_SPACE_X;
    float y = FOOT_SPACE_Y;
    UIButton *loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, LOGIN_BUTTON_WIDTH, LOGIN_BUTTON_HEIGHT) buttonTitle:@"登录" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:nil selectorName:@"loginButtonPressed:" tagDelegate:self];
    loginButton.titleLabel.font = FONT(16.0);
    [bgImageView addSubview:loginButton];
    
    x += loginButton.frame.size.width + FOOT_SPACE_X;
    float width = bgImageView.frame.size.width - FOOT_SPACE_X - x;
    float height = loginButton.frame.size.height;
    UIButton *registerButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, width, height) buttonTitle:@"立即注册" titleColor:APP_MAIN_COLOR normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:[UIColor clearColor] selectorName:@"registerButtonPressed:" tagDelegate:self];
    registerButton.titleLabel.font = FONT(16.0);
    [bgImageView addSubview:registerButton];
    
    UIImage *image = [UIImage imageNamed:@"icon_arrows"];
    float icon_width = image.size.width/3 * CURRENT_SCALE;
    float icon_height = image.size.height/3 * CURRENT_SCALE;
    float icon_x = registerButton.frame.size.width - icon_width;
    float icon_y = (registerButton.frame.size.height - icon_height)/2;
    UIImageView *arrowImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(icon_x, icon_y, icon_width, icon_height) placeholderImage:image];
    [registerButton addSubview:arrowImageView];
    
    y += registerButton.frame.size.height + FOOT_ADD_Y;
    ThirdLoginView *thirdLoginView = [[ThirdLoginView alloc] initWithFrame:CGRectMake(0, y, bgImageView.frame.size.width, bgImageView.frame.size.height - y)];
    [bgImageView addSubview:thirdLoginView];
    
    self.table.tableFooterView = bgImageView;
}

#pragma mark 注册成功
- (void)registerSucess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.object;
    ((UITextField *)(self.textFieldsArray[0])).text = userInfo[@"userName"];
    ((UITextField *)(self.textFieldsArray[1])).text = userInfo[@"password"];
    ((UITextField *)(self.textFieldsArray[2])).text = self.captchaView.changeString;
    [self loginButtonPressed:nil];
}

#pragma mark 取消键盘
- (void)textFieldsResignFirstResponder
{
    for (int i = 0; i < [self.imagesArray count]; i++)
    {
        UITextField *textField = (UITextField *)(self.textFieldsArray[i]);
        [textField resignFirstResponder];
    }
}

#pragma mark 登录
- (void)loginButtonPressed:(UIButton *)sender
{
    if (![self isCanCommit])
    {
        return;
    }
    [self textFieldsResignFirstResponder];
    [self userLoginRequest];
}

- (BOOL)isCanCommit
{
    NSString *message = @"";
    self.userName = ((UITextField *)(self.textFieldsArray[0])).text;
    self.password = ((UITextField *)(self.textFieldsArray[1])).text;
    self.codeString = ((UITextField *)(self.textFieldsArray[2])).text;
    if (self.userName.length == 0)
    {
        message = @"用户名不能为空";
    }
    else if (self.password.length == 0)
    {
        message = @"密码不能为空";
    }
    else if (self.codeString.length == 0)
    {
        message = @"请输入验证码";
    }
    else if (self.userName.length < 6)
    {
        message = @"账号不能少于6位";
    }
    else if (self.password.length < 6)
    {
        message = @"密码不能少于6位";
    }
    else if(![[self.captchaView.changeString uppercaseString] isEqualToString:[self.codeString uppercaseString]])
    {
        message = @"验证码错误";
    }
    
    if (message.length > 0)
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    
    return YES;
}

#pragma mark 登录请求
- (void)userLoginRequest
{
    [SVProgressHUD showWithStatus:LOADING_TIP];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"login_name":self.userName,@"passwd":self.password};
    [[RequestTool alloc] requestWithUrl:USER_LOGIN_URL
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"USER_LOGIN_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [responseDic[@"errorCode"] intValue];
         NSString *errorMessage = responseDic[@"errorMessage"];
         errorMessage = errorMessage ? errorMessage : LOADING_FAIL;
         if (errorCode == 200)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf setDataWithDictionary:dataDic];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:errorMessage];
         }
         [CookiesTool setCookiesWithUrl:USER_LOGIN_URL];
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"USER_LOGIN_URL====%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
     }];
    
}

#pragma mark 注册
- (void)registerButtonPressed:(UIButton *)sender
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark 设置数据
- (void)setDataWithDictionary:(NSDictionary *)dataDictionary
{
    [KOShowShareApplication shareApplication].isLogin = YES;
    [KOShowShareApplication shareApplication].userInfoDictionary = dataDictionary[@"result"];
    [KOShowShareApplication saveUserInfoWithUserName:dataDictionary[@"login_name"] password:self.password];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSucess" object:nil];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imagesArray count];
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
    float x = SPACE_X + ROW_ICON_WIDTH + SPACE_X;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(x, 0, self.table.frame.size.width - 2 * x, ROW_HEIGHT) textColor:MAIN_TEXT_COLOR textFont:FONT(16.0) placeholderText:self.placeholdersArray[indexPath.row]];
        textField.text = @"";
        textField.tag = 100 + indexPath.row;
        textField.delegate = self;
        [cell.contentView addSubview:textField];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    
    if (self.captchaView)
    {
        [self.captchaView removeFromSuperview];
    }
    if (indexPath.row == 1)
    {
        UIImage *image = [UIImage imageNamed:@"icon_findPwd_up"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, image.size.width/3 * CURRENT_SCALE, image.size.height/3 * CURRENT_SCALE);
        [button setBackgroundImage:[UIImage imageNamed:@"icon_findPwd_up"] forState:UIControlStateNormal];
        cell.accessoryView = button;
        textField.secureTextEntry = YES;
    }
    else
    {
        cell.accessoryView = nil;
        if (indexPath.row == 2)
        {
            if (!_captchaView)
            {
                _captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, 0, CAPTCHAVIEW_WIDTH, CAPTCHAVIEW_HEIGHT)];
            }
            cell.accessoryView = _captchaView;
        }
    }
    
    CGRect frame = textField.frame;
    frame.size.width = (indexPath.row == 2) ? self.table.frame.size.width - 4 * SPACE_X - ROW_ICON_WIDTH - CAPTCHAVIEW_WIDTH : self.table.frame.size.width - 2 * x;
    textField.frame = frame;
    
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
       [self moveTableViewTranslation:-2 * ROW_HEIGHT];
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
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^
     {
         //[self.table setContentOffset:CGPointMake(0, height)];
         weakSelf.table.transform = CGAffineTransformMakeTranslation(0, height);
     }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
