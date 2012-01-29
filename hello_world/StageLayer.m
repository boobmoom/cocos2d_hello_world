//
//  StageLayer.m
//  hello_world
//
//  Created by iclick on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "StageLayer.h"


@implementation StageLayer

+ (int) totalStages
{
    return 5;
}

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [self node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
    if (self = [super init]){
        CCMenu *stages;
        int i;
        stages = [CCMenu menuWithItems: nil];
        for (i = 1; i<= [StageLayer totalStages]; i++ ) {
            NSString *stageStr = [NSString stringWithFormat: @"%d" , i];
            CCLabelTTF *stageLabel = [CCLabelTTF labelWithString: stageStr fontName:@"Marker Felt" fontSize:25];
            CCMenuItemFont *stageMenuItem = [CCMenuItemFont itemWithLabel:stageLabel target:self selector:@selector(selectStage:)];
            [stages addChild:stageMenuItem];
        }
        [stages alignItemsVertically];
        [self addChild:stages];
    }
    return self;
}


- (void) selectStage:(id)sender
{
    int stage = [[[(CCMenuItemFont *)sender label] string] intValue];
    CCLOG(@"%d" , stage);
    CCScene *scene = [XminLayer sceneWithStage:stage];
    [[CCDirector sharedDirector] replaceScene:scene];
}


@end
