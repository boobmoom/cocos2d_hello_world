//
//  XminLayer.h
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

//这个是游戏的主要场景

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Controller.h"
#import "BoxMenu.h"
#import "Direction.h"
#import "PushBoxStep.h"
#import "BoxItem.h"


enum {
    kTagForPlayer,
    kTagForBackground
};
@class Controller;
@class BoxItem;


@interface XminLayer : CCLayer {
    Player *player_;      
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    NSMutableArray *_boxes;
    Controller *controller_;
    NSNumber *stage_;
    NSMutableArray *lastSteps_;
}

@property (nonatomic , assign , readwrite) Player *player;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, readonly) NSMutableArray *lastSteps;

+ (CCScene *) sceneWithStage: (int) stage;

- (BOOL) isWallAtDirection: (Direction *) direction atPosition: (CGPoint) curPos;

- (CCSprite *) playerSprite;

- (CGPoint) toMapXY: (CGPoint) position;

- (BoxItem *) boxAtPosition: (CGPoint ) position;

- (void) checkWin;

- (BoxItem *) boxByPlayer: (Direction *) direction;

- (BOOL) playerMoveAble: (Direction *) direction;

- (BOOL) playerPushAble: (Direction *) direction;

- (void) playerMove: (Direction *) direction;

- (void) playerPush: (Direction *) direction;

- (CGPoint) positionOfDirection:(Direction *) direction ofCurrentPos:(CGPoint) curPos;

- (CGPoint) positionOfDirection:(Direction *) direction ofCurrentPos:(CGPoint) curPos step:(int) step;

- (BOOL) lastCommandExecuting;

- (void) addController: (Controller *) ctr;

- (void) addMenu;

- (void) setBoxOpacity: (id) sender;

-(void) mainMenu;

- (id) initWithStage: (int) stage;

- (void) cancelStep;
@end
