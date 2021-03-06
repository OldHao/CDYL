//
//  CDTabbarCtl.m
//  CDYL
//
//  Created by admin on 2017/6/2.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "CDTabbarCtl.h"
#import "CDMapViewController.h"
#import "CDoderViewController.h"
#import "CDchargeViewController.h"
#import "CDscanViewController.h"
#import "CDMessage.h"
#import "CDMineViewController.h"
#import "CDTabbar.h"
#import "CDNav.h"
#import "Global.h"
#import "StyleDIY.h"
#import "CDViewController.h"

@interface CDTabbarCtl ()<CDTabbarDelegate>

@end

@implementation CDTabbarCtl
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 首页
    [self addChildViewController:[[CDMapViewController alloc] init] image:@"tab_home_nor" seletedImage:@"tab_home_press" title:@"地图"];
    [self addChildViewController:[[CDoderViewController alloc] init] image:@"tab_classify_nor"  seletedImage:@"tab_classify_press"  title:@"订单"];
    [self addChildViewController:[[CDchargeViewController alloc] init] image:@"tab_community_nor"  seletedImage:@"tab_community_press"  title:@"预约"];
    [self addChildViewController:[[CDMineViewController alloc] init] image:@"tab_me_nor"  seletedImage:@"tab_me_press"  title:@"我的"];

    
    CDTabbar *tabBar = [CDTabbar tabBar];
    tabBar.delegate = self;
    // 设置自定义tabBar(使用kvc)
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    // 判断是否登录
   
    
    if (![self is_login]) {
//        未登录哦
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
                
                CDViewController *cview = [[CDViewController alloc]init];
                CDNav *navi = [[CDNav alloc]initWithRootViewController:cview];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navi animated:YES completion:nil];
         
            
        });
        
    }else{
//        已经登录哦
        [CDMessage shareMessage];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)addChildViewController:(UIViewController *)childController image:(NSString *)image seletedImage:(NSString *)selectedImage title:(NSString *)title
{
    // 包装导航条
    CDNav *nav = [[CDNav alloc] initWithRootViewController:childController];
    // 设置标题
    childController.title = title;

    // 设置图片
    [childController.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //选中字体颜色
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:LHColor(34, 34, 34)} forState:UIControlStateSelected];
//    选中字体颜色
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:LHColor(34, 34, 34)} forState:UIControlStateNormal];
    // 添加子控制器
    [self addChildViewController:nav];
    //    return childController;
}
-(void)tabBarDidPlusClick:(UIButton *)btn{
    //添加一些扫码或相册结果处理
   
    CDscanViewController *vc = [CDscanViewController new];
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    
    vc.style = [StyleDIY qqStyle];
    
    //镜头拉远拉近功能
    vc.isVideoZoom = YES;
//     CDNav *navi = [[CDNav alloc]initWithRootViewController:vc];
   [self.selectedViewController presentViewController:vc animated:YES completion:nil];
}
- (BOOL)is_login{
    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
    BOOL is_login = [userdf boolForKey:@"isLogin"];
    if (is_login) {
        return YES;
    }
    return NO;
}
@end
