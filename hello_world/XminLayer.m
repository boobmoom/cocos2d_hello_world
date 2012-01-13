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

    
    CCSprite *down_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *down_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *downItem = [CCMenuItemSprite itemFromNormalSprite: down_button selectedSprite:down_button_selected target: layer selector: @selector(walkDown)];
    downItem.position = CGPointMake(40 + 20, 20);
    
    CCSprite *left_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *left_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *leftItem = [CCMenuItemSprite itemFromNormalSprite: left_button selectedSprite:left_button_selected  target: layer selector: @selector(walkLeft)];
    leftItem.rotation = 90;
    leftItem.position = CGPointMake(20 , 40+20);
    
    CCSprite *right_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *right_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *rightItem = [CCMenuItemSprite itemFromNormalSprite: right_button selectedSprite:right_button_selected target: layer selector: @selector(walkRight)];
    rightItem.rotation = -90;
    rightItem.position = CGPointMake(80 + 20, 40+20);
    
    CCSprite *up_button = [CCSprite spriteWithFile:@"down.png"];
    CCSprite *up_button_selected = [CCSprite spriteWithFile:@"down.png"];
    CCMenuItemSprite *upItem = [CCMenuItemSprite itemFromNormalSprite: up_button selectedSprite:up_button_selected target: layer selector: @selector(walkUp)];
    upItem.rotation = 180;
    upItem.position = CGPointMake(40+20, 80+20);
    
    CCMenu *control_layer = [CCMenu menuWithItems: downItem , rightItem , leftItem , upItem ,nil];
    
    control_layer.contentSize = CGSizeMake(120, 120);
    CGSize win_size = [[CCDirector sharedDirector] winSize];
    control_layer.position = CGPointMake(win_size.width - 120 ,0);
    control_layer.scale = 0.6;
    
    
    [scene addChild: layer];
    [scene addChild: control_layer];


    return scene;
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

- (CCSprite *) playerSprite
{
    return [[self player] sprite];
}

- (void) command: (NSString *) com
{
    if([[self player] walking]){return;}
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
        CCScene *winScene = [CCScene node];
        CCLayer *winLayer = [CCLayer node];
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"You Win" fontName:@"Marker Felt" fontSize:30];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        label.position = ccp(screenSize.width/2,screenSize.height/2);
        [winLayer addChild:label];
        [winScene addChild: winLayer];
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
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"boxes1.tmx"];
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
    // TODO how to release these variables;
    [_boxes dealloc];
    [player_ dealloc];
    [super dealloc];
}

          

@end
