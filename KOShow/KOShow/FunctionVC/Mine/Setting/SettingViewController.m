//
//  SettingViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ROW_HEIGHT     60.0
#define SPACE_Y        40.0
#define BUTTON_HEIGHT  35.0
#define SPACE_X        55.0 * CURRENT_SCALE

#import "SettingViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UILabel *cacheLabel;

@end


@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    _titleArray = @[@"推送通知",@"开播提醒",@"清除缓存",@"关于",@"意见反馈"];
    _imageArray = @[@"icon_notice",@"icon_remind",@"icon_delete",@"icon_about",@"icon_opinion"];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
    [self addButton];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)addButton
{
    UIButton *exitButton = [CreateViewTool createButtonWithFrame:CGRectMake(SPACE_X, self.table.contentSize.height + SPACE_Y, self.view.frame.size.width - 2 * SPACE_X, BUTTON_HEIGHT) buttonTitle:@"退出当前账号" titleColor:[UIColor whiteColor] normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:nil selectorName:@"" tagDelegate:self];
    exitButton.titleLabel.font = FONT(15.0);
    [self.table addSubview:exitButton];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = FONT(16.0);
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0 || indexPath.row == 1)
    {
        UISwitch *switchView = [[UISwitch alloc] init];
        switchView.tag = indexPath.row + 100;
        switchView.onTintColor = APP_MAIN_COLOR;
        [switchView setOn:(indexPath.row == 0)];
        cell.accessoryView = switchView;
    }
    else if (indexPath.row == 2)
    {
        
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    if (indexPath.row == 3)
    {
        viewController = [[AboutUsViewController alloc] init];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
