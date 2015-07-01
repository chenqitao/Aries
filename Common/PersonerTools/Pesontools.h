//
//  Pesontools.h
//  Manito
//
//  Created by manito on 15/5/23.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPerson.h"

@interface Pesontools : NSObject

+ (instancetype)shared;
- (void)setPersonModelWithPersonModel:(MMPerson *)pModel;
- (MMPerson *)peronMode;


@end
