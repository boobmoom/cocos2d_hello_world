//
//  XminLayer.m
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "XminLayer.h"



@implementation XminLayer

@synthesize player = player_;
@synthesize tileMap = _tileMap;
@synthesize background = _background;

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    XminLayer *layer = [XminLayer node];
    ControlLayer *control_layer = [ControlLayer nodeReceiver: layer];
    [scene addChild: layer];
    [scene addChild: control_layer];


    return scene;
}


- (CCSprite *) playerSprite
{
    return [[self player] sprite];
}

- (void) command: (NSString *) com
{
    CCSprite  *box_sprite;
    int step_distance = 32;
    if ([self isWallAtDirection:com atPosition:[self player].sprite.position]) {
        
        
    }else{
        box_sprite = [self boxAtDirection:com atPosition:[self playerSprite].position];
        if(box_sprite) {
            if ([self isWallAtDirection:com atPosition:box_sprite.position]) {
                //box can't move
//                CCLOG(@"can't move");
            }else{
                //box can move
                [[self player] walk: com];  
                
                CCMoveBy *moveAction;
                CCCallFunc *checkWin;
                if(com == @"down")
                    moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, -step_distance)] ;
                if(com == @"up")
                    moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, step_distance)] ;
                if(com == @"left")
                    moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(-step_distance , 0.0)] ;
                if(com == @"right")
                    moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(step_distance , 0.0)] ;
                checkWin = [CCCallFunc actionWithTarget:self selector:@selector(checkWin)];
                [box_sprite runAction: [CCSequence actions:moveAction, checkWin , nil]];

//                CCLOG(@"can move");
            }
        }else{
            //no box
            [[self player] walk: com];
        }

    }

}

- (void) checkWin
{
    CCScene *winScene = [CCScene node];
    NSEnumerator *enumerator = [_boxes objectEnumerator];
    CCSprite *box_sprite;
    int s = 0;
    CGPoint mapPos;
    while ( box_sprite = [enumerator nextObject]) {
        mapPos = [self toMapXY:box_sprite.position];
        int tilGid = [_background tileGIDAt: mapPos];
        NSDictionary *properties = [_tileMap propertiesForGID:tilGid];
        NSString *des = [properties valueForKey:@"des"];
        if (des && [des compare:@"true"] == NSOrderedSame) {
            s+= 1;
        }
    }
    
    if (s == [_boxes count]){
        [[CCDirector sharedDirector] replaceScene: winScene];
    }
}

- (CGPoint) nextStep: direction atPosition: (CGPoint) curPos
{
    CGPoint curTiledPos = [self toMapXY: curPos];
    CGPoint nextStep;
    if (direction == @"left") {
        nextStep = CGPointMake(curTiledPos.x - 1, curTiledPos.y);
    }
    if (direction == @"right") {
        nextStep = CGPointMake(curTiledPos.x + 1, curTiledPos.y);
    }
    if (direction == @"down") {
        nextStep = CGPointMake(curTiledPos.x , curTiledPos.y + 1);
    }
    if (direction == @"up") {
        nextStep = CGPointMake(curTiledPos.x, curTiledPos.y - 1);
    }
    return nextStep;
}

- (CGPoint) toMapXY: (CGPoint) position
{
    CGPoint pos =CGPointMake((position.x - 16) / 32, 9 - (position.y - 16)/32);  
    return pos;
}

- (BOOL) isWallAtDirection: (NSString *) direction atPosition: (CGPoint) curPos
{
    CGPoint nextStep = [self nextStep: direction atPosition: curPos];
    int tilGid = [_background tileGIDAt: nextStep];
    NSDictionary *properties = [_tileMap propertiesForGID:tilGid];
    NSString *collision = [properties valueForKey:@"collidable"];
    if (collision && [collision compare:@"true"] == NSOrderedSame) {
        return YES;
    }else{
        return NO;
    }
    
};

- (CCSprite *) boxAtDirection: (NSString *) direction atPosition: (CGPoint) curPos
{
    NSEnumerator *enumerator;
    enumerator = [_boxes objectEnumerator];
    CGPoint nextStep = [self nextStep: direction atPosition: curPos];
    CCSprite *box_sprite;
    CGPoint boxPos;
    while (box_sprite = [enumerator nextObject] ) {
        boxPos = [self toMapXY:box_sprite.position];
        if (CGPointEqualToPoint(nextStep , boxPos)) {
            return box_sprite;
        }
    }
    return nil;
}



- (id) init
{
    if(self = [super init]){
        //add map
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"boxes.tmx"];
        _background = [_tileMap layerNamed:@"background"];
        CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"player"];
        NSMutableDictionary *playerPoint = [objects objectNamed:@"player"];
        int x,y;
        x = [[playerPoint valueForKey:@"x"] intValue];
        y = [[playerPoint valueForKey:@"y"] intValue];
        
        //add player
        Player *player = [[Player alloc] init];
        [self setPlayer: player];
        [player sprite].position = CGPointMake(x+16, y+16);
        [self addChild: [[self player] sprite] z:0 tag: kTagForPlayer];
        [self addChild:_tileMap z:-1];
        //add box
        int i ;
        _boxes = [[NSMutableArray alloc] initWithCapacity:10];
        for (i = 1 ; i<= 10; i++) {
            CCSprite *box_sprite = [CCSprite spriteWithFile:@"tmw_desert_spacing.png" rect:CGRectMake(6*32 + 7, 3*32 + 4, 32, 32)];
            NSMutableDictionary *boxPoint = [objects objectNamed:[NSString stringWithFormat:@"box%i" , i]];
            if (boxPoint == nil) {
                break;
            }
            x = [[boxPoint valueForKey:@"x"] intValue];
            y = [[boxPoint valueForKey:@"y"] intValue];
            box_sprite.position = CGPointMake(x+16 , y+16);
            [self addChild: box_sprite];
            [_boxes addObject:box_sprite];
        }
        
    }
    return self;
}

- (void) dealloc
{
    [_boxes dealloc];
    [player_ dealloc];
    [_tileMap dealloc];
    [_background dealloc];
    [super dealloc];
}

          

@end
