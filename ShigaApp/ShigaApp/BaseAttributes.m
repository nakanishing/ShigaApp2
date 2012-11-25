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

static BaseAttributes *sharedAttributes = nil;

+ (BaseAttributes *)sharedAttributes {
    @synchronized([BaseAttributes class]) {
        if (!sharedAttributes) {
            [[self alloc] init];
        }
        
        return sharedAttributes;
    }
}

+ (id)alloc {
    @synchronized([BaseAttributes class]) {
        sharedAttributes = [super alloc];
        
        return sharedAttributes;
    }
}

- (id)init {
    if ((self = [super init])) {
        totalHealth = 200;
        baseBlackbassHealth = 200;
        baseBluegillHealth = 100;
        
        blackbassPoint = 100;
        bluegillPoint = 50;
    }
    
    return self;
}

@end
