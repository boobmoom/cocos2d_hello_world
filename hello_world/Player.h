//
//  Player.h
//  hello_world
//
//  Created by iclick on 12-1-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Direction.h"



@interface Player : NSObject {
    CCSprite *sprite_;
    NSMutableDictionary *animations;
    NSMutableDictionary *backAnimations_;
    int step_distance ;
    BOOL walking_;

}

@property (nonatomic,readwrite,assign) CCSprite *sprite; //TODO how to use property and its attached attributes readwrite, assign and retain?

- (void) setWalkAnimation;

- (void) walk: (Direction *) direction;

- (BOOL) walking;

- (void) walk: (Direction *) direction back: (BOOL) back;

- (void) setBackAnimation;

@end
