//
//  AppDelegate.h
//  Manito
//
//  Created by Johnny on 15/4/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL _isFull; // 是否全屏
}

@property ( nonatomic ) BOOL isFull;
@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shared;

@end

