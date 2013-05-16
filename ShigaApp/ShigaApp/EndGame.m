//
//  EndGame.m
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2013/05/15.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EndGame.h"
#import "BaseAttributes.h"
#import "DataModel.h"


@implementation EndGame

- (id)init
{
    if ((self = [super initWithColor:ccc4(150, 50, 50, 255)])) {
        self.isTouchEnabled = YES;
        DataModel *m = [DataModel getModel];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        BaseAttributes *attributes = [BaseAttributes sharedAttributes];
        
        CCLabelTTF *pointLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", m.totalPoint] dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:attributes.fontName fontSize:30];
        pointLabel.position = ccp((winSize.width / 2 - 150), (winSize.height / 2 + 50));
        pointLabel.color = ccc3(255, 80, 20);
        [self addChild:pointLabel z:1];
        
        
        CCLabelTTF *cmbLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", m.combination] dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:attributes.fontName fontSize:30];
        cmbLabel.position = ccp((winSize.width / 2 - 150), (winSize.height / 2 + 25));
        cmbLabel.color = ccc3(255, 80, 20);
        [self addChild:cmbLabel z:1];
        
        
        CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"Restart?" dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:attributes.fontName fontSize:30];
        restartLabel.position = ccp((winSize.width / 2 - 150), (winSize.height / 2));
        restartLabel.color = ccc3(255, 80, 20);
        [self addChild:restartLabel z:1];
        
        CCLabelTTF *menuLabel = [CCLabelTTF labelWithString:@"Menu" dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:attributes.fontName fontSize:30];
        menuLabel.position = ccp((winSize.width / 2 - 150), (winSize.height / 2 - 50));
        menuLabel.color = ccc3(255, 80, 20);
        [self addChild:menuLabel z:1];

    }
    return self;
}

@end
