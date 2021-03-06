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
    
    CCSprite *cacelButtonSprite = [CCSprite spriteWithFile:@"cancel.png"];
    CCSprite *cacelButtonSpritePressed = [CCSprite spriteWithFile:@"cancel.png"];
    CCMenuItemSprite *cacelMenuItem = [CCMenuItemSprite itemFromNormalSprite: cacelButtonSprite selectedSprite:cacelButtonSpritePressed target: self selector: @selector(cancelStep)];
    cacelMenuItem.position = CGPointMake(50, 140);
    cacelMenuItem.scale = 0.6;
    CCLabelTTF *cancelItemLabel = [CCLabelTTF labelWithString:@"悔步" fontName:@"Marker Felt" fontSize:40];
    CGSize c_s = cacelMenuItem.contentSize;
    cancelItemLabel.position = ccp(c_s.width/2 , c_s.height/2);
    [cacelMenuItem addChild:cancelItemLabel z:100];
    

    
    
    CCMenu *control_layer = [CCMenu menuWithItems: downItem , rightItem , leftItem , upItem , cacelMenuItem ,nil];
    
    control_layer.contentSize = CGSizeMake(200 , 200);
    CGSize win_size = [[CCDirector sharedDirector] winSize];
    control_layer.position = CGPointMake(win_size.width - 120 ,0);
    control_layer.scale = 0.6;
    [self setLayer:control_layer];
}


-(void) cancelStep
{
    if ([gameLayer_ lastCommandExecuting]) return;
    if ([[gameLayer_ lastSteps] objectAtIndex:0] == @"nil") return;
    [gameLayer_ cancelStep];
}


-(void) walkDown
{
    [self command: [Direction sharedDownDirection]];
}

-(void) walkUp
{
    [self command: [Direction sharedUpDirection]];    
}

- (void) walkLeft
{
    [self command: [Direction sharedLeftDirection]];    
}

- (void) walkRight
{
    [self command: [Direction sharedRightDirection]];    
}

- (void) command: (Direction *) direction
{
    if([gameLayer_ lastCommandExecuting]){return;}
    BOOL check = [gameLayer_ playerMoveAble: direction] ;
    if (check) {
        CCLOG(@"player MOVE");
        [gameLayer_ playerMove: direction];       
    }else if ([gameLayer_ playerPushAble: direction]){
        CCLOG(@"player PUSH");
        [gameLayer_ playerPush: direction];
    }    
}



-(void) dealloc
{
    [super dealloc];
}

@end
