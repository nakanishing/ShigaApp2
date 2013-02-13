//
//  MainLayer.m
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainLayer.h"
#import "ForeignFish.h"
#import "DataModel.h"

@implementation MainLayer

@synthesize tilemap;
@synthesize background;

// タップされた魚
NSMutableArray *touchedFish;
int tempcombo = 0;

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
        
        self.isTouchEnabled = YES;
        
        // 座標系の設定
        frames = [[tilemap objectGroupNamed:@"frames"] objects];
        waypoints = [[tilemap objectGroupNamed:@"waypoints"] objects];
        bornpoints = [[tilemap objectGroupNamed:@"bornpoints"] objects];
        
        // 初期化
        [[DataModel alloc] init];
        
        tempcombo = 0;
        
        [self scheduleUpdate];
        
        // 何秒間隔で外来魚（敵）を発生させるか。
        // この間隔が狭いほどゲームの難易度があがるので、レベルによってintervalを変更するのがbest。
        [self schedule:@selector(addFish) interval:1.0];
        
        touchedFish = [[NSMutableArray alloc] init];
        cmbLabel = [[CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:32] retain];
        cmbLabel.color = ccc3(0, 0, 0);
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        NSLog(@"width: %f, height: %f", winSize.width, winSize.height);
        cmbLabel.position = ccp(winSize.width / 6, winSize.height / 6);
        [self addChild:cmbLabel z:5];
    }

    return self;
}

/**
 * ゲーム進行中の処理を行う.
 * このメソッドは毎フレーム呼ばれる（60frame/secの場合は60回/秒）
 */
- (void)update:(ccTime)dt {
    DataModel *m = [DataModel getModel];
    
    // 琵琶湖に到達した魚。
    NSMutableArray *reachedFish = [[NSMutableArray alloc] init];
    
    // 外来魚が琵琶湖の枠(frame)に当たったか判定する
    for (CCSprite *fish in [m fishes]) {
        CGRect fishRect = CGRectMake(fish.position.x - (fish.contentSize.width / 2),
                                       fish.position.y - (fish.contentSize.height / 2),
                                       fish.contentSize.width / 2,
                                       fish.contentSize.height / 2);
        
        for (NSDictionary *frame in frames) {
            int frameX = [[frame valueForKey:@"x"] intValue];
            int frameY = [[frame valueForKey:@"y"] intValue];
            CGRect frameRect = CGRectMake(frameX, frameY, 1, 1);
            
            if (CGRectIntersectsRect(fishRect, frameRect)) {// 敵が琵琶湖に侵入した場合の処理をここに書いていく
                [reachedFish addObject:fish];
                
                // コンボ数を初期値に戻す
                m.combination = 0;
                cmbLabel.opacity = 0x00;
            }
        }
    }
    
    // 侵入した魚を消す（TODO 徐々に小さく、透明にしていく）
    for (CCSprite *fish in reachedFish) {
        [m.fishes removeObject:fish];
        [self removeChild:fish cleanup:YES];
    }
    
    // タップされた魚を消す（TODO 潰れる画像に差し替え）
    for (CCSprite *fish in touchedFish) {
        [m.fishes removeObject:fish];
        [self removeChild:fish cleanup:YES];
    }
    
    if (tempcombo != m.combination) {
        tempcombo = m.combination;
        if (m.combination > 1) {
            cmbLabel.opacity = 0xFF;
            [cmbLabel setString:[NSString stringWithFormat:@"%icombo", m.combination]];

        }
        
    }
    [reachedFish release];

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
    
    //TODO durationはレベルによって変更させる
    id actionMove = [CCMoveTo actionWithDuration:10.0f position:ccp(waypointX, waypointY)];
    [fish runAction:[CCEaseOut actionWithAction:actionMove rate:3]];
    
    [self addChild:fish z:10];
    
    DataModel *m = [DataModel getModel];
    [m.fishes addObject:fish];
}

  /**
   * 魚をタップしたときの判定を行う。
   * タップされたものを配列にまとめて、updateメソッド内で画面から削除する。
   */
- (void)handlePanFrom:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        
        // 魚をタップできたかの判定。
        DataModel *m = [DataModel getModel];
        for (CCSprite *fish in [m fishes]) {
            CGRect fishRect = CGRectMake(fish.position.x - (fish.contentSize.width / 2),
                                         fish.position.y - (fish.contentSize.height / 2),
                                         fish.contentSize.width * 0.8,
                                         fish.contentSize.height * 0.8);
            
            CGRect touchRect = CGRectMake(touchLocation.x, touchLocation.y, 10, 10);
            if (CGRectIntersectsRect(fishRect, touchRect)) {
                m.combination += 1;
                [touchedFish addObject:fish];
            }
        }
    }
}

- (void)dealloc {
    [tilemap release];
    tilemap = nil;
    
    [background release];
    background = nil;
    
    [touchedFish release];
    touchedFish = nil;
    
    [super dealloc];
}

@end
