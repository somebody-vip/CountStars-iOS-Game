//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Config.h"
#import "SettingsPanel.h"

@implementation MainScene {
    OALSimpleAudio *_audio;
    SettingsPanel *_settingsPanel;
    CCPhysicsNode *_starFieldPhysics;
    CCNode *_nodeContainer;
    CCButton *_settingsButton;
    CCButton *_playButton;
    
    float _timePassed;
}

- (void)didLoadFromCCB {
    _audio = [OALSimpleAudio sharedInstance];
    self.userInteractionEnabled = YES;
    _settingsPanel.cancelButton.enabled = FALSE;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"touched");
}

- (void)settings {
    [_audio playEffect:@"pop.wav"];
    _settingsButton.enabled = FALSE;
    _settingsPanel = (SettingsPanel*) [CCBReader load: @"SettingsPanel"];
    [_nodeContainer addChild:_settingsPanel];
}

- (void)playGame {
    [_audio playEffect:@"pop.wav"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GamePlayScene"] withTransition:transition];
}

- (void)returnFromSettings {
    [_nodeContainer removeChild: _settingsPanel cleanup:TRUE];
    _settingsButton.enabled = TRUE;
    
}

- (void)fixedUpdate:(CCTime)delta {
    _timePassed += delta;
    if (_timePassed >= 0.30) {
        _timePassed = 0;
        if (((float) arc4random()) / RAND_MAX < SHOOTING_STAR_PROB) {
            CCNode *shootingStar = [CCBReader load:@"ShootingStar"];
            [_starFieldPhysics addChild:shootingStar];
        }
    }
}

@end
