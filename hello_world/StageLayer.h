//
//  StageLayer.h
//  hello_world
//
//  Created by iclick on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XminLayer.h"

@interface StageLayer : CCLayer {
    
}

+ (CCScene *) scene;

+ (int) totalStages;

- (void) selectStage: (id) sender;

@end
