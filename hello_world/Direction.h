//
//  Direction.h
//  hello_world
//
//  Created by iclick on 12-1-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
static CGSize GstepSize;
typedef struct{
    float x;
    float y;
} XiShu;



//只有四个实例，预先初始化好
@interface Direction : NSObject
{
    NSString *directionStr_;
    XiShu xishu_;
    XiShu tileStep_;
}

@property (readonly , nonatomic) CGSize stepSize;
@property (readonly , nonatomic) NSString * directionStr;
@property (readonly , nonatomic) XiShu tileStep;

//- (BOOL) sameDirection: (Direction *) direction;

- (Direction *) oppositDirection;

- (id)initWithDirectionStr: (NSString *) directionStr;

+ (Direction *) sharedLeftDirection;

+ (Direction *) sharedRightDirection;

+ (Direction *) sharedUpDirection;

+ (Direction *) sharedDownDirection;

@end

