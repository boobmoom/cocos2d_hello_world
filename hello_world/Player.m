//
//  Player.m
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize sprite = sprite_;

+ (id) alloc
{
    return [super alloc];
}

- (BOOL) walking
{
    return walking_;
}


- (id) init
{
    if(self = [super  init]){
        animations = [[NSMutableDictionary alloc] init];
        [self setSprite: [CCSprite spriteWithFile: @"sprite.png" rect:CGRectMake(0, 0, 32, 48)]];
        [[self sprite] setScale:0.65];
        [self setWalkAnimation]; 
        step_distance = 32;
        walking_ = NO;
    }
    return self;
}

- (void) setWalkAnimation
{
// TODO refactor   
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"sprite.png"];
    CCAnimation *walk_right_animation = [CCAnimation animation];
    int i; 
    for( i = 3 ; i >= 0 ; i--){
        [walk_right_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 96, 32, 48)];
    }
    [animations setValue:walk_right_animation forKey: @"right"];
    CCAnimation *walk_left_animation = [CCAnimation animation];
    for( i = 3 ; i >= 0 ; i--){
        [walk_left_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 48, 32, 48)];
    }
    [animations setValue:walk_left_animation forKey: @"left"];
    CCAnimation *walk_up_animation = [CCAnimation animation];
    for( i = 3 ; i >= 0 ; i--){
        [walk_up_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 144, 32, 48)];
    }
    [animations setValue:walk_up_animation forKey: @"up"];
    CCAnimation *walk_down_animation = [CCAnimation animation];
    for( i = 3 ; i >= 0 ; i--){
        [walk_down_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 0, 32, 48)];
    }
    [animations setValue:walk_down_animation forKey: @"down"];
}

- (void) walk: (NSString *) direction
{
    if (walking_) {
        return;
    }
    walking_ = YES;
    CCAnimation *animation;
    animation = [animations valueForKey: direction];
    NSAssert( animation!=nil, @"Animate: argument Animation must be non-nil");
    [[self sprite] runAction:[CCAnimate actionWithDuration:0.3 animation: animation restoreOriginalFrame:NO]];
    CCMoveBy *moveAction;
    if(direction == @"down")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, -step_distance)] ;
    if(direction == @"up")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, step_distance)] ;
    if(direction == @"left")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(-step_distance , 0.0)] ;
    if(direction == @"right")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(step_distance , 0.0)] ;
    [[self sprite] runAction: [CCSequence actions:moveAction ,[CCCallFuncN actionWithTarget: self selector:@selector(walkFinished)] , nil]];
}

- (void) walkFinished
{
    walking_ = NO;
}


- (void) dealloc
{
    [animations dealloc];
    [super dealloc];
}

@end
