//
//  XminLayer.m
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "XminLayer.h"

@implementation PushBoxStep

@synthesize playerStandPos = playerStandPos_;
@synthesize direction = direction_;
@synthesize boxPushed = boxPushed_;

- (id) initWithPlayerStandPos:(CGPoint)pos andDirection:(NSString *)direction boxPushed:(BOOL)pushed
{
    if (self = [super init]) {
        playerStandPos_ = pos;
        direction_ = direction;
        boxPushed_ = pushed;
    }  
    return self;
}

- (void) dealloc
{
    [direction_ dealloc];
    [super dealloc];
}

@end



@implementation XminLayer

@synthesize player = player_;
@synthesize tileMap = _tileMap;
@synthesize background = _background;
@synthesize lastSteps = lastSteps_;

+ (CCScene *) sceneWithStage: (int) stage
{
    CCScene *scene = [CCScene node];
    XminLayer *layer = [[XminLayer alloc] initWithStage:stage];
    Controller *controller = [Controller controlWithGameLayer:layer];
    [layer addController: controller];
    [scene addChild: layer];
    return scene;
}

- (BOOL) lastCommandExecuting
{
    return [[self player] walking];
}


- (void) cancelStep
{
    PushBoxStep *step;
    step = [lastSteps_ objectAtIndex:0];
    NSString *direction;
    if ([step direction] == @"down"){
        direction  = @"up";
    }
    if ([step direction] == @"up"){
        direction  = @"down";
    }
    if ([step direction] == @"left"){
        direction  = @"right";
    }
    if ([step direction] == @"right"){
        direction  = @"left";
    }
    if ([step boxPushed]){
        [[self player] walk:direction back:YES];
        int step_distance = _tileMap.tileSize.width;
        CCSprite *boxSprite = [self boxByPlayer:[step direction]];
        CCMoveBy *moveAction;
        if(direction == @"down")
            moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, -step_distance)] ;
        if(direction == @"up")
            moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, step_distance)] ;
        if(direction == @"left")
            moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(-step_distance , 0.0)] ;
        if(direction == @"right")
            moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(step_distance , 0.0)] ;
        CCCallFuncN *setBoxOpacity;
        setBoxOpacity = [CCCallFuncN actionWithTarget:self selector:@selector(setBoxOpacity:)];
        [boxSprite runAction: [CCSequence actions:moveAction , setBoxOpacity , nil]];
        
    }else{
        [[self player] walk:direction back:YES];
    }
    [lastSteps_ removeObjectAtIndex:0];
    [lastSteps_ addObject:@"nil"];
    
}



- (CCSprite *) playerSprite
{
    return [[self player] sprite];
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

        CCScene *nextScene;
        if([stage_ intValue] < [StageLayer totalStages]){
            nextScene = [XminLayer sceneWithStage: ([stage_ intValue] + 1)];
        }else{
            nextScene = [CCScene node];
            CCLayer *winLayer = [CCLayer node];
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"You Win" fontName:@"Marker Felt" fontSize:30];
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            label.position = ccp(screenSize.width/2,screenSize.height/2);
            [winLayer addChild:label];
            [nextScene addChild: winLayer];
        }
        CCTransitionFlipX *transitionScene = [CCTransitionFlipX transitionWithDuration:0.6 scene:nextScene orientation:kOrientationRightOver];
//        CCActionInterval *rightSlideSceneAction;

        
        [[CCDirector sharedDirector] replaceScene:transitionScene];
    }
}

- (void) playerMove:(NSString *)direction
{
    [[self player] walk:direction];
    PushBoxStep *step;
    step = [[[PushBoxStep alloc] initWithPlayerStandPos:[self playerSprite].position andDirection: direction boxPushed:NO] autorelease];
    [lastSteps_ removeObjectAtIndex:2];
    [lastSteps_ insertObject:step atIndex:0];
}

- (void) playerPush:(NSString *)direction
{
    int step_distance = _tileMap.tileSize.width;
    CCSprite *boxSprite = [self boxByPlayer:direction];
    [[self player] walk:direction];
    CCMoveBy *moveAction;
    CCCallFunc *checkWin ;
    CCCallFuncN *setBoxOpacity;
    if(direction == @"down")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, -step_distance)] ;
    if(direction == @"up")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(0.0, step_distance)] ;
    if(direction == @"left")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(-step_distance , 0.0)] ;
    if(direction == @"right")
        moveAction = [CCMoveBy actionWithDuration:0.3 position: CGPointMake(step_distance , 0.0)] ;
    checkWin = [CCCallFunc actionWithTarget:self selector:@selector(checkWin)];
    setBoxOpacity = [CCCallFuncN actionWithTarget:self selector:@selector(setBoxOpacity:)];
    [boxSprite runAction: [CCSequence actions:moveAction, checkWin ,setBoxOpacity , nil]];
    PushBoxStep *step;
    step = [[[PushBoxStep alloc] initWithPlayerStandPos:[self playerSprite].position andDirection: direction boxPushed:YES] autorelease];
    [lastSteps_ removeObjectAtIndex:2];
    [lastSteps_ insertObject:step atIndex:0];
}


- (void) setBoxOpacity: (id) sender
{
    CGPoint mapPos = [self toMapXY: [(CCSprite *)sender position]];

    int tilGid = [_background tileGIDAt: mapPos];
    NSDictionary *properties = [_tileMap propertiesForGID:tilGid];
    NSString *des = [properties valueForKey:@"des"];
    if (des && [des compare:@"true"] == NSOrderedSame) {
        [(CCSprite *)sender setOpacity: 180];
    }else{
        [(CCSprite *)sender setOpacity: 255];
    }
}

- (BOOL) playerMoveAble: (NSString *) direction
{
    CGPoint playerPos = [self playerSprite].position;
    CCSprite *boxSprite = [self boxByPlayer:direction];
    // not wall and not boxes  then return YES;
    return ![self isWallAtDirection:direction atPosition:playerPos] && !boxSprite;
}
//TODO box
- (BOOL)playerPushAble:(NSString *)direction
{
    CCSprite *boxSprite;
    boxSprite = [self boxByPlayer:direction];
    if(boxSprite){        
        if( [self isWallAtDirection:direction atPosition:boxSprite.position]){
            return NO;
        }else{
            CGPoint boxNextPos;
            boxNextPos = [self nextStep: direction atPosition:boxSprite.position];
            if ( [self boxAtMapXY:boxNextPos]){
                return NO;
            }else{
                return YES;
            }
        }
    }else{
        return NO;
    }
}

- (CCSprite *) boxByPlayer: (NSString *) direction
{
    CGPoint boxPos ;
    CGPoint playerPos = [self playerSprite].position;
    if(direction == @"left")
        boxPos = ccp(playerPos.x - 32 , playerPos.y);
    if(direction == @"right")
        boxPos = ccp(playerPos.x + 32 , playerPos.y);
    if(direction == @"down")
        boxPos = ccp(playerPos.x , playerPos.y - 32);
    if(direction == @"up")
        boxPos = ccp(playerPos.x , playerPos.y + 32);  
    return [self boxAtPosition: boxPos];
}

- (CCSprite *) boxAtPosition: (CGPoint ) position
{
    NSEnumerator *enumerator;
    enumerator = [_boxes objectEnumerator];
    CCSprite *box_sprite;
    while (box_sprite = [enumerator nextObject] ) {
        if (CGPointEqualToPoint(box_sprite.position , position)) {
            return box_sprite;
        }
    }
    return nil;
}

- (CCSprite *) boxAtMapXY: (CGPoint) position
{
    NSEnumerator *enumerator;
    enumerator = [_boxes objectEnumerator];
    CCSprite *box_sprite;
    while (box_sprite = [enumerator nextObject] ) {
        if (CGPointEqualToPoint( [self toMapXY:box_sprite.position] , position)) {
            return box_sprite;
        }
    }
    return nil;  
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


- (id) initWithStage: (int) stage
{
    stage_ =  [NSNumber numberWithInt:stage] ;
    [stage_ retain];
    return [[self init] autorelease];
}


- (id) init
{
    if(self = [super init]){
        NSString *mapStr = [NSString stringWithFormat:@"boxes%d.tmx" , [stage_ intValue]];
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile: mapStr];
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
        [self addMenu];
        //init lastSteps_
        lastSteps_ = [[NSMutableArray alloc] initWithCapacity:3];
        [lastSteps_ addObject:@"nil"];
        [lastSteps_ addObject:@"nil"];
        [lastSteps_ addObject:@"nil"];
    }
    return self;
}


- (void) addMenu
{
    
    CCLabelTTF *mainMenu = [CCLabelTTF labelWithString:@"主菜单" fontName:@"Marker Felt" fontSize:30];
    CCMenuItemLabel *mainMenuLabel = [CCMenuItemLabel itemWithLabel:mainMenu  target:self selector:@selector(mainMenu)];
    CCMenu *menu = [CCMenu menuWithItems:mainMenuLabel,nil];
    menu.contentSize = mainMenuLabel.contentSize;
    menu.position = ccp(384 + menu.contentSize.width/2  , 200 + menu.contentSize.height/2);
    [self addChild:menu];
}

-(void) mainMenu
{
    [[CCDirector sharedDirector] replaceScene:[BoxMenu scene]];
}

- (void) addController: (Controller *) ctr
{
    controller_ = ctr;
    [controller_ retain];
    [self addChild:[ctr layer]];
}

- (void) dealloc
{
    [stage_ release];
    [lastSteps_ dealloc];
    [_boxes dealloc];
    [player_ dealloc];
    [controller_ dealloc];
    [super dealloc];
}

          

@end
