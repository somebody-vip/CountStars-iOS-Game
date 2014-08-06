//
//  ShootingStar.m
//  CountingStars
//
//  Created by xxx on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ShootingStar.h"
#import "config.h"
#import "GamePlayScene.h"

@implementation ShootingStar {
    CCParticleSystem *_particleEffect;
    float _timePassed;
    float _velocityAngle;
    float _life;
    int _addTime;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    self.positionType = CCPositionTypeNormalized;
    self.position = ccp((float) ((arc4random() % 900) + 50) / 1000, (float) ((arc4random() % 900) + 50) / 1000);
    _velocityAngle = 2 * M_PI * arc4random() / RAND_MAX;
    float x = cosf(_velocityAngle);
    float y = sinf(_velocityAngle);
    CGPoint vector = CGPointMake(x * ShootingStarVelocity, y * ShootingStarVelocity);
    NSLog(@"%f, %f", vector.x, vector.y);
    self.physicsBody.velocity = vector;
    _life = SHOOTING_STAR_LIFE;
    int maxAddTime = SHOOTING_STAR_MAX_ADD_TIME;
    int minAddTime = SHOOTING_STAR_MIN_ADD_TIME;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _addTime = (int) [defaults integerForKey:@"playLevel"];
    _addTime = MAX(_addTime, minAddTime);
    _addTime = MIN(_addTime, maxAddTime);
}

- (void)onExit {
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"Explosion"];
    // place the particle effect on the seals position
    explosion.positionType = CCPositionTypeNormalized;
    explosion.position = self.position;
    // add the particle effect to the same node the seal is on
    [self.parent addChild:explosion];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = YES;
    
    [super onExit];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"bubble.mp3"];
    
    if ([self.parent.parent isKindOfClass:[GamePlayScene class]]) {
        ((GamePlayScene*) self.parent.parent).remainingTime += _addTime;
        [((GamePlayScene*) self.parent.parent) updateBigLabel:[NSString stringWithFormat:@"+%d\"", _addTime]];
    }
    
    [self removeFromParentAndCleanup: TRUE];
}

- (void)fixedUpdate:(CCTime)delta {
    _life -= delta;
    if (_life <= 0 ) {
        [self removeFromParentAndCleanup:TRUE];
    } else {
    
    // load particle effect
    CCParticleSystem *trail = (CCParticleSystem *)[CCBReader load: @"ShootingStarPE"];
    // place the particle effect on the seals position
    trail.positionType = CCPositionTypeNormalized;
    
    CGPoint trailPosition = self.position;
    // transform the world position to the node space to which the penguin will be added (_physicsNode)
    CGPoint trailPosition2 = [self.parent convertToNodeSpace: trailPosition];
    
    trail.position = trailPosition2;
    
    // add the particle effect to the same node the seal is on
    [self.parent addChild: trail];
    // make the particle effect clean itself up, once it is completed
    trail.autoRemoveOnFinish = YES;
        
    }
}


@end
