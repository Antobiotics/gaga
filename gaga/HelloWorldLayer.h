//
//  HelloWorldLayer.h
//  gaga
//
//  Created by Butterfly Dev on 08/04/2013.
//  Copyright Butterfly Dev 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTouchDispatcher.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite *seeker;
	CCSprite *background;
	CCSprite *sun;
	int frameCount;
	BOOL catMoving;
	BOOL catGrabbing;
	int tapcount;
	int tapVelocity;
}

@property (nonatomic, strong) CCSprite *cat;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;

@property (nonatomic, strong) NSDate *touchTimeStamp;
@property (nonatomic, strong) NSDate *prevTimeStamp;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
