//
//  MainLayer.h
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainLayer : CCLayer {
    CCTMXTiledMap *tilemap;
    CCTMXLayer *background;
    
    // 琵琶湖のフレーム（湖岸）
    NSMutableArray *frames;
    
    // 外来魚が向かうポイント
    NSMutableArray *waypoints;
    
    // 外来魚が発生するポイント
    NSMutableArray *bornpoints;
}

@property(nonatomic, retain) CCTMXTiledMap *tilemap;
@property(nonatomic, retain) CCTMXLayer *background;

+(CCScene *) scene;

@end
