//
//  MMGifViewController.m
//  Manito
//
//  Created by manito on 15/5/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMGifViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

@interface MMGifViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scroll;
    UIView *leftView;
    UIView *centerView;
    UIView *centerTwoView;
    UIView *rightView;
    UIButton *backBtn;
}

@end

@implementation MMGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能介绍";
}

- (void)createUI {
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenHeight)];
    [self.view addSubview:scroll];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.bounces = NO;
    [scroll setContentSize:CGSizeMake(KKScreenWith * 4, KKScreenHeight)];
    scroll.contentOffset = CGPointMake(0, 0);
    
    //左边的View
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenHeight)];
    [scroll addSubview:leftView];
    leftView.userInteractionEnabled = YES;
    YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenHeight)];
    [leftView addSubview:imageView];
    imageView.image = [YLGIFImage imageNamed:@"help-page1@3x.gif"];
    
    //中间的View
    centerView = [[UIView alloc] initWithFrame:CGRectMake(KKScreenWith, 0, KKScreenWith, KKScreenHeight)];
    [scroll addSubview:centerView];
    centerView.userInteractionEnabled = YES;
    YLImageView* imageView2 = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenHeight)];
    [centerView addSubview:imageView2];
    imageView2.image = [YLGIFImage imageNamed:@"help-page2@3x.gif"];
    
    //第三张
    centerTwoView = [[UIView alloc] initWithFrame:CGRectMake(KKScreenWith*2, 0, KKScreenWith, KKScreenHeight)];
    [scroll addSubview:centerTwoView];
    centerTwoView.userInteractionEnabled = YES;
    YLImageView* imageView3 = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenHeight)];
    [centerTwoView addSubview:imageView3];
    imageView3.image = [YLGIFImage imageNamed:@"help-page3@3x.gif"];
    
    //第四张
    rightView = [[UIView alloc] initWithFrame:CGRectMake(KKScreenWith*3, 0, KKScreenWith, KKScreenHeight)];
    [scroll addSubview:rightView];
    rightView.userInteractionEnabled = YES;
    YLImageView* imageView4 = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenHeight)];
    [rightView addSubview:imageView4];
    imageView4.image = [YLGIFImage imageNamed:@"help-page4@3x.gif"];
    
    backBtn = [UIButton newAutoLayoutView];
    [self.view addSubview:backBtn];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:60];
    [backBtn autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [backBtn setTitle:@"skip" forState:UIControlStateNormal];
    backBtn.clipsToBounds = YES;
    backBtn.layer.cornerRadius = 20;
    backBtn.backgroundColor = MMBaseColor;
    [backBtn bk_whenTapped:^{
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
#pragma mark - scrollView delegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSInteger i=scrollView.contentOffset.x/KKScreenWith;
    if (i == 3) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
