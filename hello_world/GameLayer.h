//
//  GameLayer.h
//  hello_world
//
//  Created by iclick on 11-12-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum{
    kTagForPlayer = 1
};

@interface GameLayer : CCMenu {
    
}

+ (id) scene;
@end
