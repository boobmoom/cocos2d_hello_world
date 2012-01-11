//
//  GameLayer.m
//  hello_world
//
//  Created by iclick on 11-12-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
//#import "math.h"


@implementation GameLayer
+ (id) scene
{
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
    if(self = [super init])
    {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
//        self.isAccelerometerEnabled = YES;
        self.isTouchEnabled = YES;
        CCSprite *player = [CCSprite spriteWithFile:@"alien.png"];
        [self addChild:player z:0 tag:kTagForPlayer];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        float imageHeight = [player texture].contentSize.height;
        player.position = CGPointMake(screenSize.width/2 , imageHeight/2);
    }
    return self;
}


- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCSprite *player = (CCSprite *)[self getChildByTag: kTagForPlayer];
    id touch;
    CGPoint pos;
//    int i=0;
    CGPoint begin_point;
    NSEnumerator *touch_enumerator = [touches objectEnumerator];
    while(touch = [touch_enumerator nextObject]) {
        begin_point = [touch previousLocationInView: [touch view]];
        begin_point = [[CCDirector sharedDirector] convertToGL:begin_point];
        float distance = pow((begin_point.x - player.position.x),2) + pow((begin_point.y - player.position.y), 2);
//        CCLOG(@"%f" , distance);
//        CCLOG(@"x:%f y:%f" ,  begin_point.x , [player anchorPoint].x);
        if ( distance > 5000)
        {
            break;
        }
            
//        i += 1;
        pos = [touch locationInView: [touch view]];
        pos = [[CCDirector sharedDirector] convertToGL:pos];
//        CCLOG(@"%i" , i);
        player.position = pos;
    }
//    CCLOG(@"x");
}



- (void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super dealloc];
}


@end
