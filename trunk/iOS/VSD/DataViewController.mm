//
//  DataViewController.m
//  VSD
//
//  Created by Natan Facchin on 5/31/14.
//  Copyright (c) 2014 nfsindustries. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

@synthesize audioController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUpAudio];
    
    stressTL = [[CATextLayer alloc] init];
    
    stressTL.backgroundColor = [UIColor orangeColor].CGColor;
    stressTL.cornerRadius = 0.0;
    stressTL.alignmentMode = kCAAlignmentCenter;
    stressTL.contentsScale = [[UIScreen mainScreen] scale];
    stressTL.frame = CGRectMake(00.0f, ((3 * self.view.bounds.size.height)/8), self.view.bounds.size.width,
                                self.view.bounds.size.height/4);
    
    [stressTL setString:@"\nprocessing..."];
    [self.view.layer addSublayer:stressTL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStressView:)
                                                 name:kStressProcessedNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [audioController stopIOUnit];
}

- (void)setUpAudio
{
    PermissionBlock permissionBlock = ^(BOOL granted) {
        if (granted)
        {
            audioController = [[AudioController alloc] init];
            [audioController startIOUnit];
        }
        else
        {
            UIAlertView *alertMic = [[UIAlertView alloc] initWithTitle: @"OPS :(" message: @"Please, enable Microphone access to use the app" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertMic show];
        }
    };
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)])
    {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:)
                                              withObject:permissionBlock];
    }
    else
    {
        audioController = [[AudioController alloc] init];
        [audioController startIOUnit];
    }
}

- (void)updateStressView:(NSNotification *)theNotification
{
    try {
        NSNumber *stressCoefNSNumber = [theNotification.userInfo objectForKey:kStressCoefVarName];
        float stressCoef = [stressCoefNSNumber floatValue];
        NSMutableString *stressMessage = [[NSMutableString alloc]initWithString:@"\n"];
        if (stressCoef >= 8 && stressCoef <= 12) {
            [stressMessage appendString:@"no stress"];
            stressTL.backgroundColor = [UIColor greenColor].CGColor;
        } else if(stressCoef < 8 && stressCoef >= 7){
            [stressMessage appendString:@"marginal stress"];
            stressTL.backgroundColor = [UIColor orangeColor].CGColor;
        } else if(stressCoef > 12 && stressCoef <= 13) {
            [stressMessage appendString:@"marginal stress"];
            stressTL.backgroundColor = [UIColor orangeColor].CGColor;
        } else {
            [stressMessage appendString:@"stress"];
            stressTL.backgroundColor = [UIColor redColor].CGColor;
        }
        [stressTL setString:stressMessage];
        [stressTL performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:0 waitUntilDone:NO];
        NSLog(@"%@", stressMessage);
    } catch (...) {
        NSLog(@"Could not read stress value from NSNotification");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end