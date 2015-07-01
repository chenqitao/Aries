//
//  PhoneBookTools.m
//  PhoneBookDemo
//
//  Created by manito on 15/5/16.
//  Copyright (c) 2015年 manito. All rights reserved.
//

#import "PhoneBookTools.h"
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

@interface PhoneBookTools ()

@property (copy, nonatomic) finishGetPhoneBook callBack;

@end

@implementation PhoneBookTools

+ (instancetype)sharePhoneBookTools
{
    static PhoneBookTools *phoneBookTools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        phoneBookTools = [[PhoneBookTools alloc] init];
    });
    return phoneBookTools;
}

- (void)getPhoneBook:(finishGetPhoneBook)phoneBook
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![[MMUserDefaultTool objectForKey:MMUpLoad] isEqualToString:@"UpLoad"]) {
            if ([self checkAuthority]) {
                [self addressBookList];
            } else {
                [MMUserDefaultTool removeObjectForKey:MMUpLoad];
            }
        }
    });
    self.callBack = phoneBook;
}

- (BOOL)checkAuthority
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 dispatch_semaphore_signal(sema);
                                             });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    //取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        ABAddressBookRequestAccessWithCompletion
        (addressBook, ^(bool granted, CFErrorRef error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (error)
                     NSLog(@"Error: %@", (__bridge NSError *)error);
                 else if (!granted) {
                     UIAlertView *avl = [[UIAlertView alloc]
                                        initWithTitle:@"通讯录访问被拒绝"
                                        message:@"开启通讯录可以获取更多好友\n请在设置－隐私－通讯录中进行设置"
                                        delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"确定", nil];
                     [avl show];
                      [MMUserDefaultTool setObject:@"UpLoad" forKey:MMUpLoad];
                 }
             });
         });
    }
    return authStatus == kABAuthorizationStatusAuthorized;
}

- (void)addressBookList
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    ABAddressBookRef addressBook = nil;
    
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //取得本地所有联系人记录
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSLog(@"all =%ld",CFArrayGetCount(results));
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionary];
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        //读取firstname
        NSString *first = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (first==nil) {
            first = @"";
        }
        //读取lastname
        NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (last == nil) {
            last = @"";
        }
        NSString *name = [NSString stringWithFormat:@"%@%@",first,last];
        [dicInfoLocal setObject:name forKey:@"phone_user"];
        
        ABMultiValueRef tmlphone =  ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *telphone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmlphone, 0);
        if (telphone != nil) {
            NSMutableString *phoneStr = [NSMutableString stringWithString:telphone];
            [phoneStr replaceOccurrencesOfString:@"+86" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [phoneStr length])];
            NSMutableString *newStr = [NSMutableString string];
            for (int i = 0 ; i < phoneStr.length; i ++) {
                NSString *s = [phoneStr substringWithRange:NSMakeRange(i, 1)];
                if ([s isEqualToString:@"0"] || [s isEqualToString:@"1"] ||[s isEqualToString:@"2"] ||[s isEqualToString:@"3"] ||[s isEqualToString:@"4"] ||[s isEqualToString:@"5"] ||[s isEqualToString:@"6"] ||[s isEqualToString:@"7"] ||[s isEqualToString:@"8"] ||[s isEqualToString:@"9"]) {
                    [newStr appendString:s];
                }
            }
            phoneStr = newStr;
            
            if ([phoneStr length] == 11) {
                [dicInfoLocal setObject:phoneStr forKey:@"phone"];
            }
        }
        CFRelease(tmlphone);
        
        if (![name isEqualToString:@""] && [[dicInfoLocal allKeys] containsObject:@"phone"]) {
            [dataArr addObject:dicInfoLocal];
        }
    }
    CFRelease(results);
    CFRelease(addressBook);

    self.callBack(dataArr);
}

@end
