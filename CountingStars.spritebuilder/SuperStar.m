//
//  SuperStar.m
//  CountingStars
//
//  Created by xxx on 7/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperStar.h"
#import "Config.h"
#import "GamePlayScene.h"

@implementation SuperStar {
    float _timePassed;
    int _num;
    CCLabelTTF *_numLabel;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    self.positionType = CCPositionTypeNormalized;
    self.position = CGPointMake((float) ((arc4random() % 900) + 50) / 1000,
                                (float) ((arc4random() % 900) + 50) / 1000);
    _num = arc4random() % SUPER_STAR_RANGE + SUPER_STAR_BASE;
    _numLabel.string = [NSString stringWithFormat:@"%d", _num];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([((GamePlayScene*) self.parent.parent) isGameStartedAndRunning]) {
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"super_star_clicked.mp3"];
        
        NSLog(@"%d", _num);
        for (int i = 0; i < _num; i++) {
            [((GamePlayScene*) self.parent.parent) elimStar];
        }
        [self removeFromParentAndCleanup:TRUE];
    }
}

- (void)fixedUpdate:(CCTime)delta {
    if ([((GamePlayScene*) self.parent.parent) isGameStartedAndRunning])
    {
        _timePassed += delta;
        if (_timePassed >= SUPER_STAR_HOLD_TIME) {
            _timePassed = 0;
            self.position = CGPointMake((float) ((arc4random() % 900) + 50) / 1000,
                                        (float) ((arc4random() % 900) + 50) / 1000);
            _num = arc4random() % SUPER_STAR_RANGE + SUPER_STAR_BASE;
            _numLabel.string = [NSString stringWithFormat:@"%d", _num];
        }
    }
}

@end
