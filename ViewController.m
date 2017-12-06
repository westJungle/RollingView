//
//  ViewController.m
//  RollingView
//
//  Created by 徐晨淼 on 2017/5/23.
//  Copyright © 2017年 Christian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollViews;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置视图背景颜色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //初始化滚动视图控件
    self.scrollViews = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, width, 220)];
    //设置滚动视图的滚动范围
    self.scrollViews.contentSize = CGSizeMake(width*3, 0);
    //设置滚动视图背景颜色
    [self.scrollViews setBackgroundColor:[UIColor grayColor]];
    //设置滚动以页滑动
    self.scrollViews.pagingEnabled = YES;
    //设置滚动视图隐藏水平滚动条
    [self.scrollViews setShowsHorizontalScrollIndicator:NO];
    //设置代理
    [self.scrollViews setDelegate:self];
    
    [self.view addSubview:self.scrollViews];
    
    
    for (NSInteger i = 0; i<3; i++) {
        //创建图片框,添加到滚动视图上
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, 220)];
        //根据索引每次加载图片
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%zd",i+1]];
        //让图片框每次加载的图片都添加到滚动视图上
        [self.scrollViews addSubview:image];
    }
    
    //设置初始化分页控件
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollViews.frame)-20, width, 20)];
    //设置分页显示原点的个数
    [self.pageControl setNumberOfPages:3];
    //设置分页原点的颜色
    [self.pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    
    [self.view addSubview:self.pageControl];
    
    [self initTimer];
}

//滚动控件方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //让分页控件与滚动视图连接
    [self.pageControl setCurrentPage:(NSInteger)(scrollView.contentOffset.x / CGRectGetWidth(self.scrollViews.frame))];
}


-(void)initTimer{
    if (!_timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(intervalAction) userInfo:nil repeats:YES];
    
        //当引入其他滚动视图时,在对第一个滚动控件轮播的定时器就会受到影响,调用这个方法解决
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

//定时器重复方法
-(void)intervalAction{
    
    NSInteger currentPage = self.pageControl.currentPage +1;
    //如果大于等于3就返回0,从新轮播
    if (currentPage >= 3) {
        
        currentPage = 0;
    }
   //滚动视图偏移量的设置
    [self.scrollViews setContentOffset:CGPointMake(currentPage * CGRectGetWidth(self.scrollViews.frame), 0) animated:YES];
}






//当手动控制轮播时,就停止定时器,并为空  就不会影响到定时器轮播时的播放混乱了
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.timer) {
        
        [self.timer invalidate];
        
        self.timer = nil;
        
    }
}

//当手动离开屏幕时,就调用定时器方法,重新轮播
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self initTimer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
