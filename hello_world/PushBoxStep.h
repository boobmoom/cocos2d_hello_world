//
//  PushBoxStep.h
//  hello_world
//
//  Created by iclick on 12-1-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "XminLayer.h"
#import "Direction.h"


@interface PushBoxStep : NSObject {
    CGPoint playerStandPos_;
    Direction *direction_;
    BOOL boxPushed_;
}

@property (nonatomic , readonly) CGPoint playerStandPos;
@property (nonatomic , readonly) Direction *direction;
@property (nonatomic , readonly) BOOL boxPushed;

- (id) initWithPlayerStandPos: (CGPoint) pos andDirection: (Direction *) direction boxPushed:(BOOL)pushed;

@end
