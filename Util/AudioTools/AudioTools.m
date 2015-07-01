//
//  AvdioTools.m
//  AvdioDemo
//
//  Created by manito on 15/5/15.
//  Copyright (c) 2015年 manito. All rights reserved.
//

#import "AudioTools.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID shake_sound_male_id = 0;

@implementation AudioTools

+(instancetype)shareplaySouldTools
{
    static AudioTools *avdioTools = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        avdioTools = [[AudioTools alloc] init];
    });
    return avdioTools;
}

- (void)playSould:(NSString *)name ofType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

@end
