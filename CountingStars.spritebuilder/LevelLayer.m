//
//  LevelLayer.m
//  CountingStars
//
//  Created by xxx on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelLayer.h"
#import "Config.h"
#import "GamePlayScene.h"

@implementation LevelLayer {
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_starCountLabel;
    CCLabelTTF *_countDownLabel;
    
    float _timePassed;
}

- (void)onEnter {
    _levelLabel.string = [NSString stringWithFormat:@"Level  -  %ld",
                          globalCurrentLevel  + 1];
    _starCountLabel.String = [NSString stringWithFormat:@"%ld  Stars",
                              ((GamePlayScene*) self.parent.parent).initialStarCount];
    [super onEnter];
}

- (void)update:(CCTime)delta {
    if (((GamePlayScene*) self.parent.parent).isGameRunning) {
        _timePassed += delta;
    
        if (_timePassed >= 3 + COUNT_DOWN_POPUP_TIME) {
            [((GamePlayScene*) self.parent.parent) startGame];
        } else if (_timePassed >= 2 + COUNT_DOWN_POPUP_TIME) {
            _countDownLabel.string = @"1";
        } else if (_timePassed >= 1 + COUNT_DOWN_POPUP_TIME) {
            _countDownLabel.string = @"2";
        } else if (_timePassed >= COUNT_DOWN_POPUP_TIME) {
            _countDownLabel.string = @"3";
        }
    }
}

@end
