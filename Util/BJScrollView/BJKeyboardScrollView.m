//
//  BJKeyboardScrollView.m
//  BJEducation
//
//  Created by Randy on 14-10-8.
//  Copyright (c) 2014年 com.bjhl. All rights reserved.
//

#import "BJKeyboardScrollView.h"

@implementation BJKeyboardScrollView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (newSuperview) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (UIView *)getFirstResponderView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIResponder *firstResponder = keyWindow;
    while (firstResponder.nextResponder) {
        if ([firstResponder.nextResponder isFirstResponder] &&
            [firstResponder.nextResponder isKindOfClass:[UIView class]]) {
            return (UIView *)firstResponder.nextResponder;
        }
        else
            firstResponder = firstResponder.nextResponder;
    }
    return nil;
}

#pragma mark - 处理键盘事件
- (void)keyboardShow:(NSNotification *)noti
{
    NSDictionary* info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets insets = self.contentInset;
    
    CGRect keyRect = [[UIApplication sharedApplication].delegate window].frame;
    CGRect scrollRect = [self convertRect:self.frame toView:[[UIApplication sharedApplication].delegate window]];
    CGFloat height = keyRect.size.height - scrollRect.size.height - scrollRect.origin.y - self.contentOffset.y;
    
    insets.bottom = kbSize.height - height;
    
    self.contentInset = insets;
    self.scrollIndicatorInsets = insets;
    
    if (self.firstResponderView) {
        UIView *superView = self.firstResponderView;
        while (superView.superview != self) {
            superView = superView.superview;
        }
        if (self.firstResponderView != superView) {
            CGRect rec = [self.firstResponderView.superview convertRect:self.firstResponderView.frame toView:self];
            [self scrollRectToVisible:rec animated:true];
        }
        else
        {
            [self scrollRectToVisible:self.firstResponderView.frame animated:true];
        }
    }

}

- (void)keyboardHidden:(NSNotification *)noti
{
    self.firstResponderView = nil;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
}


@end
