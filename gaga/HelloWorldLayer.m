//
//  HelloWorldLayer.m
//  gaga
//
//  Created by Butterfly Dev on 08/04/2013.
//  Copyright Butterfly Dev 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(255, 255, 255, 255) ]) )
    {        
        [self schedule:@selector(nextFrame:)];
        [self schedule:@selector(gameLogic:) interval:1.0];
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) nextFrame:(ccTime) dt
{
    seeker.position = ccp( seeker.position.x, seeker.position.y + 100 * dt );
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGRect seekerRect = [seeker textureRect];
    float seekerWidth = seekerRect.size.width;
    if (seeker.position.x > size.width + 32 )
    {
        seeker.position = ccp( - seekerWidth, seeker.position.y);
    }
}

-(void) gameLogic:(ccTime) dt
{
    [self addAnt];
}


-(void) addAnt
{
    CCSprite *ant = [CCSprite spriteWithFile:@"ant.png"];
    CGSize winSize= [CCDirector sharedDirector].winSize;

    ant.scale     = ant.scale/32;
    ant.rotation  = - 90;
    int maxX      = winSize.width;
    ant.position  = ccp(arc4random() % maxX, winSize.height);

    [self addChild:ant];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 10.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(ant.position.x, ant.position.y - 1000)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }];
    [ant runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}   

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{    
    return YES;

}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [self convertTouchToNodeSpace: touch];
    CCSprite *toRemove;
    for ( CCSprite * ant in [self children] ){
        if ( CGRectContainsPoint(ant.boundingBox, location)){
            NSLog(@"Ant TOuched");
            toRemove = ant;
            CCSprite *blood = [CCSprite spriteWithFile:@"blood.png"];
            blood.position  = ant.position;
            blood.scale     = blood.scale/8;
            [self addChild:blood];
        }
    }
    [self removeChild:toRemove cleanup:YES];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
// 	CGPoint location = [self convertTouchToNodeSpace: touch];
//    seeker.position  = location;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
