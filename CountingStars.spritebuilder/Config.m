//
//  config2.m
//  CountingStars
//
//  Created by xxx on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "Config.h"


NSString * const MUSICS[] = {
    @"Always With Me.mp3",                  // 1
    @"A Whole New World.mp3",               // 2
    @"Can You Feel The Love Tonight.mp3",   // 3
    @"Can't Let You Go.mp3",                // 4
    @"I Will Always Love You.mp3",          // 5
    @"My Heart Will Go On.mp3",             // 6
    @"Somewhere Out There.mp3"              // 7
};

long globalCurrentLevel;

int currentMusicIndex;

int ShootingStarVelocity = SHOOTING_STAR_VELOCITY;

@implementation Config

+ (int)calcTotalTime:(unsigned long)starCount {
    return 1.2 * starCount;
}

@end