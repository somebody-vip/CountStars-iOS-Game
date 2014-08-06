//
//  GamePlayScene.m
//  CountingStars
//
//  Created by xxx on 6/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlayScene.h"
#import "Star.h"
#import "LevelLayer.h"
#import "SettingsPanel.h"
#import "Config.h"

@implementation GamePlayScene {
    CCButton *_reloadButton;
    CCButton *_settingsButton;
    CCSprite *_timeBarBase;
    
    int _totalTime;
    CCLabelTTF *_remainingTimeLabel;
    int _targetNumber;
    CCLabelTTF *_targetNumberLabel;
    CCLabelTTF *_targetNumberBigLabel;
    int _score;
    CCLabelTTF *_scoreLabel;
    
    
    float _timePassed;
    float _totalTimePassed;
    CCProgressNode *_timeBarNode;
    
    NSMutableArray *_stars;         // The star array
    
    // The actual retangular area where stars would appear
    CCPhysicsNode *_starFieldPhysics;
    CCNode *_nodeContainer;
    CCNode *_starFieldNoPhysics;

    LevelLayer *_levelLayer;
    SettingsPanel *_settingsPanel;
    
    OALSimpleAudio *_audio;
    
    NSMutableArray *_levelsUnlocked;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    _audio = [OALSimpleAudio sharedInstance];
    // Select level from NSUserDefaults
    _defaults = [NSUserDefaults standardUserDefaults];
    globalCurrentLevel = [_defaults integerForKey: @"playLevel"];
    
    _levelsUnlocked = (NSMutableArray*) [_defaults arrayForKey:@"levelsUnlocked"];
    if (_levelsUnlocked == NULL) {
        _levelsUnlocked = (NSMutableArray*) @[
            @1, @1, @1, @1, @1, @1, @1, @1, @1, @1,
            @1, @1, @1, @1, @1, @1, @1, @1, @1, @1
        ];
    }
    
    NSLog(@"%@", _levelsUnlocked);
    
    // The stars array
    [self generateStars:globalCurrentLevel];

    // Initialize remaining time
    _totalTime = [Config calcTotalTime:[_stars count]];
    _remainingTime = _totalTime;
    _remainingTimeLabel.string = [NSString stringWithFormat:@"%d",  (int) ceil(_remainingTime)];
    
    // Initialize target number
    _targetNumber = 1;
    _targetNumberLabel.string = [NSString stringWithFormat:@"%d", _targetNumber];
    
    // Initialize score
    _score = 0;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    
    // Setup time bar
    [self setupTimeBar];
    
    // Set isGameRunning to be TRUE
    _isGameRunning = TRUE;
    
    // Display level layer
    _levelLayer = (LevelLayer*) [CCBReader load: @"LevelLayer"];
    _levelLayer.positionType = CCPositionTypeNormalized;
    _levelLayer.Position = CGPointMake(0.5F, 0.5F);
    [_nodeContainer addChild:_levelLayer];
}


- (void)generateStars:(long)playLevel {
    _stars = [[NSMutableArray alloc] init];
    _initialStarCount = 0;
    
    // Determine the number of stars
    _initialStarCount = playLevel * 5 + 2 + arc4random() % 3;
    
//    NSLog(@"Before: %d", (int) [_stars count]);     // * For debugging only
    
    for (int i = 0; i < _initialStarCount; i++) {
        _stars[i] = (Star*) [CCBReader load:@"Star"];
        
        ((Star*) _stars[i]).number.string = [NSString stringWithFormat:@"%ld", _initialStarCount - i];
        //[self addChild:_stars[i]];
        [_starFieldNoPhysics addChild:_stars[i]];
    }
    
    ((Star*)[_stars lastObject]).isTarget = TRUE;
    
//    NSLog(@"After: %d", (int) [_stars count]);      // * For debugging only
}

- (int) calcTotalTime {
    return 1.4 * [_stars count];
}

- (void) setupTimeBar {
    // Initialize time related constants
    _timePassed = 0;
    _totalTimePassed = 0;
    
    // Loade time bar
    CCSprite *timeBarSprite = [CCSprite spriteWithImageNamed:@"assets/time_bar/time_bar_top.png"];
    _timeBarNode = [CCProgressNode progressWithSprite: timeBarSprite];
    _timeBarNode.type = CCProgressNodeTypeBar;
    _timeBarNode.midpoint = ccp(0.0f, 0.0f);
    _timeBarNode.barChangeRate = ccp(1.0f, 0.0f);
    _timeBarNode.percentage = 0.0f;
    
    _timeBarNode.positionType = CCPositionTypeNormalized;
    _timeBarNode.position = ccp(0.5f, 0.5f);
    [_timeBarBase addChild: _timeBarNode];
}

- (void)startGame {
    [_nodeContainer removeChild:_levelLayer cleanup:TRUE];
    _isGameStarted = TRUE;
    _isGameRunning = TRUE;  ///?????
    [self updateBigLabel:[NSString stringWithFormat:@"%d", _targetNumber]];
}

- (void)continueGame {
    [_nodeContainer removeChild: _settingsPanel cleanup:TRUE];
    _isGameRunning = TRUE;
    _settingsButton.enabled = TRUE;
}

- (void)addScore:(int)amount {
    _score += amount;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
}

- (void)elimStar {
    [[_stars lastObject] removeFromParentAndCleanup: TRUE];
    [_stars removeLastObject];
    ((Star*)[_stars lastObject]).isTarget = TRUE;
    
    // Update target number
    _targetNumber++;
    _targetNumberLabel.string = [NSString stringWithFormat:@"%d", _targetNumber];
    
    [self updateBigLabel:[NSString stringWithFormat:@"%d", _targetNumber]];
    
    // Update score
    [self addScore:100];

    // Check if all stars are eliminated
    if ([_stars count] == 0) {
        [self win];
    }
}

- (void)win {
    _isGameFinished = TRUE;
    _isGameRunning = FALSE;
    
    CCNode *winLayer = [CCBReader load: @"WinLayer"];
    winLayer.positionType = CCPositionTypeNormalized;
    winLayer.position = CGPointMake(0.5, 0.5);
    [_nodeContainer addChild: winLayer];
}

- (void)fail {
    _isGameFinished = TRUE;
    _isGameRunning = FALSE;
    
    for (int i =0; i < [_stars count]; i++) {
        [_stars[i] removeFromParentAndCleanup: TRUE];
    }
    
    CCNode *loseLayer = [CCBReader load: @"LoseLayer"];
    loseLayer.positionType = CCPositionTypeNormalized;
    loseLayer.position = CGPointMake(0.5, 0.5);
    [_nodeContainer addChild: loseLayer];
}

- (void)reloadScene {
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GamePlayScene"] withTransition:transition];
}

- (void)reload {
    [_audio playEffect:@"pop.wav"];
    [_defaults setInteger: 1 forKey:@"isReloadGame"];
    [self reloadScene];
}

- (void)lastLevel {
    globalCurrentLevel--;
    globalCurrentLevel = MAX(globalCurrentLevel, 0);
    [_defaults setInteger:globalCurrentLevel forKey:@"playLevel"];
    [_defaults synchronize];
    
    [self reloadScene];
}

- (void)nextLevel {
    globalCurrentLevel++;
    globalCurrentLevel = MIN(globalCurrentLevel, 19);
    [_defaults setInteger:globalCurrentLevel forKey:@"playLevel"];
    
    [self reloadScene];
}


- (void)settings {
    [_audio playEffect:@"pop.wav"];
    _settingsButton.enabled = FALSE;
    _isGameRunning = FALSE;
    _settingsPanel = (SettingsPanel*) [CCBReader load: @"SettingsPanel"];
    [_nodeContainer addChild:_settingsPanel];
}

- (void)fixedUpdate:(CCTime)delta {
    if (_isGameStarted && _isGameRunning && !_isGameFinished)
    {
        _timePassed += delta;
        _remainingTime -= delta;
        
        // Update time bar
        _timeBarNode.percentage = 100 - (_remainingTime * 100.0 / _totalTime);
        
        if (_timePassed >= 1.0) {
            if (_remainingTime > _totalTime) {
                _remainingTime = _totalTime;
            }
            _timePassed = 0;
            _remainingTimeLabel.string = [NSString stringWithFormat:@"%d", (int) ceil(_remainingTime)];

            // Special Items Generation
            
            // Bomb??
            if (((float) arc4random()) / RAND_MAX < BOMB_PROB) {
                CCNode *bomb = [CCBReader load:@"Bomb"];
                [_starFieldNoPhysics addChild:bomb];
            }
            
            // Superstar??
            if (((float) arc4random()) / RAND_MAX < SUPER_STAR_PROB) {
                CCNode *superStar = [CCBReader load:@"SuperStar"];
                [_starFieldNoPhysics addChild:superStar];
            }
            
            // Shooting Star??
            if (((float) arc4random()) / RAND_MAX < SHOOTING_STAR_PROB) {
                CCNode *shootingStar = [CCBReader load:@"ShootingStar"];
                [_starFieldPhysics addChild:shootingStar];
            }
            
            
            // If run out of time:
            if (_remainingTime <= 0) {
                [self fail];
            }
        }
    }
    if (!_audio.bgPlaying) {
        int nextMusicIndex;
        
         do {
             nextMusicIndex = arc4random() % (NUMBER_OF_MUSICS);
         } while (nextMusicIndex == currentMusicIndex);
        
        [_audio playBg:MUSICS[nextMusicIndex]];
        
        currentMusicIndex = nextMusicIndex;

    }
}

- (void)syncDefaults {
    [_defaults setInteger:globalCurrentLevel forKey:@"playLevel"];
    [_defaults synchronize];
}

- (bool)isGameStartedAndRunning {
    return _isGameStarted && _isGameRunning;
}

- (void)updateBigLabel:(NSString*) content {
    _targetNumberBigLabel.string = content;
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1];
    [_targetNumberBigLabel runAction:fadeOut];
}

@end

