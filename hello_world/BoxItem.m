//
//  BoxItem.m
//  hello_world
//
//  Created by iclick on 12-1-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BoxItem.h"

@implementation BoxItem

@synthesize sprite = sprite_;

- (id)init
{
    self = [super init];
    if (self) {
        sprite_ = [CCSprite spriteWithFile:@"tmw_desert_spacing.png" rect:CGRectMake(6*32 + 7, 3*32 + 4, 32, 32)];
        [sprite_ retain];
    }
    return self;
}

+ (id)initializeWithPosition:(CGPoint)position
{
    return [[[self alloc] initializeWithPosition: position] autorelease];
}

- (id) initializeWithPosition: (CGPoint) position
{
    [self init];
    sprite_.position = position;
    return self;
}

- (void) move:(Direction *)direction withTarget:(XminLayer *) gameLayer
{
    CCMoveBy *moveAction;
    moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(direction.stepSize.width, direction.stepSize.height)] ;
    CCCallFuncN *setBoxOpacity;
    CCCallFunc *checkWin ;
    //TODO 关联到XminLayer
    checkWin = [CCCallFunc actionWithTarget:gameLayer selector:@selector(checkWin)];
    setBoxOpacity = [CCCallFuncN actionWithTarget:gameLayer selector:@selector(setBoxOpacity:)];
    [sprite_ runAction: [CCSequence actions: moveAction, setBoxOpacity , checkWin , nil]];
}

- (CGPoint) position
{
    return sprite_.position;
}

- (void) dealloc
{
    [sprite_ release];
    [super dealloc];
}

@end
