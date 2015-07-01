//
//  MMWelcomeViewController.m
//  Manito
//
//  Created by manito on 15/5/22.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMWelcomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MMLoginViewController.h"

@interface MMWelcomeViewController ()
{
    AVPlayer *player;
    UIButton *nextBtn;
}
@end

@implementation MMWelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.showNavi = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    if([_type isEqualToString:@"login"]) {
        [self loadAVPlayer];
        [self setBtn];
    } else {
        [self loadHaveLoginAVplayer];

    }

}

- (void)setBtn {
    nextBtn = [UIButton newAutoLayoutView];
    [self.view addSubview:nextBtn];
    [nextBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nextBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:39];
    [nextBtn autoSetDimension:ALDimensionWidth toSize:KKScreenWith*352/640];
    [nextBtn autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:nextBtn withMultiplier:352/116];
    [nextBtn setTitle:@"Touch" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:22];
    nextBtn.layer.cornerRadius = 10;
    nextBtn.clipsToBounds = YES;
    nextBtn.backgroundColor = MMColor(255, 70, 92, .6);
    [nextBtn bk_whenTapped:^{
        POPBasicAnimation *base = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        base.toValue = [NSValue valueWithCGRect:CGRectMake(0, -KKScreenHeight, KKScreenWith, KKScreenHeight)];
        base.duration = 0.5;
        base.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (finished) {
                [player pause];
                [self.view removeFromSuperview];
                if ([_type isEqualToString: @"login"]) {
                    MMLoginViewController *login = [[MMLoginViewController alloc] init];
                    login.haveBack = NO;
                    login.showNavi = NO;
                    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
                    [[AppDelegate shared].window setRootViewController:loginNav];
                }
            }
        };
        [self.view pop_addAnimation:base forKey:@"haha"];
    }];
}
- (void)loadAVPlayer{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"1242_all.mp4"ofType:nil];//取得视频路径
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];//读取视频
    
    player = [AVPlayer playerWithPlayerItem:playerItem];//用读好的视频初始化AVplayer播放器
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];//设置播放器的layer
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];//把播放器的layer添加到父视图的layer上
    [player play];//开始播放
   
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(next) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//播放已经登录了的视频
- (void)loadHaveLoginAVplayer {
    NSString *path=[[NSBundle mainBundle] pathForResource:@"1242_A.mp4"ofType:nil];//取得视频路径
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];//读取视频
    
    player = [AVPlayer playerWithPlayerItem:playerItem];//用读好的视频初始化AVplayer播放器
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];//设置播放器的layer
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];//把播放器的layer添加到父视图的layer上
    [player play];//开始播放
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goTOMainViewController) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//播放完之后跳到主界面
- (void)goTOMainViewController {
    [self.view removeFromSuperview];
}

- (void)next {
    NSString *path=[[NSBundle mainBundle] pathForResource:@"1242x2208_b.mp4"ofType:nil];//取得视频路径
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];//读取视频
    player = [AVPlayer playerWithPlayerItem:playerItem];//用读好的视频初始化AVplayer播放器
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];//设置播放器的layer
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];//把播放器的layer添加到父视图的layer上
    [player play];//开始播放
    
    [self setBtn];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)runLoopTheMovie:(NSNotification *)notifi{
    //注册的通知  可以自动把 AVPlayerItem 对象传过来，只要接收一下就OK
    AVPlayerItem * playerItem = [notifi object];
    //关键代码
    [playerItem seekToTime:kCMTimeZero];
    [player play];
    
    //停止播放
    //    [player pause];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
