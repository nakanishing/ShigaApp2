//
//  BaseAttributes.h
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/13.
//
//

#import <Foundation/Foundation.h>

@interface BaseAttributes : NSObject {
    
    int totalHealth;
    int baseBlackbassHealth;
    int baseBluegillHealth;
    
    int blackbassPoint;
    int bluegillPoint;
    
    float blackbassAtkPoint;
    float bluegillAtkPoint;
    
    NSString *fontName;
}

@property(nonatomic, assign) int totalHealth;
@property(nonatomic, assign) int baseBlackbassHealth;
@property(nonatomic, assign) int baseBluegillHealth;

@property(nonatomic, assign) int blackbassPoint;
@property(nonatomic, assign) int bluegillPoint;

@property(nonatomic, assign) float blackpassAtkPoint;
@property(nonatomic, assign) float bluegillAtkPoint;

@property(nonatomic, assign) NSString *fontName;

+ (BaseAttributes *)sharedAttributes;

@end
