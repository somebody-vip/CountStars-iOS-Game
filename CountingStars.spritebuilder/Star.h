//
//  Star.h
//  CountingStars
//
//  Created by xxx on 6/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Star : CCSprite

@property (nonatomic, assign) BOOL isTarget;
@property (nonatomic, strong) CCSprite *shape;
@property (nonatomic, strong) CCLabelTTF *number;

@end
