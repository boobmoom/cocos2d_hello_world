//
//  Controller.m
//  hello_world
//
//  Created by iclick on 12-1-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"

@implementation Controller

@synthesize layer = _layer;
@synthesize gameLayer = gameLayer_;

- (id)init
{
    self = [super init];
    if (self) {
        [self initLayer];
    }
    
    return self;
}

- (id) initWithGameLayer: (XminLayer *) layer
{
    if([self init])
    {
        [self setGameLayer:layer];
        return self;
    }
    return nil;
}

+ (id) controlWithGameLayer: (XminLayer *) layer
{
    return [[[self alloc] initWithGameLayer:layer] autorelease];
}

-(void) initLayer
{
    // down arrow
    CCSprite *down_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *down_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *downItem = [CCMenuItemSprite itemFromNormalSprite: down_button selectedSprite:down_button_selected target: self selector: @selector(walkDown)];
    downItem.position = CGPointMake(40 + 20, 20);
    // left arrow
    CCSprite *left_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *left_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *leftItem = [CCMenuItemSprite itemFromNormalSprite: left_button selectedSprite:left_button_selected  target: self selector: @selector(walkLeft)];
    leftItem.rotation = 90;
    leftItem.position = CGPointMake(20 , 40+20);
    //right arrow
    CCSprite *right_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *right_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *rightItem = [CCMenuItemSprite itemFromNormalSprite: right_button selectedSprite:right_button_selected target: self selector: @selector(walkRight)];
    rightItem.rotation = -90;
    rightItem.position = CGPointMake(80 + 20, 40+20);
    //up arrow
    CCSprite *up_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *up_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *upItem = [CCMenuItemSprite itemFromNormalSprite: up_button selectedSprite:up_button_selected target: self selector: @selector(walkUp)];
    upItem.rotation = 180;
    upItem.position = CGPointMake(40+20, 80+20);
    
    CCMenu *control_layer = [CCMenu menuWithItems: downItem , rightItem , leftItem , upItem ,nil];
    
    control_layer.contentSize = CGSizeMake(120, 120);
    CGSize win_size = [[CCDirector sharedDirector] winSize];
    control_layer.position = CGPointMake(win_size.width - 120 ,0);
    control_layer.scale = 0.6;
    [self setLayer:control_layer];
}



-(void) walkDown
{
    [self command: @"down"];
}

-(void) walkUp
{
    [self command: @"up"];    
}

- (void) walkLeft
{
    [self command: @"left"];    
}

- (void) walkRight
{
    [self command: @"right"];    
}

- (void) command: (NSString *) direction
{
    if([gameLayer_ lastCommandExecuting]){return;}
    BOOL check = [gameLayer_ playerMoveAble: direction] ;
    if (check) {
        [gameLayer_ playerMove: direction];       
    }else if ([gameLayer_ playerPushAble: direction]){
        [gameLayer_ playerPush: direction];
    }    
}



-(void) dealloc
{
    [super dealloc];
}

@end
