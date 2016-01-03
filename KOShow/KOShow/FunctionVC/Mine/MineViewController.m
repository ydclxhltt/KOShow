//
//  MineViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define HEADER_HEIGHT       225.0 * CURRENT_SCALE
#define ICON_WH             120.0 * CURRENT_SCALE
#define SECTION_HEIGHT      15.0
#define SPACE_Y             30.0 * CURRENT_SCALE
#define ADD_Y               10.0 * CURRENT_SCALE
#define LABEL_HEIGHT        20.0 * CURRENT_SCALE
#define LOGIN_BTN_HEIGHT    30.0 * CURRENT_SCALE
#define LOGIN_BTN_WIDTH     85.0 * CURRENT_SCALE
#define BTN_LAYER_COLOR     RGB(236.0, 187.0, 91.0)
#define BTN_TITLE_N_COLOR   RGB(225.0, 129.0, 0.0)

#import "MineViewController.h"
#import "MySaveViewController.h"
#import "BookMarkViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的";
    [self setNavBarItemWithImageName:@"nav_logo" navItemType:LeftItem selectorName:@""];
    
    _titleArray = @[@[@"我的订阅",@"我的收藏"],@[@"设置"]];
    _imageArray = @[@[@"icon_subscribe",@"icon_collect"],@[@"icon_setting"]];
    
    [self initUI];
    
    [self addNotifications];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addHeaderView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addHeaderView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, self.table.frame.size.width, HEADER_HEIGHT) placeholderImage:[UIImage imageNamed:@"login_bg"]];
    self.table.tableHeaderView = bgImageView;
    
    float x = (bgImageView.frame.size.width - ICON_WH)/2;
    float y = SPACE_Y;
    _iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(x, y, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"user_default"] borderColor:LAYER_COLOR imageUrl:@""];
    [bgImageView addSubview:_iconImageView];
    
    x = (_iconImageView.frame.size.width - LOGIN_BTN_WIDTH)/2.0;
    y = (_iconImageView.frame.size.height - LOGIN_BTN_HEIGHT)/2.0;
    _loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, LOGIN_BTN_WIDTH, LOGIN_BTN_HEIGHT) buttonTitle:@"登录" titleColor:BTN_TITLE_N_COLOR normalBackgroundColor:[UIColor whiteColor] highlightedBackgroundColor:BTN_TITLE_N_COLOR selectorName:@"loginButtonPressed:" tagDelegate:self];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
     [CommonTool setViewLayer:_loginButton withLayerColor:APP_MAIN_COLOR bordWidth:1.0];
    _loginButton.titleLabel.font = FONT(15.0);
    [_iconImageView addSubview:_loginButton];
    
    y = _iconImageView.frame.size.height + _iconImageView.frame.origin.y + ADD_Y;
    _nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, y, bgImageView.frame.size.width, LABEL_HEIGHT) textString:@"" textColor:[UIColor whiteColor] textFont:FONT(16.0)];
    _nameLabel.textAlignment =  NSTextAlignmentCenter;
    [bgImageView addSubview:_nameLabel];
}

#pragma mark 添加通知
- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:@"LoginSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut:) name:@"LoginOut" object:nil];
}


#pragma mark 点击登录按钮
- (void)loginButtonPressed:(UIButton *)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginNav animated:YES completion:NULL];
}


#pragma mark 登录成功
- (void)loginSucess:(NSNotification *)nofitication
{
    self.loginButton.hidden = YES;
    NSDictionary *userDic = [KOShowShareApplication shareApplication].userInfoDictionary;
    NSString *userName = userDic[@"login_name"];
    userName = (userName) ? userName : @"";
    NSString *nickname = userDic[@"nickname"];
    nickname = (nickname) ? nickname : @"";
    self.nameLabel.text = (nickname.length > 0) ? nickname : userName;
}

#pragma mark 退出登录
- (void)loginOut:(NSNotification *)nofitication
{
    self.loginButton.hidden = NO;
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MINE_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = FONT(16.0);
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            viewController = [[BookMarkViewController alloc] init];
        }
        if (indexPath.row == 1)
        {
            viewController = [[MySaveViewController alloc] init];
        }
    }
    else if (indexPath.section == 1)
    {
        viewController = [[SettingViewController alloc] init];
    }
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
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
