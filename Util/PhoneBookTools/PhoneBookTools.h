//
//  PhoneBookTools.h
//  PhoneBookDemo
//
//  Created by manito on 15/5/16.
//  Copyright (c) 2015年 manito. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^finishGetPhoneBook)(NSMutableArray *phoneBookArr);

@interface PhoneBookTools : NSObject


+ (instancetype)sharePhoneBookTools;

- (void)getPhoneBook:(finishGetPhoneBook)phoneBook;

@end
