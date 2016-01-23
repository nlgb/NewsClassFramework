//
//  ViewController.m
//  NewsClassFramework
//
//  Created by sw on 16/1/24.
//  Copyright © 2016年 sw. All rights reserved.
//

//
//  ViewController.m
//  JUMEI
//
//  Created by sw on 15/12/30.
//  Copyright © 2015年 sw. All rights reserved.
//

#import "ViewController.h"

#import "yuleViewController.h"
#import "yaoyiyaoViewController.h"
#import "messageViewController.h"
#import "shipinViewController.h"
#import "pifuViewController.h"
#import "shezhiViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildController];
}
-(void)setUpChildController
{
    yuleViewController *mainPageVC = [[yuleViewController alloc]init];
    mainPageVC.title = @"首页";
    [self addChildViewController:mainPageVC];
    
    yaoyiyaoViewController *saleVC = [[yaoyiyaoViewController alloc]init];
    saleVC.title = @"名品特卖";
    [self addChildViewController:saleVC];
    
    messageViewController *marketVC = [[messageViewController alloc]init];
    marketVC.title = @"美妆商城";
    [self addChildViewController:marketVC];
    
    shipinViewController *buyVC = [[shipinViewController alloc]init];
    buyVC.title = @"购物车";
    [self addChildViewController:buyVC];
    
    pifuViewController *meVC = [[pifuViewController alloc]init];
    meVC.title = @"我的";
    [self addChildViewController:meVC];
    
    shezhiViewController *settingVC = [[shezhiViewController alloc]init];
    settingVC.title = @"设置";
    [self addChildViewController:settingVC];
    
    
    
    
    
}

@end

