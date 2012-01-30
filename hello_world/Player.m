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
        backAnimations_ = [[NSMutableDictionary alloc] init];
        [self setSprite: [CCSprite spriteWithFile: @"sprite.png" rect:CGRectMake(0, 0, 32, 48)]];
        [[self sprite] setScale:0.65];
        [self setWalkAnimation]; 
        [self setBackAnimation];
        step_distance = 32;
        walking_ = NO;
    }
    return self;
}

- (void) setBackAnimation
{
    // TODO refactor   
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"sprite.png"];
    CCAnimation *walk_right_animation = [CCAnimation animation];
    int i; 
    for( i = 3 ; i >= 0 ; i--){
        [walk_right_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 96, 32, 48)];
    }
    [backAnimations_ setValue:walk_right_animation forKey: @"left"];
    CCAnimation *walk_left_animation = [CCAnimation animation];
    for( i = 3 ; i >= 0 ; i--){
        [walk_left_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 48, 32, 48)];
    }
    [backAnimations_ setValue:walk_left_animation forKey: @"right"];
    CCAnimation *walk_up_animation = [CCAnimation animation];
    for( i = 3 ; i >= 0 ; i--){
        [walk_up_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 144, 32, 48)];
    }
    [backAnimations_ setValue:walk_up_animation forKey: @"down"];
    CCAnimation *walk_down_animation = [CCAnimation animation];
    for( i = 3 ; i >= 0 ; i--){
        [walk_down_animation addFrameWithTexture:texture rect:CGRectMake( 32 * i , 0, 32, 48)];
    }
    [backAnimations_ setValue:walk_down_animation forKey: @"up"];
 
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

- (void) walk: (Direction *) direction
{
    [self walk:direction back:NO];
}

- (void) walk: (Direction *) direction back: (BOOL) back
{
    if (walking_) {
        return;
    }
    walking_ = YES;
    CCAnimation *animation;
    if(back){
        animation = [backAnimations_ valueForKey: direction.directionStr];
    }else{
        animation = [animations valueForKey: direction.directionStr];
    }
    NSAssert( animation!=nil, @"Animate: argument Animation must be non-nil");
    [[self sprite] runAction:[CCAnimate actionWithDuration:0.3 animation: animation restoreOriginalFrame:NO] ];
    CCMoveBy *moveAction;
    CCLOG(@"walk %f %f" , direction.stepSize.width , direction.stepSize.height);
    moveAction = [CCMoveBy actionWithDuration:0.3 position: ccp(direction.stepSize.width , direction.stepSize.height)] ;
    [[self sprite] runAction: [CCSequence actions:moveAction ,[CCCallFuncN actionWithTarget: self selector:@selector(walkFinished)] , nil]]; 
}

- (void) walkFinished
{
    walking_ = NO;
}


- (void) dealloc
{
    [backAnimations_ dealloc];
    [animations dealloc];
    [super dealloc];
}

@end
