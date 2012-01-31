//
//  ScoreBoard.h
//  hello_world
//
//  Created by iclick on 12-1-31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreBoard : CCNode {
    CCLabelTTF *stepsMenu , *bestMenu;
    int curSteps , bestScore , stage_;
}

- (id) loadStage: (int) stage;

- (void) oneMoreStep;

- (void) saveScore;

- (void) cancelStep;

- (void) fresh;

@end
