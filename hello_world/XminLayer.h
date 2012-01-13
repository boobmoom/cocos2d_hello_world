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


enum {
    kTagForPlayer,
    kTagForBackground
};

@interface XminLayer : CCLayer {
    Player *player_;      
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    NSMutableArray *_boxes;
}

@property (nonatomic , assign , readwrite) Player *player;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

+ (CCScene *) scene;

- (void) command: (NSString *) com;

- (BOOL) isWallAtDirection: (NSString *) direction atPosition: (CGPoint) curPos;

- (CGPoint) nextStep: direction atPosition: (CGPoint) curPos;

- (CCSprite *) boxAtDirection: (NSString *) direction atPosition: (CGPoint) curPos;

- (CCSprite *) playerSprite;

- (CGPoint) toMapXY: (CGPoint) position;

- (void) checkWin;



@end
