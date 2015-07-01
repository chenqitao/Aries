//
//  BJKeyboardScrollView.h
//  BJEducation
//
//  Created by Randy on 14-10-8.
//  Copyright (c) 2014年 com.bjhl. All rights reserved.
//

/*
 使用时注意设置 firstResponderView 否则不会生效
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField方法中设置
 */

#import <UIKit/UIKit.h>

@interface BJKeyboardScrollView : UIScrollView
@property (nonatomic,strong)UIView *firstResponderView;

@end
