//
//  MainLayer.m
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainLayer.h"
#import "ForeignFish.h"


@implementation MainLayer

@synthesize tilemap;
@synthesize background;


+ (CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:1];
	
    
	// return the scene
	return scene;
}

- (id)init {
    if((self=[super init])) {
        tilemap = [CCTMXTiledMap tiledMapWithTMXFile:@"biwako.tmx"];
        background = [tilemap layerNamed:@"background"];
        [self addChild:tilemap z:0];
        
        // 座標系の設定
        frames = [[[tilemap objectGroupNamed:@"frames"] objects] autorelease];
        waypoints = [[[tilemap objectGroupNamed:@"waypoints"] objects] autorelease];
        bornpoints = [[[tilemap objectGroupNamed:@"bornpoints"] objects] autorelease];
        
        [self scheduleUpdate];
        [self addFish];
        //[self schedule:@selector(<#selector#>) interval:<#(ccTime)#>]
    }

    return self;
}

- (void)update:(ccTime)dt {
    
}

- (void)addFish {
    // 発生ポイントをランダムで決定する
    int bornPointIndex = arc4random() % ([bornpoints count] - 1);
    int bornX = [[[bornpoints objectAtIndex:bornPointIndex] valueForKey:@"x"] intValue];
    int bornY = [[[bornpoints objectAtIndex:bornPointIndex] valueForKey:@"y"] intValue];
    
    int waypointIndex = arc4random() % ([waypoints count] - 1);
    int waypointX = [[[waypoints objectAtIndex:waypointIndex] valueForKey:@"x"] intValue];
    int waypointY = [[[waypoints objectAtIndex:waypointIndex] valueForKey:@"y"] intValue];
    
    CCSprite *fish = [Blackbass fish];
    fish.position = ccp(bornX, bornY);
    
    id actionMove = [CCMoveTo actionWithDuration:2.5f position:ccp(waypointX, waypointY)];
    [fish runAction:[CCEaseOut actionWithAction:actionMove rate:2]];
    
    [self addChild:fish z:10];
}

- (void)dealloc {
    [tilemap release];
    tilemap = nil;
    
    [background release];
    background = nil;
    
    [super dealloc];
}

@end
