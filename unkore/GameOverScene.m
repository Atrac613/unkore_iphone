//
//  GameOverScene.m
//  unkore
//
//  Created by Daichi Nakajima on 12/07/16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"


@implementation GameOverScene
@synthesize viewController;

-(id) init
{
    self = [super init];
    if (self) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // 背景画像
        CCSprite* uiframe = [CCSprite spriteWithFile:@"gameover_background.png"];
        uiframe.position = ccp(0, screenSize.height);
        uiframe.anchorPoint = ccp(0, 1);
        [self addChild:uiframe z:0];

        // ホーム画像
        CCMenuItemImage* menuItemHome = [CCMenuItemImage itemWithNormalImage:@"game_top_btn_home.png" selectedImage:nil target:self selector:@selector(onTop:)];
        CCMenu* menuHome = [CCMenu menuWithItems:menuItemHome, nil];
        menuHome.position       = CGPointMake(5, screenSize.height - 5);
        menuItemHome.anchorPoint    = CGPointMake(0, 1);
        [self addChild:menuHome z: 2];
        
        
        // Game Over
        // 今回の点数を表示させる
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* nowScore = [NSString stringWithFormat:@"%d Kg", [defaults integerForKey:@"NOW_SCORE"]];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:nowScore fontName:@"Marker Felt" fontSize:32];
        label.color = ccc3(66, 33, 00);
        label.position = ccp(screenSize.width / 2, screenSize.height * 0.7);
        label.anchorPoint = ccp(0.5f, 0.5f);
        [self addChild:label z:10];
        
        
        // uiview for twitter
        viewController = [[UIViewController alloc] init];
        
        
        // メニュー
        CCMenuItemImage* menuMain1 = [CCMenuItemImage itemWithNormalImage:@"gameover_btn_retry.png" selectedImage:nil target:self selector:@selector(onRestart:)];
        CCMenuItemImage* menuMain2 = [CCMenuItemImage itemWithNormalImage:@"gameover_btn_twitter.png" selectedImage:nil target:self selector:@selector(onTwitter:)];
        CCMenu *menu = [CCMenu menuWithItems:menuMain1, menuMain2, nil];
        menu.position = ccp(screenSize.width / 2, 100);
        [menu alignItemsVerticallyWithPadding: 20.0f];
        [self addChild:menu z: 11];
        
       
        self.isTouchEnabled = YES;
    }
    
    return self;
}

+(id) scene
{
    CCScene* scene = [CCScene node];
	GameOverScene* layer = [GameOverScene node];
	[scene addChild:layer];
	return scene;
}

#pragma mark -
#pragma mark メニュー押下時の処理
- (void) onTop:(id)sender
{
    [SceneManager goTopMenu:@"Fade"];
}
- (void) onRestart:(id)sender
{
    [SceneManager goGameStart:@"RotoZoom"];
}
- (void) onTwitter:(id)sender
{
    // Check if twitter is setup and reachable
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
        
        // ハイスコア取得
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        int highScore = [defaults integerForKey:@"NOW_SCORE"];
        
        // set initial text
        NSString* message = [NSString stringWithFormat:@"お世話になっております。中島清掃局です。%dKgのうんこを持ち帰りました。#中島清掃局", highScore];
        [tweetViewController setInitialText:message];
        
        // setup completion handler
        tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
            if(result == TWTweetComposeViewControllerResultDone) {
                // the user finished composing a tweet
            } 
            else if(result == TWTweetComposeViewControllerResultCancelled) {
                // the user cancelled composing a tweet
            }
            [viewController dismissViewControllerAnimated:YES completion:nil];
        };
        
        // present view controller
        [[CCDirector sharedDirector] addChildViewController:viewController];
        [viewController presentViewController:tweetViewController animated:YES completion:nil];
        
    }
    else {
        // Twitter account not configured, inform the user
        NSLog(@"NO TWITTER ACCOUNT CONFIGURED. DO SOMETHING");
        UIAlertView* alertView = 
        [[[UIAlertView alloc] initWithTitle: @"アカウント未登録" 
                                    message: @"Twitterでアカウントを登録してください！！" 
                                   delegate: self 
                          cancelButtonTitle: nil
                          otherButtonTitles: @"OK", nil] autorelease];
        [alertView show];
    }
}

@end
