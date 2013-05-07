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
	if( (self=[super initWithColor:ccc4(56, 178, 240, 255) ]) )
    {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		background = [CCSprite spriteWithFile:@"Cat_v7_02_MG_Land.png"];
		sun        = [CCSprite spriteWithFile:@"Cat_v7_08.1_Sun.png"];
		CCSprite *trees = [CCSprite spriteWithFile:@"Cat_v7_01_FG_Trees.png"];
		CGRect treesRect = [trees textureRect];
		trees.position = ccp(0,winSize.height - treesRect.size.height);
		sun.position = ccp(winSize.width - 100, winSize.height - 100);
		background.position = ccp(winSize.width/2 + 100, winSize.height/2);
		[self addChild:sun];
		[self addChild:background];
		[self addChild:trees];
		
		CCLabelTTF *touchcount = [CCLabelTTF labelWithString:@"Tapcount: 0" fontName:@"Marker Felt" fontSize:32];
		CCLabelTTF *frequency  = [CCLabelTTF labelWithString:@"speed: 0" fontName:@"Marker Felt" fontSize:32];
		CGRect touchCountRect = [touchcount textureRect];
		CGRect frequencyRect = [frequency textureRect];
		touchcount.position = ccp(touchCountRect.size.width/2 + 20, winSize.height/2 + 100);
		frequency.position  = ccp( frequencyRect.size.width/2 + 20, winSize.height/2 + 140);
		[self addChild: touchcount z:0 tag:1];
		[self addChild:  frequency z:0  tag:2];
		tapcount = 0;
		self.touchTimeStamp = [[NSDate  alloc] init];
		self.prevTimeStamp  = self.touchTimeStamp;
		catMoving      = NO;
		catGrabbing    = NO;
		frameCount     = 0;
		
		/* First Animation  */
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CAT.plist"];
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"CAT.png"];
		[self addChild:spriteSheet];
		NSMutableArray *walkAnimFrames = [NSMutableArray array];
		for (int i=1; i<=2; i++) {
			[walkAnimFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"Cat_v7_04.%d_Cat-Run-In.png",i]]];
		}
		CCAnimation *walkAnim = [CCAnimation
								 animationWithSpriteFrames:walkAnimFrames delay:0.1f];
		self.cat = [CCSprite spriteWithSpriteFrameName:@"Cat_v7_04.1_Cat-Run-In.png"];
		CGRect catRect = [self.cat textureRect];
		self.cat.position = ccp(catRect.size.width, winSize.height/2 - catRect.size.height);
		self.walkAction = [CCRepeatForever actionWithAction:
						   [CCAnimate actionWithAnimation:walkAnim]];
		self.walkAction.tag = 1;
		//[self.cat runAction:self.walkAction];
		[spriteSheet addChild:self.cat];
		
		
        [self schedule:@selector(nextFrame:)];
//        [self schedule:@selector(gameLogic:) interval:1.0];
		[self schedule:@selector(sunLogic:) interval:0.5];
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) nextFrame:(ccTime) dt
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGRect catRect = [self.cat textureRect];

	if (self.cat.position.x < winSize.width - catRect.size.width - 125 && tapcount != 0) {
		self.cat.position   = ccp(self.cat.position.x   + 75 * dt, self.cat.position.y  );
		background.position = ccp(background.position.x - 75 * dt, background.position.y);
		if (!catMoving) {
			[self.cat runAction:self.walkAction];
			catMoving = YES;
		}
	} else {
		[self.cat stopAction:self.walkAction];
		catGrabbing = YES;
		catMoving   = NO;
	}

}
-(void) sunLogic:(ccTime) dt
{
	if (frameCount % 5 == 0) {
		CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"Cat_v7_08.2_Sun.png"];
		[sun setTexture:tex];
		
	} else {
		CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"Cat_v7_08.1_Sun.png"];
		[sun setTexture:tex];
	}
	frameCount++;
}
-(void) gameLogic:(ccTime) dt
{

}


#pragma mark touch events
-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void) updatetouchcount
{
	CCLabelTTF *touchcount = (CCLabelTTF*)[self getChildByTag:1];
	[touchcount setString:[NSString stringWithFormat:@"Tapcount: %d",tapcount]];
}

- (void) updateFrequency:(time_t)timeDiff_v count:(int)tapcount_v
{
	CCLabelTTF *frequency = (CCLabelTTF*)[self getChildByTag:2];
	double speed =  (double)tapcount_v/((double)timeDiff_v);
	[frequency setString:[NSString stringWithFormat:@"Speed: %f",speed]];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{    
    return YES;

}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	tapcount++;
	self.touchTimeStamp =[NSDate  date];
	NSTimeInterval timeDiff = [self.touchTimeStamp timeIntervalSinceDate:self.prevTimeStamp];
	tapVelocity = tapcount / timeDiff;
	[self updatetouchcount];
	CCLabelTTF *speed = (CCLabelTTF*)[self getChildByTag:2];
	[speed setString:[NSString stringWithFormat:@"Speed: %d",tapVelocity]];
	self.prevTimeStamp = self.touchTimeStamp;
	if (catGrabbing == YES) {

//		if (tapVelocity < 200) {
//			￼
//		}
//		if (tapVelocity >= 200 && tapVelocity < 600) {
//			
//		}
	}
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
