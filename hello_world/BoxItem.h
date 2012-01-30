//
//  BoxItem.h
//  hello_world
//
//  Created by iclick on 12-1-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Direction.h"
#import "XminLayer.h"
@class XminLayer;
@interface BoxItem : NSObject
{
    CCSprite *sprite_;
}

@property (readonly , nonatomic) CCSprite *sprite;

@property (readonly , nonatomic) CGPoint position;

- (void) move:(Direction *)direction withTarget:(XminLayer *) gameLayer;

+ (id) initializeWithPosition: (CGPoint) position;

- initializeWithPosition: (CGPoint) position;


@end
