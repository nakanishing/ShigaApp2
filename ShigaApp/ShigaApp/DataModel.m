//
//  DataModel.m
//  ShigaApp
//
//  Created by Nakanishi Toshiaki on 2012/11/26.
//
//

#import "DataModel.h"

@implementation DataModel

@synthesize fishes;
@synthesize combination;
@synthesize totalPoint;

@synthesize gestureRecognizer;

static DataModel *sharedContext = nil;

+ (DataModel *)getModel {
    if (!sharedContext) {
        sharedContext = [[self alloc] init];
    }
    
    return sharedContext;
}

- (id)init {
    self = [super init];
    if (self) {
        fishes = [[NSMutableArray alloc] init];
        combination = 0;
        totalPoint = 0;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // Objectを保存する処理.
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // シリアライズしたObjectを復元する処理.
    return self;
}

- (void)dealloc {
    self.gestureRecognizer = nil;
    
    [fishes release];
    fishes = nil;
    
    [super dealloc];
}

@end
