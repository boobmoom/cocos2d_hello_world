//
//  Controller.h
//  hello_world
//
//  Created by iclick on 12-1-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XminLayer.h"
#import "Direction.h"

@class XminLayer;

@interface Controller : NSObject
{
    CCMenu *layer_;
    XminLayer *gameLayer_;
}


@property (nonatomic,readwrite,assign) CCMenu *layer;
@property (nonatomic,readwrite,assign) XminLayer *gameLayer;

-(void) initLayer;

- (id) initWithGameLayer: (XminLayer *) layer;

+ (id) controlWithGameLayer: (XminLayer *) layer;

- (void) command: (Direction *) com;

-(void) cancelStep;
    
@end
