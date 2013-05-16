//
//  BaseAttributes.m
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/13.
//
//

#import "BaseAttributes.h"

@implementation BaseAttributes

@synthesize totalHealth;
@synthesize baseBlackbassHealth;
@synthesize baseBluegillHealth;

@synthesize blackbassPoint;
@synthesize bluegillPoint;

@synthesize blackpassAtkPoint;
@synthesize bluegillAtkPoint;

@synthesize fontName;

static BaseAttributes *_sharedAttributes = nil;

+ (BaseAttributes *)sharedAttributes {
    @synchronized([BaseAttributes class]) {
        if (!_sharedAttributes) {
            [[self alloc] init];
        }
        
        return _sharedAttributes;
    }
}

+ (id)alloc {
    @synchronized([BaseAttributes class]) {
        _sharedAttributes = [super alloc];
        
        return _sharedAttributes;
    }
}

- (id)init {
    if ((self = [super init])) {
        totalHealth = 200;
        baseBlackbassHealth = 200;
        baseBluegillHealth = 100;
        
        blackbassPoint = 100;
        bluegillPoint = 50;
        
        blackpassAtkPoint = 5.0;
        bluegillAtkPoint = 2.0;
        
        fontName = @"STHeitiSC-Medium";
    }
    
    return self;
}

@end
