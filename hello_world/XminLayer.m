//
//  XminLayer.m
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "XminLayer.h"

@interface XminLayer (Private)
    - (NSDictionary *) propertiesAtPosition: (CGPoint) position;
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

//之前的动作是否执行完成
- (BOOL) lastCommandExecuting
{
    return [[self player] walking];
}

//悔步
- (void) cancelStep
{
    PushBoxStep *step;
    step = [lastSteps_ objectAtIndex:0];
    Direction *direction;
    direction = [step direction];
    if ([step boxPushed]){
        [[self player] walk:[direction oppositDirection] back:YES];
        BoxItem *boxItem = [self boxByPlayer:direction];
        [boxItem move:[direction oppositDirection] withTarget:self];        
    }else{
        [[self player] walk:[direction oppositDirection] back:YES];
    }
    [lastSteps_ removeObjectAtIndex:0];
    [lastSteps_ addObject:@"nil"];
    
}

//TODO 这里为什么会用到player sprite 不太符合常理
- (CCSprite *) playerSprite
{
    return [[self player] sprite];
}

- (void) checkWin
{
    NSEnumerator *enumerator = [_boxes objectEnumerator];
    BoxItem *boxItem;
    int s = 0;
    while ( boxItem = [enumerator nextObject]) {
        NSDictionary *properties  = [self propertiesAtPosition: boxItem.position];
        NSString *des = [properties valueForKey:@"des"];
        if (des && [des compare:@"true"] == NSOrderedSame) {
            s+= 1;
        }
    }
    if (s == [_boxes count]){
        //进入下一关
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
        [[CCDirector sharedDirector] replaceScene:transitionScene];
    }
}

- (void) playerMove:(Direction *)direction
{
    [[self player] walk:direction];
    PushBoxStep *step = [[[PushBoxStep alloc] initWithPlayerStandPos:[self playerSprite].position andDirection: direction boxPushed:NO] autorelease];
    [lastSteps_ removeObjectAtIndex:2];
    [lastSteps_ insertObject:step atIndex:0];
}

- (void) playerPush:(Direction *)direction
{
    BoxItem *boxItem = [self boxByPlayer:direction];
    [[self player] walk:direction];
    [boxItem move:direction withTarget:self];
    PushBoxStep *step = [[[PushBoxStep alloc] initWithPlayerStandPos:[self playerSprite].position andDirection: direction boxPushed:YES] autorelease];
    [lastSteps_ removeObjectAtIndex:2];
    [lastSteps_ insertObject:step atIndex:0];
}


- (void) setBoxOpacity: (id) sender
{
    NSDictionary *properties = [self propertiesAtPosition:[(CCSprite *)sender position]];
    NSString *des = [properties valueForKey:@"des"];
    if (des && [des compare:@"true"] == NSOrderedSame) {
        [(CCSprite *)sender setOpacity: 180];
    }else{
        [(CCSprite *)sender setOpacity: 255];
    }
}

- (BOOL) playerMoveAble: (Direction *) direction
{
    CGPoint playerPos = [self playerSprite].position;
    BoxItem *boxItem = [self boxByPlayer:direction];
    CCLOG(@"PlayerMoveAble at direction %@ isWall %d , isBox %d" , [direction directionStr] ,[self isWallAtDirection:direction atPosition:playerPos] ,  !!boxItem);
    return ![self isWallAtDirection:direction atPosition:playerPos] && !boxItem;
}
//TODO refactor
- (BOOL)playerPushAble:(Direction *)direction
{
    BoxItem *boxItem = [self boxByPlayer:direction];
    if(boxItem){        
        if( [self isWallAtDirection:direction atPosition:boxItem.position]){
            return NO;
        }else{
            CGPoint nextByBoxPos;
            nextByBoxPos = [self positionOfDirection:direction ofCurrentPos:[self playerSprite].position step:2];
            if ([self boxAtPosition: nextByBoxPos]){return NO;}
            return YES;
        }
    }
    return NO;
}

- (BoxItem *) boxByPlayer: (Direction *) direction
{
    CGPoint playerPos = [self playerSprite].position;
    CGPoint boxPos = ccp(playerPos.x + direction.stepSize.width , playerPos.y + direction.stepSize.height);
    return [self boxAtPosition: boxPos];
}

- (BoxItem *) boxAtPosition: (CGPoint ) position
{
    NSEnumerator *enumerator;
    enumerator = [_boxes objectEnumerator];
    BoxItem *boxItem;
    while (boxItem = [enumerator nextObject] ) {
        if (CGPointEqualToPoint([boxItem position] , position)) {
            return boxItem;
        }
    }
    return nil;
}

- (CGPoint) toMapXY: (CGPoint) position
{
    CGPoint pos =CGPointMake((position.x - 16) / 32, 9 - (position.y - 16)/32);  
    return pos;
}    

- (CGPoint) positionOfDirection:(Direction *) direction ofCurrentPos:(CGPoint) curPos
{
    return [self positionOfDirection:direction ofCurrentPos:curPos step: 1];
}

- (CGPoint) positionOfDirection:(Direction *) direction ofCurrentPos:(CGPoint) curPos step:(int) step
{
    return ccp( curPos.x + direction.stepSize.width * step , curPos.y + direction.stepSize.height * step);
}

- (NSDictionary *) propertiesAtPosition: (CGPoint) position
{
    CGPoint mapXY = [self toMapXY:position];
    int tilGid = [_background tileGIDAt:mapXY];
    NSDictionary *properties = [_tileMap propertiesForGID:tilGid];
    return properties;
}

- (BOOL) isWallAtDirection: (Direction *) direction atPosition: (CGPoint) curPos
{
    CGPoint thePosition = [self positionOfDirection:direction ofCurrentPos:curPos];
    NSDictionary *properties = [self propertiesAtPosition: thePosition];
    NSString *collision = [properties valueForKey:@"collidable"];
    if (collision && [collision compare:@"true"] == NSOrderedSame) return YES;
    return NO;
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
        //遍历初使化箱子
        for (i = 1 ; i<= 10; i++) {
            BoxItem *box;
            NSMutableDictionary *boxPoint = [objects objectNamed:[NSString stringWithFormat:@"box%i" , i]];
            if (boxPoint == nil) {break;}
            x = [[boxPoint valueForKey:@"x"] intValue];
            y = [[boxPoint valueForKey:@"y"] intValue];
            box = [BoxItem initializeWithPosition:CGPointMake(x+16 , y+16)];
            [self addChild: [box sprite]];
            [_boxes addObject:box];
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
