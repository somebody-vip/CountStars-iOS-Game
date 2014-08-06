//
//  Star.m
//  CountingStars
//
//  Created by xxx on 6/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Star.h"
#import "GamePlayScene.h"
#import "Config.h"


NSString * const STAR_IMAGE[] = {
    @"assets/stars/star1.png", @"assets/stars/star2.png", @"assets/stars/star3.png"
};


@implementation Star {
    float _timePassed;
    CCParticleSystem *explosion;
}

- (void)didLoadFromCCB {
    _timePassed = CCRANDOM_0_1() * STAR_INTERVAL;
    // _timePassed = ((float)arc4random() / RAND_MAX) * 2;      /* Will do the same thing */
    
    self.userInteractionEnabled = TRUE;
    
    // Determine star image and location
    _shape.spriteFrame = [CCSpriteFrame frameWithImageNamed: STAR_IMAGE[arc4random() % 3] ];
    self.positionType = CCPositionTypeNormalized;
    self.position = CGPointMake((float) ((arc4random() % 900) + 50) / 1000,
                                                   (float) ((arc4random() % 900) + 50) / 1000);
    
    // Randomly rotate the star
    _shape.rotation = arc4random() % 72;
    
    // load particle effect
    explosion = (CCParticleSystem *)[CCBReader load:@"Explosion"];
    // place the particle effect on the seals position
    explosion.positionType = CCPositionTypeNormalized;
    explosion.position = self.position;
}

- (void)onExit {
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"short_bubble.mp3"];
    
    // add the particle effect to the same node the seal is on
    [self.parent addChild:explosion];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    
    [super onExit];
}

- (void)fixedUpdate:(CCTime)delta {
    
#ifdef BLINKING_ON
    if ([((GamePlayScene*) self.parent.parent) isGameStartedAndRunning])
    {
        _timePassed += delta;
        
        if (_timePassed >= STAR_INTERVAL) {
            _timePassed = 0;
            _number.visible = !_number.visible;
        }
    } else if (!((GamePlayScene*) self.parent.parent).isGameRunning) {
        _number.visible = FALSE;
    }
#endif
    
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    self.scale = TOUCH_SCALE_FACTOR;
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if ([((GamePlayScene*) self.parent.parent) isGameStartedAndRunning]) {
        if ( CGRectContainsPoint([self boundingBox], [touch locationInWorld]) )
        {
            if (_isTarget) {
                
                CCNode *score = [CCBReader load:@"Score"];
                score.positionType = CCPositionTypeNormalized;
                score.position = self.position;
                
                [self.parent addChild:score];

                [((GamePlayScene *) self.parent.parent) elimStar];
                
            } else {
                [((GamePlayScene *) self.parent.parent) fail];
            }
        }
    }
    self.scale = 1.0;
}

@end
