//
//  ViewController.m
//  BulletScreen
//
//  Created by horry on 15/8/15.
//  Copyright (c) 2015年 ___horryBear___. All rights reserved.
//

#import "ViewController.h"
#import "BulletScreenView.h"
#import "BulletString.h"
#define SCREEN_HEIGHT		[UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITextFieldDelegate> {
	UITextField *bulletText;
	BulletScreenView *bulletScreen;
	BOOL hidden;
	BOOL play;
	UIButton *hideButton;
	UIButton *playButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	bulletScreen = [[BulletScreenView alloc] initWithFrame:self.view.bounds];
	bulletScreen.topLimit = 20;
	bulletScreen.bottomLimit = 300;
	[self.view addSubview:bulletScreen];
	
	NSMutableArray *bulletStringArray = [NSMutableArray new];
	for (int i = 0; i < 1000; i ++) {
		BulletString *bulletString = [[BulletString alloc] init];
		if (i % 2 == 0) {
			bulletString.string = @"哈哈";
		} else if (i % 3 == 0) {
			bulletString.string = @"hehe";
		} else if (i % 7 == 0) {
			bulletString.string = @"哔哩哔哩";
		}
		bulletString.timeOffset = arc4random() % 60;
		[bulletStringArray addObject:bulletString];
	}
	bulletScreen.textArray = bulletStringArray;
	
	bulletText = [[UITextField alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 100, 120, 30)];
	bulletText.backgroundColor = [UIColor whiteColor];
	bulletText.delegate = self;
	[self.view addSubview:bulletText];
	
	UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(140, SCREEN_HEIGHT - 100, 50, 30)];
	[sendButton setTitle:@"send" forState:UIControlStateNormal];
	[sendButton addTarget:self action:@selector(sendBullet:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:sendButton];
	
	hideButton = [[UIButton alloc] initWithFrame:CGRectMake(190, SCREEN_HEIGHT - 100, 50, 30)];
	[hideButton setTitle:@"hide" forState:UIControlStateNormal];
	[hideButton addTarget:self action:@selector(hideBullet:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:hideButton];
	
	playButton = [[UIButton alloc] initWithFrame:CGRectMake(140, SCREEN_HEIGHT - 50, 50, 30)];
	[playButton setTitle:@"play" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:playButton];
	
	UIButton *stopButton = [[UIButton alloc] initWithFrame:CGRectMake(190, SCREEN_HEIGHT - 50, 50, 30)];
	[stopButton setTitle:@"stop" forState:UIControlStateNormal];
	[stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopButton];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self sendBullet:nil];
	return YES;
}

- (void)sendBullet:(id)sender {
	[bulletScreen addBullet:bulletText.text color:[UIColor redColor]];
	bulletText.text = nil;
}

- (void)hideBullet:(id)sender {
	hidden = !hidden;
	[bulletScreen setHidden:hidden];
	
	if (hidden) {
		[hideButton setTitle:@"show" forState:UIControlStateNormal];
	} else {
		[hideButton setTitle:@"hide" forState:UIControlStateNormal];
	}
}

- (void)play:(id)sender {
	play = !play;
	if (play) {
		[playButton setTitle:@"pause" forState:UIControlStateNormal];
		[bulletScreen play];
	} else {
		[playButton setTitle:@"play" forState:UIControlStateNormal];
		[bulletScreen pause];
	}
}

- (void)stop:(id)sender {
	play = NO;
	[playButton setTitle:@"play" forState:UIControlStateNormal];
	[bulletScreen pause];
	[bulletScreen stop];
}

@end
