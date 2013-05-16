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
#import "EndGame.h"

@implementation MainLayer

@synthesize tilemap;
@synthesize background;

// タップされた魚
NSMutableArray *touchedFish;
int tempcombo = 0;
bool barChange = NO;
bool runEndAnimation = NO;

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
        
        baseAttributes = [BaseAttributes sharedAttributes];

        tempcombo = 0;
        
        [self scheduleUpdate];
        
        // 何秒間隔で外来魚（敵）を発生させるか。
        // この間隔が狭いほどゲームの難易度があがるので、レベルによってintervalを変更するのがbest。
        [self schedule:@selector(addFish) interval:0.5];
        
        touchedFish = [[NSMutableArray alloc] init];
        cmbLabel = [[CCLabelTTF labelWithString:@"" fontName:baseAttributes.fontName fontSize:32] retain];
        cmbLabel.color = ccc3(30, 30, 30);
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        cmbLabel.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:cmbLabel z:5];
        
        // 点数表示
        totalPointLabel = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%010d", 0] fontName:baseAttributes.fontName fontSize:30] retain];
        totalPointLabel.color = ccc3(30, 30, 30);
        totalPointLabel.position = ccp(winSize.width - totalPointLabel.contentSize.width / 1.8, winSize.height - 15);
        [self addChild:totalPointLabel z:6];
        
        // HP
        healthBar = [CCProgressTimer progressWithFile:@"health_bar_green.png"];
        healthBar.type = kCCProgressTimerTypeHorizontalBarLR;
        healthBar.percentage = baseHpPercentage;
        healthBar.scale = 0.9;
        healthBar.position = ccp(healthBar.contentSize.width / 2, winSize.height - 15);
        [self addChild:healthBar z:7];
        
        baseHpPercentage = 100;
        [healthBar setPercentage:baseHpPercentage];
    }

    return self;
}

/**
 * ゲーム進行中の処理を行う.
 * このメソッドは毎フレーム呼ばれる（60frame/secの場合は60回/秒）
 */
- (void)update:(ccTime)dt {
    DataModel *m = [DataModel getModel];
    
    
    // TODO 一箇所で定義する
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // 琵琶湖に到達した魚。
    NSMutableArray *reachedFish = [[NSMutableArray alloc] init];
    
    // 外来魚が琵琶湖の枠(frame)に当たったか判定する
    for (ForeignFish *fish in [m fishes]) {
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
                
                // HPを減らす
                float prePercentage = baseHpPercentage;
                baseHpPercentage -= fish.atkPoint;
                
                // 終了
                if (baseHpPercentage <= 0 && runEndAnimation == NO) {
                    runEndAnimation = YES;
                    //CCLayer *endGameLayer = [[EndGame alloc] init];
                    
                    CCSprite *endGameLayer = [CCSprite spriteWithFile:@"endSprite.png"];
                    endGameLayer.position = ccp(winSize.width + 100, winSize.height / 2);
                    id actionMove = [CCMoveTo actionWithDuration:1.0 position:ccp(winSize.width / 2, winSize.height / 2)];
                    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(pauseGame)];
                    [endGameLayer runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
                    
                    [self addChild:endGameLayer z:1000];
                    
                    return;
                }
                
                // HPが残り20%以下になったらバーを赤く
                if (baseHpPercentage < 20 && barChange == NO) {
                    [healthBar setSprite:[CCSprite spriteWithFile:@"health_bar_red.png"]];
                    barChange = YES;
                }
                
                [healthBar setPercentage:baseHpPercentage];
                CCProgressFromTo *to = [CCProgressFromTo actionWithDuration:0.3f from:prePercentage to:baseHpPercentage];
                [healthBar runAction:to];
            }
        }
    }
    
    // 侵入した魚を消す（TODO 徐々に小さく、透明にしていく）
    for (ForeignFish *fish in reachedFish) {
        [m.fishes removeObject:fish];
        [self removeChild:fish cleanup:YES];
    }
    
    // タップされた魚を消す（TODO 潰れる画像に差し替え）
    for (ForeignFish *fish in touchedFish) {
        [m.fishes removeObject:fish];
        [self removeChild:fish cleanup:YES];
        
    }
    
    // コンボ数表示
    if (tempcombo != m.combination) {
        tempcombo = m.combination;
        if (m.combination > 1) {
            cmbLabel.opacity = 0xFF;
            [cmbLabel setString:[NSString stringWithFormat:@"%icombo", m.combination]];

        }
    }
    
    // 得点
    [totalPointLabel setString:[NSString stringWithFormat:@"%010d", m.totalPoint]];
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
    
    ForeignFish *fish = [Blackbass fish];
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
        for (ForeignFish *fish in [m fishes]) {
            CGRect fishRect = CGRectMake(fish.position.x - (fish.contentSize.width / 2),
                                         fish.position.y - (fish.contentSize.height / 2),
                                         fish.contentSize.width * 0.8,
                                         fish.contentSize.height * 0.8);
            
            CGRect touchRect = CGRectMake(touchLocation.x, touchLocation.y, 10, 10);
            
            // 魚がタップされたときの処理を以下にまとめる
            if (CGRectIntersectsRect(fishRect, touchRect)) {
                m.combination += 1;
                m.totalPoint += [self calcPoints:fish];

                [touchedFish addObject:fish];
            }
        }
    }
}

/**
 * 点数を計算する
 */
- (int)calcPoints:(ForeignFish *)fish {
    DataModel *m = [DataModel getModel];
    int fishPoints = [fish availablePoints];
    
    int bonusPoints = 0;
    if (10 <= m.combination && m.combination < 20) {
        bonusPoints = m.combination * 2;
    } else if (20 <= m.combination && m.combination < 30) {
        bonusPoints = m.combination * 3;
    } else if (30 <= m.combination && m.combination < 40) {
        bonusPoints = m.combination * 5;
    } else if (40 <= m.combination && m.combination < 50) {
        bonusPoints = m.combination * 8;
    } else if (50 <= m.combination && m.combination < 100) {
        bonusPoints = m.combination * 10;
    } else if (100 <= m.combination && m.combination < 200) {
        bonusPoints = m.combination * 20;
    } else if (200 <= m.combination) {
        bonusPoints = m.combination * 50;
    }
        
    return fishPoints + bonusPoints;
}

- (void)pauseGame {
    CCLayerColor *endGameLayer = [[[EndGame alloc] init] autorelease];
    [self.parent addChild:endGameLayer z:10];
    [[CCDirector sharedDirector] pause];
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
