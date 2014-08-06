//
//  Bomb.m
//  CountingStars
//
//  Created by xxx on 7/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bomb.h"
#import "Config.h"
#import "GamePlayScene.h"

@implementation Bomb {
    CCLabelTTF *_countDownLabel;
    int _countDown;
    float _timePassed;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    _countDown = BOMB_COUNT_DOWN;
    _countDownLabel.string = [NSString stringWithFormat:@"%d", _countDown];
    self.positionType = CCPositionTypeNormalized;
    self.position = CGPointMake((float) ((arc4random() % 900) + 50) / 1000,
                                (float) ((arc4random() % 900) + 50) / 1000);
//    [super onEnter];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([((GamePlayScene*) self.parent.parent) isGameStartedAndRunning]) {
        // play sound effect
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"bubble.mp3"];
        
        [((GamePlayScene*) self.parent.parent) addScore:(100 * _countDown)];
        [self removeFromParentAndCleanup:TRUE];
    }
}

- (void)fixedUpdate:(CCTime)delta {
    if ([((GamePlayScene*) self.parent.parent) isGameStartedAndRunning])
    {
        _timePassed += delta;
        if (_timePassed >= 1) {
            _timePassed = 0;
            _countDown--;
            _countDownLabel.string = [NSString stringWithFormat:@"%d", _countDown];
            if (_countDown <= 0) {
                // In case the game is already won
                if (!((GamePlayScene*) self.parent.parent).isGameFinished) {
                    [((GamePlayScene*) self.parent.parent) fail];
                }
                
                // load particle effect
                CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Explosion_Big"];
                // place the particle effect on the seals position
                explosion.positionType = CCPositionTypeNormalized;
                explosion.position = self.position;
                // add the particle effect to the same node the seal is on
                [self.parent addChild:explosion];
                // make the particle effect clean itself up, once it is completed
                explosion.autoRemoveOnFinish = YES;
                
                // play sound effect
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                [audio playEffect:@"explosion.wav"];
                
                [self removeFromParentAndCleanup:TRUE];
            }
        }
    }
}

@end
