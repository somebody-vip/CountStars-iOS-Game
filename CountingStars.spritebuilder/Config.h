//
//  Config.h
//  CountingStars
//
//  Created by xxx on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
extern NSString * const MUSICS[];
extern long globalCurrentLevel;
extern int currentMusicIndex;
extern int ShootingStarVelocity;

#ifndef CountingStars_Config_h

#define CountingStars_Config_h

//#define BLINKING_ON

#define STAR_INTERVAL 1      /* Time interval in seconds in which a star number is continuously visible or invisible */

#define MAX_STAR_COUNT 20

#define SCORE_EACH_STAR 100

#define TOUCH_SCALE_FACTOR 1.5

#define COUNT_DOWN_POPUP_TIME 0.3

// The number of background musics
#define NUMBER_OF_MUSICS 7

#define BOMB_COUNT_DOWN 3


#define SUPER_STAR_HOLD_TIME 1.2

//#define SUPER_STAR_MARGIN_TIME 5

#define SUPER_STAR_BASE 2

#define SUPER_STAR_RANGE 4

#define SHOOTING_STAR_VELOCITY 300;

#define SHOOTING_STAR_LIFE 5;

#define SHOOTING_STAR_MAX_ADD_TIME 15;

#define SHOOTING_STAR_MIN_ADD_TIME 4;

//Recommended values: 0.1   0.1   0.15

#define SUPER_STAR_PROB 0.1

#define BOMB_PROB 0.1

#define SHOOTING_STAR_PROB 0.15

#endif

//NSString *stringArray[2] = {@"1", @"2"};
//@NSArray *array = @[@"foo",@"bar"];

@interface Config : NSObject

+ (int)calcTotalTime:(unsigned long)starCount;

@end
