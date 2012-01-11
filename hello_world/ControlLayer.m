//
//  ControlLayer.m
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ControlLayer.h"


@implementation ControlLayer

- (id) init
{
    if(self = [super initWithColor:ccc4(255,255,255,255)]){
        self.isTouchEnabled = YES;
        self.contentSize = CGSizeMake(120, 120);
        CGSize win_size = [[CCDirector sharedDirector] winSize];
        self.position = CGPointMake(win_size.width - 120 ,0);
        CCSprite *down_button = [CCSprite spriteWithFile:@"down.png"];
        down_button.position = CGPointMake(40 + 20, 20);
        CCSprite *left_button = [CCSprite spriteWithFile:@"down.png"];
        left_button.rotation = 90;
        left_button.position = CGPointMake(20 , 40+20);
        CCSprite *right_button = [CCSprite spriteWithFile:@"down.png"];
        right_button.rotation = -90;
        right_button.position = CGPointMake(80 + 20, 40+20);
        CCSprite *up_button = [CCSprite spriteWithFile:@"down.png"];
        up_button.rotation = 180;
        up_button.position = CGPointMake(40+20, 80+20);
        [self addChild: down_button z:1 tag:1];
        [self addChild:up_button z:1 tag:2];
        [self addChild:left_button z:1 tag: 3];
        [self addChild:right_button z:1 tag: 4];
        self.scale = 0.6;
        
    }
    return self;
}

- (id) initWithReceiver: (id) rec
{
    [self init];
    receiver = rec;
    return self;
}

+ (id) nodeReceiver:(id) rec
{
    return [[[self alloc ] initWithReceiver: rec] autorelease];
}

- (void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
			CGPoint local = [item convertToNodeSpace:touchLocation];
            CGRect  r = CGRectMake(item.position.x - item.contentSize.width/2,item.position.y - item.contentSize.height/2, item.contentSize.width, item.contentSize.height);
			r.origin = CGPointZero;
			if( CGRectContainsPoint( r, local ) )
				return item;
		}

	return nil;
}


- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCNode *selectedItem_;
	selectedItem_ = [self itemForTouch:touch];
    switch ([selectedItem_ tag]) {
        case 1:
            [receiver command:@"down"];
            break;
        case 2:
            [receiver command:@"up"];
            break;
        case 3:
            [receiver command:@"left"];
            break;
        case 4:
            [receiver command:@"right"];
            break;
            
    }
	return YES;
}

- (void) dealloc
{
    [receiver dealloc];
    [super dealloc];
}

@end
