//
//  CDMessageCth.m
//  CDYL
//
//  Created by admin on 2018/6/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "CDMessageCth.h"
#import "CDMessage.h"
#import "UserMessage.h"
#import "MsgCellFrame.h"
#import "CDMessageCell.h"

@interface CDMessageCth ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, strong) UITableView *tableV;

@end

@implementation CDMessageCth
static NSString * const identy = @"MESSAGEIDENTY";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
    [self getSource];
}
- (void)viewWillDisappear:(BOOL)animated{
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
        NSLog(@"push");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        self.navigationController.navigationBarHidden = YES;
    }
}
-(void)setSubViews{
//    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"trash"] style:UIBarButtonItemStyleDone target:self action:@selector(tapTheNavigationBarItem:)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITableView *tv=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEAppWidth, DEAppHeight)];
    tv.delegate=self;
    tv.dataSource=self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tv registerClass:[CDMessageCell class] forCellReuseIdentifier:identy];
    [self.view addSubview:tv];
    self.tableV =tv;
}
#pragma mark -  tableViewDelagate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MsgCellFrame *cellFrame = self.msgArr[indexPath.row];
    cell.frameModel = cellFrame;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     MsgCellFrame *cellFrame = self.msgArr[indexPath.row];
    return cellFrame.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -  自定义method
- (void)getSource{
    [self hiddenAllBaseView];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   self.msgArr = [[CDMessage shareMessage]getAllMessages];
    [hud hideAnimated:YES];
    [self.tableV reloadData];
    if (self.msgArr.count == 0) {
        [self showEmptyViewWith:@"当前没有消息"];
    }
}
- (void)tapTheNavigationBarItem:(UIBarButtonItem *)item{
    [self showAlert:@"提醒" message:@"你将删除全部消息"];

}
- (void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![title isEqualToString:@"提示"]) {
//            [self.msgArr removeAllObjects];
            [[CDMessage shareMessage]deleteAllMessage];
            [self getSource];
        }
        
    }];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    if (![title isEqualToString:@"提示"]) {
         [alert addAction:action2];
    }
 
    [self presentViewController:alert animated:YES completion:nil];

}
@end
