//
//  ScoreBoard.m
//  hello_world
//
//  Created by iclick on 12-1-31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScoreBoard.h"


@implementation ScoreBoard

- (id) init
{
    self = [super init];
    if(self){
        stepsMenu = [CCLabelTTF labelWithString:@"当前步数：0" fontName:@"Marker Felt" fontSize:12];
        [stepsMenu retain];
        bestMenu = [CCLabelTTF labelWithString:@"最佳成绩：无" fontName:@"Marker Felt" fontSize:12];
        [bestMenu retain];
        [self addChild: stepsMenu];
        [self addChild: bestMenu];
        self.contentSize = CGSizeMake(120, 200);
        stepsMenu.position = ccp(self.contentSize.width/2 , self.contentSize.height - stepsMenu.contentSize.height/2);
        bestMenu.position = ccp(self.contentSize.width/2 , self.contentSize.height - bestMenu.contentSize.height/2 - 10 - stepsMenu.contentSize.height);
        self.anchorPoint = ccp(0 , 0);
        self.position = ccp(384 , 50);
    }
    return self;
}

- (id) loadStage:(int)stage
{
    stage_ = stage;
    //TODO
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *score = [userDefault objectForKey:[NSString stringWithFormat:@"bestScoreStage%d" , stage]];
    if(score){
        bestScore = [score intValue];
    }else{
        bestScore = 0;
    }
    [stepsMenu setString: [NSString stringWithFormat:@"当前步数：%d" , curSteps]];
    if(bestScore > 0 ){
        [bestMenu setString: [NSString stringWithFormat:@"最佳成绩：%d" , bestScore]];        
    }
    return self;
}

- (void) fresh
{
    [stepsMenu setString: [NSString stringWithFormat:@"当前步数：%d" , curSteps]];
}


- (void) oneMoreStep
{
    curSteps += 1;
    [self fresh];
}

- (void) saveScore
{
    if(curSteps < bestScore || bestScore == 0){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"bestScoreStage%d" , stage_];
        NSNumber *value = [NSNumber numberWithInt:curSteps];
        [userDefault setObject: value  forKey:key];        
    }
}

- (void) cancelStep
{
    curSteps -= 1;
    [self fresh];
}

- (void) dealloc
{
    [stepsMenu release];
    [bestMenu release];
    [super dealloc];
}


@end
