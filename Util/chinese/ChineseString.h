//
//  ChineseString.h
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMAddModel.h"

@interface ChineseString : NSObject

@property(nonatomic, copy)NSString *string;
@property(nonatomic, copy)NSString *pinYin;

/**添加一个属性,保存名字所对应的字典*/
@property(nonatomic, strong) MMAddModel *info;
@end
