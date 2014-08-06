//
//  LevelSelectPanel.m
//  CountingStars
//
//  Created by xxx on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SettingsPanel.h"
#import "AppDelegate.h"
#import "GamePlayScene.h"
#import "MainScene.h"
#import "Config.h"

@implementation SettingsPanel {
    BOOL isMusicOn;
    CCLabelTTF *_levelLabel;
    CCButton *_toggleMusicButton;
    CCButton *_nextSongButton;
    CCButton *_decreaseButton;
    CCButton *_increaseButton;
    CCButton *_confirmButton;
    CCButton *_returnMainMenuButton;
    
    long _playLevel;
    NSUserDefaults *_defaults;
    OALSimpleAudio *_audio;
    
    CCLabelTTF *_toastLabel;
    CCSlider *_bgVolumeSlider;
}

- (void)onEnter {
    _audio = [OALSimpleAudio sharedInstance];
    _toggleMusicButton.selected = _audio.bgPaused;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    //_playLevel =[_defaults integerForKey:@"playLevel"];
    _playLevel = globalCurrentLevel;
    
    if (_playLevel == 0) {
        _decreaseButton.enabled = FALSE;
    }
    if (_playLevel == 19) {
        _increaseButton.enabled = FALSE;
    }
    _levelLabel.string = [NSString stringWithFormat:@"Level  -  %ld", _playLevel + 1];
    
    _bgVolumeSlider.continuous = TRUE;

    
    // Initialize toggle-music button
    if ([_defaults boolForKey:@"not_first_time_to_toggle_music"] == TRUE) {
        _toggleMusicButton.selected = [_defaults boolForKey:@"musicPaused"];
    } else {
        _toggleMusicButton.selected = FALSE;
        isMusicOn = TRUE;
    }
    [_defaults setBool:TRUE forKey:@"not_first_time_to_toggle_music"];
    [_defaults setBool:_audio.bgPaused forKey:@"musicPaused"];
    
    // Initialize set-volume slider
    if ([_defaults boolForKey:@"not_first_time_to_set_volume"] == TRUE) {
        _bgVolumeSlider.sliderValue = [_defaults floatForKey:@"volume"];
    } else {
        _bgVolumeSlider.sliderValue = 1.0;
    }
    [_defaults setBool:TRUE forKey:@"not_first_time_to_set_volume"];
    [_defaults setFloat:_audio.bgVolume forKey:@"volume"];

    
    if ([self.parent.parent isKindOfClass:[MainScene class]]) {
        _returnMainMenuButton.enabled = FALSE;
    }
    
    [super onEnter];
}

- (void)toggleMusic {
    if (isMusicOn) {
        isMusicOn = FALSE;
        _audio.bgPaused = TRUE;
        NSLog(@"Off");
    } else {
        isMusicOn = TRUE;
        _audio.bgPaused = FALSE;
        NSLog(@"On");
    }
    _toggleMusicButton.selected = _audio.bgPaused;
    [_defaults setBool:_audio.bgPaused forKey:@"musicPaused"];
}

- (void)nextSong {
    BOOL isBgPaused = _audio.bgPaused;
    int nextMusicIndex;
/*
    do {
        nextMusicIndex = arc4random() % (NUMBER_OF_MUSICS);
    } while (nextMusicIndex == currentMusicIndex);
*/
    nextMusicIndex = currentMusicIndex + 1;
    if (nextMusicIndex == NUMBER_OF_MUSICS) nextMusicIndex = 0;
    currentMusicIndex = nextMusicIndex;
    _toastLabel.string = [NSString stringWithFormat:@"Soundtrack %d", currentMusicIndex + 1];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1];
    [_toastLabel runAction:fadeOut];
    
    [_audio playBg:MUSICS[nextMusicIndex]];
    
    _audio.bgPaused = isBgPaused;
}

- (void)increaseLevel {
    [_audio playEffect:@"pop.wav"];
    _playLevel++;
    _levelLabel.string = [NSString stringWithFormat:@"Level  -  %ld", _playLevel + 1];
    if (_playLevel > 0) {
        _decreaseButton.enabled = TRUE;
    }
    if (_playLevel == 19) {
        _increaseButton.enabled = FALSE;
    }
}

- (void)decreaseLevel {
    [_audio playEffect:@"pop.wav"];
    _playLevel--;
    _levelLabel.string = [NSString stringWithFormat:@"Level  -  %ld", _playLevel + 1];
    if (_playLevel < 19) {
        _increaseButton.enabled = TRUE;
    }
    if (_playLevel == 0) {
        _decreaseButton.enabled = FALSE;
    }
}

- (void)jumpToLevel {
    [_audio playEffect:@"pop.wav"];
    [_defaults setInteger:_playLevel forKey:@"playLevel"];
    [_defaults synchronize];
    
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GamePlayScene"] withTransition:transition];
}

- (void)cancel {
    [_audio playEffect:@"pop.wav"];
    if ([self.parent.parent isKindOfClass:[GamePlayScene class]]) {
        [((GamePlayScene *) self.parent.parent) continueGame];
    } else {
        [((MainScene *) self.parent.parent) returnFromSettings];
    }
}

- (void)changeVolume {
    _audio.bgVolume = _bgVolumeSlider.sliderValue;
    [_defaults setFloat:_audio.bgVolume forKey:@"volume"];
    
    _toastLabel.string = [NSString stringWithFormat:@"%d %%", (int) (_audio.bgVolume * 100)];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1];
    [_toastLabel runAction:fadeOut];
}

- (void)returnMainMenu{
    [_audio playEffect:@"pop.wav"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:transition];
}

@end
