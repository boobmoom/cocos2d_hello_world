//
//  BoxMenu.m
//  hello_world
//
//  Created by iclick on 12-1-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BoxMenu.h"


@implementation BoxMenu

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
        CCMenu *menu = [self boxMenu];
        self.isTouchEnabled = YES;
        [self addChild: menu];
    }
    return self;
}

- (CCMenu *) boxMenu
{
    CCLabelTTF *newGame = [CCLabelTTF labelWithString:@"新游戏" fontName:@"Marker Felt" fontSize:30];
    CCLabelTTF *selectStage = [CCLabelTTF labelWithString:@"选择关卡" fontName:@"Marker Felt" fontSize:30];
    CCLabelTTF *exitGame = [CCLabelTTF labelWithString:@"待定" fontName:@"Marker Felt" fontSize:30];
    CCMenuItemLabel *newGameLabel = [CCMenuItemLabel itemWithLabel:newGame  target:self selector:@selector(newGame)];
    CCMenuItemLabel *selectStageLabel = [CCMenuItemLabel itemWithLabel:selectStage  target:self selector:@selector(selectStage)];
    CCMenuItemLabel *exitGameLabel = [CCMenuItemLabel itemWithLabel:exitGame  target:self selector:@selector(exitGame)];
    CCMenu *menu = [CCMenu menuWithItems:newGameLabel, selectStageLabel , exitGameLabel ,nil];
    [menu alignItemsVertically];
    return menu;
}

- (void) newGame
{
    [[CCDirector sharedDirector] replaceScene: [XminLayer sceneWithStage:1]];
}

- (void) selectStage
{
    [[CCDirector sharedDirector] replaceScene:[StageLayer scene]];
}

- (void) exitGame
{

}

@end
