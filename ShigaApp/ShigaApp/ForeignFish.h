//
//  ForeignFish.h
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/09.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ForeignFish : CCSprite {
    int curHp;
    int totalHp;
    int lastWaypoint;
    int availablePoints;
    
    CCProgressTimer *healthBar;
}

@property (nonatomic) int curHp;
@property (nonatomic) int totalHp;
@property (nonatomic) int lastWaypoint;
@property (nonatomic) int availablePoints;

@property (nonatomic, retain) CCProgressTimer *healthBar;

@end

@interface Blackbass : ForeignFish {
}
+ (id)fish;
@end

@interface Bluegill : ForeignFish {
}
+ (id)fish;
@end