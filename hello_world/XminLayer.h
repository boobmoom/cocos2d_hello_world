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


enum {
    kTagForPlayer,
    kTagForBackground
};
@class Controller;

@interface XminLayer : CCLayer {
    Player *player_;      
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    NSMutableArray *_boxes;
    Controller *controller_;
    NSNumber *stage_;
}

@property (nonatomic , assign , readwrite) Player *player;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

+ (CCScene *) sceneWithStage: (int) stage;

- (BOOL) isWallAtDirection: (NSString *) direction atPosition: (CGPoint) curPos;

- (CGPoint) nextStep: direction atPosition: (CGPoint) curPos;

- (CCSprite *) playerSprite;

- (CGPoint) toMapXY: (CGPoint) position;

- (void) checkWin;

- (CCSprite *) boxByPlayer: (NSString *) direction;

- (BOOL) playerMoveAble: (NSString *) direction;

- (BOOL) playerPushAble: (NSString *) direction;

- (void) playerMove: (NSString *) direction;

- (void) playerPush: (NSString *) direction;

- (BOOL) lastCommandExecuting;

- (void) addController: (Controller *) ctr;

- (void) addMenu;

-(void) mainMenu;

- (id) initWithStage: (int) stage;
@end
