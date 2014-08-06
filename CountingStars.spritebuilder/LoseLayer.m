//
//  LoseLayer.m
//  CountingStars
//
//  Created by xxx on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LoseLayer.h"
#import "GamePlayScene.h"
#import "Config.h"

@implementation LoseLayer {
    CCButton *_lastLevelButton;
    CCButton *_nextLevelButton;
    OALSimpleAudio *_audio;
    NSUserDefaults *_defaults;
}

- (void)didLoadFromCCB {
    if (globalCurrentLevel <= 0) _lastLevelButton.enabled = FALSE;
    if (globalCurrentLevel >= 19) _nextLevelButton.enabled = FALSE;
    
    _audio = [OALSimpleAudio sharedInstance];
    self.userInteractionEnabled = TRUE;
}

- (void)lastLevel{
    [_audio playEffect:@"pop.wav"];
    [((GamePlayScene*) self.parent.parent) lastLevel];
}

- (void)nextLevel{
    [_audio playEffect:@"pop.wav"];
    [((GamePlayScene*) self.parent.parent) nextLevel];
}

@end
