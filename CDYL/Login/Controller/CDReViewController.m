//
//  CDReViewController.m
//  CDYL
//
//  Created by admin on 2018/5/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "CDReViewController.h"
#import "CDLoginView.h"
#import "CDCodeViewController.h"
#import "CDBarView.h"

@interface CDReViewController () <CDBarViewDelagate>
@property (nonatomic, strong) CDLoginView *loginView;
@property (nonatomic, strong) UIButton *LoginButton;
@end

@implementation CDReViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerCth];
}
-(void)registerCth {
    
    CGFloat Height = 64;
    if (is_iphoneX) {
        Height = 88;
    }
    CDBarView *barView = [[CDBarView alloc]initWithFrame:CGRectMake(0, 0, DEAppWidth, Height)];
    barView.delegate = self;
    [self.view addSubview:barView];
    barView.title = @"重设密码";
    CGFloat black = barView.bounds.size.height+15;
    
    CDLoginView *lgView = [[CDLoginView alloc]initWithFrame:CGRectMake(0, black, DEAppWidth, 88) wight:35];
    [self.view addSubview:lgView];
    self.loginView = lgView;
    [self setBtnblack:black title:@"下一步" tag:101];
}
-(void)setBtnblack:(CGFloat)black title:(NSString *)title tag:(NSUInteger)tag{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(15, black+130, DEAppWidth-30, 40)];
    btn.backgroundColor = LHColor(255, 198, 80);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickTheBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    [btn setTitleColor:LHColor(34, 34, 34) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 20;
    self.LoginButton = btn;
}
#pragma mark - Btn点击方法
-(void)clickTheBtn:(UIButton *)btn{
    [self.view endEditing:YES];
    
   // 注册
        [self registerBtnClick];
}
-(void)registerBtnClick{
    
    NSString *phone = self.loginView.phoneTf.text;
    NSString *pword = self.loginView.pWordTf.text;
    if ([self is_okPhone:phone Pword:pword]) {
        
        [CDWebRequest requestsendVerCodeWithTel:phone AndBack:^(NSDictionary *backDic) {
            
        } failure:^(NSString *err) {
            
        }];
        CDCodeViewController *codeView = [[CDCodeViewController alloc]init];
        codeView.cthType = 30;
        codeView.userNum = phone;
        codeView.PwordNum = pword;
        [self.navigationController pushViewController:codeView animated:YES];
    }
    
}
-(BOOL)is_okPhone:(NSString *)phoneNum Pword:(NSString *)pwordNum{
    if (phoneNum.length>0 && pwordNum.length>0) {
        if ([CDXML phoneNumberIsTrue:phoneNum]) {
            if (self.cthType ==1 ) {
                return YES;
            }else{
                if (pwordNum.length>=6) {
                    return YES;
                }else{
                    [self showAlert:@"密码至少六位"];
                }
            }
            
            
        }else{
            [self showAlert:@"手机号有误"];
        }
    }else{
        [self showAlert:@"不能为空"];
    }
    return NO;
}
#pragma mark - 自定义方法
-(void)showAlert:(NSString *)message{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = message;
    hud.mode = MBProgressHUDModeText;
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:2.0f];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - CDBarViewDelagate
-(void)popUpViewController{
    
    NSArray *subs = self.navigationController.childViewControllers;
    
    [self.navigationController popToViewController:[subs objectAtIndex:subs.count-2] animated:YES];
}
@end
