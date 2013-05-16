//
//  ForeignFish.m
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/09.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ForeignFish.h"
#import "BaseAttributes.h"


@implementation ForeignFish

@synthesize curHp;
@synthesize totalHp;
@synthesize lastWaypoint;
@synthesize healthBar;
@synthesize availablePoints;
@synthesize atkPoint;

- (void)healthBarLogic:(ccTime)dt {
    healthBar.position = ccp(self.position.x, (self.position.y + 20));
    healthBar.percentage = ((float)self.curHp / (float)self.totalHp) * 100;
    if(healthBar.percentage <=0) {
        [self removeChild:healthBar cleanup:YES];
    }
}

- (void)dealloc {
    [healthBar release];
    healthBar = nil;
    
    [super dealloc];
}

@end

@implementation Blackbass

- (id)init {
    if ((self = [super init])) {
        CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"fish1.png"];
        [self addChild:batch];
    }
    
    return self;
}

+ (id)fish {
    Blackbass *fish = nil;
    if ((fish = [[[super alloc] initWithFile:@"fish1.png"] autorelease])) {
        BaseAttributes *attributes = [BaseAttributes sharedAttributes];
        fish.curHp = attributes.totalHealth;
        fish.totalHp = attributes.totalHealth;
        fish.availablePoints = attributes.blackbassPoint;
        fish.atkPoint = attributes.blackpassAtkPoint;
    }
    [fish schedule:@selector(healthBarLogic:)];
    
    return fish;
}

@end

@implementation Bluegill

+ (id)fish {
    Bluegill *fish = nil;
    if ((fish = [[[super alloc] initWithFile:@"fish2.png"] autorelease])) {
        BaseAttributes *attributes = [BaseAttributes sharedAttributes];
        fish.curHp = attributes.totalHealth;
        fish.totalHp = attributes.totalHealth;
        fish.availablePoints = attributes.bluegillPoint;
        fish.atkPoint = attributes.bluegillAtkPoint;
    }
    [fish schedule:@selector(healthBarLogic:)];
    
    return fish;
}

@end