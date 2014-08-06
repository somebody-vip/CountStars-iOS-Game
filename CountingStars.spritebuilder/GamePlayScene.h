//
//  GamePlayScene.h
//  CountingStars
//
//  Created by xxx on 6/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GamePlayScene : CCNode

@property (nonatomic, assign) BOOL isGameStarted;
@property (nonatomic, assign) BOOL isGameRunning;
@property (nonatomic, assign) BOOL isGameFinished;
//@property (nonatomic, assign) long playLevel;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSMutableArray *levelsUnlocked;
@property (nonatomic, assign) long initialStarCount;
@property (nonatomic, assign) float remainingTime;

- (void)startGame;
- (void)continueGame;
- (void)addScore:(int)amount;
- (void)elimStar;
- (void)fail;
- (void)lastLevel;
- (void)nextLevel;
- (bool)isGameStartedAndRunning;
- (void)updateBigLabel:(NSString*) content;

@end
