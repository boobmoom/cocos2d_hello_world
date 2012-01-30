//
//  PushBoxStep.m
//  hello_world
//
//  Created by iclick on 12-1-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "PushBoxStep.h"


@implementation PushBoxStep

@synthesize playerStandPos = playerStandPos_;
@synthesize direction = direction_;
@synthesize boxPushed = boxPushed_;

- (id) initWithPlayerStandPos:(CGPoint)pos andDirection:(Direction *)direction boxPushed:(BOOL)pushed
{
    if (self = [super init]) {
        playerStandPos_ = pos;
        direction_ = direction;
        boxPushed_ = pushed;
    }  
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end


