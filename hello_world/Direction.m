//
//  Direction.m
//  hello_world
//
//  Created by iclick on 12-1-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Direction.h"


@implementation Direction

@synthesize directionStr = directionStr_;
@synthesize tileStep = tileStep_;

+ (void) initialize
{
    if(!CGSizeEqualToSize(GstepSize , CGSizeMake(32, 32))){
        GstepSize = CGSizeMake(32, 32);
    }
}



- (CGSize) stepSize
{
//    CCLOG(@"gsize %f %f" , GstepSize.width , GstepSize.height);
//    CCLOG(@"xishu %f %f" , xishu_.x , xishu_.y);
    return CGSizeMake(GstepSize.width * xishu_.x, GstepSize.height * xishu_.y);
}

- (Direction *) oppositDirection
{
    if ([directionStr_ compare: @"right"] == NSOrderedSame){return [Direction sharedLeftDirection];}
    if ([directionStr_ compare: @"left"] == NSOrderedSame){return [Direction sharedRightDirection];}
    if ([directionStr_ compare: @"up"] == NSOrderedSame){return [Direction sharedDownDirection];}
    if ([directionStr_ compare: @"down"] == NSOrderedSame){return [Direction sharedUpDirection];}
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (id)initWithDirectionStr: (NSString *) directionStr
{
    [self init];
    directionStr_ = directionStr;
    if ([directionStr_ isEqualToString: @"right"] ){xishu_.x = 1 ; xishu_.y = 0;tileStep_.x = 1 ; tileStep_.y=0;};
    if ([directionStr_ isEqualToString: @"left"] ){xishu_.x = -1 ; xishu_.y = 0;tileStep_.x = -1 ; tileStep_.y=0;};
    if ([directionStr_ isEqualToString: @"down"] ){xishu_.x = 0 ; xishu_.y = -1;tileStep_.x = 0 ; tileStep_.y=1;};
    if ([directionStr_ isEqualToString: @"up"] ){xishu_.x = 0 ; xishu_.y = 1;tileStep_.x = 0 ; tileStep_.y=-1;};
    return [self autorelease];    
}


+ (Direction *) sharedLeftDirection
{
    return [[[Direction alloc] initWithDirectionStr:@"left"] retain];
}

+ (Direction *) sharedRightDirection
{
    return [[[Direction alloc] initWithDirectionStr:@"right"] retain];
}

+ (Direction *) sharedUpDirection
{
    return [[[Direction alloc] initWithDirectionStr:@"up"] retain];
}

+ (Direction *) sharedDownDirection
{
    return [[[Direction alloc] initWithDirectionStr:@"down"] retain];
}


@end
