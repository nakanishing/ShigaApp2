//
//  DataModel.h
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/26.
//
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject <NSCoding> {
    // あえて「es」付けてます。fishで複数系って知ってます。
    NSMutableArray *fishes;
    
    // コンボ数
    int combination;
    
    // 点数
    int totalPoint;
    
    // HP
    float remainHealthPer;
    
    UITapGestureRecognizer *gestureRecognizer;
}

@property (nonatomic, retain) NSMutableArray *fishes;
@property (nonatomic, assign) int combination;
@property (nonatomic, assign) int totalPoint;

@property (nonatomic, retain) UITapGestureRecognizer *gestureRecognizer;

+ (DataModel *)getModel;

@end
