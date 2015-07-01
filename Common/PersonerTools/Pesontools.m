//
//  Pesontools.m
//  Manito
//
//  Created by manito on 15/5/23.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "Pesontools.h"


@interface Pesontools ()
{
    MMPerson *person;
}

@end

@implementation Pesontools

+ (instancetype)shared
{
    static Pesontools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[Pesontools alloc] init];
    });
    return tools;
}

- (void)setPersonModelWithPersonModel:(MMPerson *)pModel {
    person = pModel;
}

- (MMPerson *)peronMode {
    return person;
}

@end
