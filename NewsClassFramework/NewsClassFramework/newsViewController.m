//
//  newsViewController.m
//  NewsClassFramework
//
//  Created by sw on 16/1/24.
//  Copyright © 2016年 sw. All rights reserved.
//

#import "newsViewController.h"

static CGFloat const navBarH = 64;
static CGFloat const titleScrollViewH = 44;
static CGFloat const btnW = 100;
static CGFloat const titileScale = 1.3;

#define LDLScreenW [UIScreen mainScreen].bounds.size.width
#define LDLScreenH [UIScreen mainScreen].bounds.size.height

#define LDLRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

@interface newsViewController ()<UIScrollViewDelegate>

@property (nonatomic ,weak) UIScrollView *titleScrollView;

@property (nonatomic ,weak) UIScrollView *contentScrollView;

@property (nonatomic ,weak) UIButton *selectedBtn;
@property (nonatomic ,strong) NSMutableArray<UIButton *> *titleBtns;
@property (nonatomic ,assign) BOOL isInitial;
@end

@implementation newsViewController
- (NSMutableArray<UIButton *>*)titleBtns
{
    if (!_titleBtns) {
        _titleBtns = [NSMutableArray array];
        
    }
    return _titleBtns;
    
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1.添加标题滚动视图;
    [self addTitleScrollView];
    //2.添加内容滚动视图;
    [self addContentScrollView];
    
    
    //取消自动添加额外区域;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //4.添加所有标题;
    if (!_isInitial) {
        
        [self addAllTitle];
    }
    
    self.isInitial = YES;
    
    
    
}


//添加标题滚动视图;
- (void)addTitleScrollView
{
    UIScrollView *titleScrollView = [[UIScrollView alloc]init];
    CGFloat titleScrollViewX =0 ;
    CGFloat titleScrollViewY = self.navigationController ? navBarH : 0 ;
    CGFloat titleScrollViewW = LDLScreenW ;
    titleScrollView.frame = CGRectMake(titleScrollViewX, titleScrollViewY, titleScrollViewW, titleScrollViewH);
    titleScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
}

//添加内容滚动视图;
- (void)addContentScrollView
{
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    CGFloat contentScrollViewX =0 ;
    CGFloat contentScrollViewY = CGRectGetMaxY(self.titleScrollView.frame) ;
    CGFloat contentScrollViewW = LDLScreenW ;
    CGFloat contentScrollViewH= LDLScreenH - contentScrollViewY ;
    
    contentScrollView.frame = CGRectMake(contentScrollViewX, contentScrollViewY, contentScrollViewW, contentScrollViewH);
    contentScrollView.backgroundColor = LDLRandomColor;
    [self.view addSubview:contentScrollView];
    contentScrollView.delegate = self;
    _contentScrollView = contentScrollView;
    
    
    
}
//添加所有标题;
- (void)addAllTitle
{
    
    NSInteger count = self.childViewControllers.count;
    
    for (int i = 0; i < count; i ++ ) {
        
        //4.1 创建标题按钮;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnX = i * btnW;
        btn.tag = i;
        btn.frame = CGRectMake(btnX, 0, btnW, titleScrollViewH);
        [self.titleScrollView addSubview:btn];
        
        //4.2 设置按钮标题内容;
        UIViewController *vc = self.childViewControllers[i];
        vc.view.backgroundColor = LDLRandomColor;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //4.3 按钮监听;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        //4.4 默认选择第0个按钮;
        if (i == 0) {
            [self btnClick:btn];
        }
        
        //4.5保存btn到对应的数组
        [self.titleBtns addObject:btn];
        
        
    }
    //4.3设置标题滚动条的滚动范围;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat titleContentW = self.childViewControllers.count * btnW;
    self.titleScrollView.contentSize = CGSizeMake(titleContentW, titleScrollViewH);
    
    
    //4.4.设置内容滚动视图的滚动范围;
    self.contentScrollView.contentSize = CGSizeMake(count * LDLScreenW, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;;
    self.contentScrollView.bounces = NO;
    
}


//按钮监听;
- (void)btnClick:(UIButton *)btn
{
    //1.按钮变红;
    [self btnGetRedWhenSelected:btn];
    
    
    //2.对应的控制器view,滚动到对应的位置;
    NSInteger i = btn.tag;
    UIViewController *vc = self.childViewControllers[i];
    
    CGFloat x = i * LDLScreenW;
    CGFloat y = 0;
    CGFloat w = LDLScreenW;
    CGFloat h = self.contentScrollView.bounds.size.height;
    
    vc.view.frame = CGRectMake(x,y, w, h);
    [self.contentScrollView addSubview:vc.view];
    
    //让scrollView滚动到对应的位置;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    
    
    
    
    
}
- (void)btnGetRedWhenSelected:(UIButton *)btn
{
    //恢复上一个选中按钮的颜色;
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //恢复上一个按钮的尺寸;
    _selectedBtn.transform = CGAffineTransformIdentity;
    //设置当前按钮颜色;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //设置标题缩放:
    btn.transform = CGAffineTransformMakeScale(titileScale, titileScale);
    //记录当前按钮;
    _selectedBtn = btn;
    //设置标题居中显示;
    [self setUpTitleCenter:btn];
    
}
- (void)setUpTitleCenter:(UIButton *)btn
{
    CGFloat offsetX = btn.center.x - LDLScreenW *0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - LDLScreenW;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    
    
}
//添加所有子控制器的view到contentView上去;

- (void)setUpAllChildrenControllerView:(NSInteger)i
{
    
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) return;
    CGFloat x  = i *LDLScreenW;
    CGFloat y  = 0;
    CGFloat w  = LDLScreenW;
    CGFloat h  = self.contentScrollView.bounds.size.height;
    
    vc.view.frame = CGRectMake(x, y , w , h );
    [self.contentScrollView addSubview:vc.view];
    
    
    
    
}





#pragma mark - UIScrollViewDelegate;
//滚动完成的时候调用;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger i = offsetX / LDLScreenW;
    
    //    UIButton *btn = self.titleBtns[i];
    UIButton *btn = self.titleScrollView.subviews[i];
    [self btnGetRedWhenSelected:btn];
    
    [self setUpAllChildrenControllerView:i];
    
    
}
//只要以滚动就会调用的方法;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger count = self.titleBtns.count;
    //左边按钮的脚标;
    NSInteger leftI = scrollView.contentOffset.x / LDLScreenW;
    //右边按钮的脚标;
    NSInteger rightI = leftI + 1;
    //获取左边按钮leftBtn;
    UIButton *leftBtn = self.titleBtns[leftI];
    //获取右边按钮rightBtn;
    UIButton *rightBtn;
    if (rightI < count) {
        rightBtn = self.titleBtns[rightI];
    }
    //LScale;
    CGFloat RScale = scrollView.contentOffset.x / LDLScreenW - leftI;
    //RScale;
    CGFloat LScale = 1 - RScale;
    CGFloat transformScale = titileScale - 1;
    
    leftBtn.transform = CGAffineTransformMakeScale((transformScale*LScale + 1), (transformScale*LScale + 1));
    rightBtn.transform = CGAffineTransformMakeScale((transformScale*RScale+ 1), (transformScale*RScale + 1));
    
    //设置渐变颜色;
    UIColor *leftColor = [UIColor colorWithRed:LScale green:0 blue:0 alpha:1];
    UIColor *rightColor = [UIColor colorWithRed:RScale green:0 blue:0 alpha:1];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    
    
}

@end
