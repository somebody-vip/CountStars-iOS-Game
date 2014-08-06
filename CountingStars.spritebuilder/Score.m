//
//  Score.m
//  CountingStars
//
//  Created by xxx on 7/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Score.h"

@implementation Score {
    float _timePassed;
    int _life;
    CCLabelTTF *_text;
}

- (void)didLoadFromCCB {
    self.positionType = CCPositionTypeNormalized;
    _life = 1;
    CCActionMoveBy *moveUp = [CCActionMoveBy actionWithDuration:_life position:ccp(0,0.1)];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:_life];
    
    [self runAction:moveUp];
    [_text runAction:fadeOut];
}

- (void)fixedUpdate:(CCTime)delta {
    _timePassed += delta;
    if (_timePassed >= _life) {
        [self removeFromParent];
    }
}

@end
