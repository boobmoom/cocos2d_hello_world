//
//  XminLayer.h
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Controller.h"
#import "BoxMenu.h"
#import "Direction.h"


enum {
    kTagForPlayer,
    kTagForBackground
};
@class Controller;

@interface PushBoxStep : NSObject {
    CGPoint playerStandPos_;
    Direction *direction_;
    BOOL boxPushed_;
}

@property (nonatomic , readonly) CGPoint playerStandPos;
@property (nonatomic , readonly) Direction *direction;
@property (nonatomic , readonly) BOOL boxPushed;

- (id) initWithPlayerStandPos: (CGPoint) pos andDirection: (Direction *) direction boxPushed:(BOOL)pushed;

@end

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

- (CGPoint) nextStep: (Direction *)direction atPosition: (CGPoint) curPos;

- (CCSprite *) playerSprite;

- (CGPoint) toMapXY: (CGPoint) position;

- (CCSprite *) boxAtPosition: (CGPoint ) position;

- (void) checkWin;

- (CCSprite *) boxByPlayer: (Direction *) direction;

- (BOOL) playerMoveAble: (Direction *) direction;

- (BOOL) playerPushAble: (Direction *) direction;

- (void) playerMove: (Direction *) direction;

- (void) playerPush: (Direction *) direction;

- (BOOL) lastCommandExecuting;

- (void) addController: (Controller *) ctr;

- (void) addMenu;

- (void) setBoxOpacity: (id) sender;

- (CCSprite *) boxAtMapXY: (CGPoint) position;

-(void) mainMenu;

- (id) initWithStage: (int) stage;

- (void) cancelStep;
@end
