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
    
}

@property(nonatomic, assign) int totalHealth;
@property(nonatomic, assign) int baseBlackbassHealth;
@property(nonatomic, assign) int baseBluegillHealth;

@property(nonatomic, assign) int blackbassPoint;
@property(nonatomic, assign) int bluegillPoint;

+ (BaseAttributes *)sharedAttributes;

@end
