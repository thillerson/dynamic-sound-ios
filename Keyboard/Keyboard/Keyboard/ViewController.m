//
//  ViewController.m
//  Keyboard
//
//  Created by Tony Hillerson on 9/5/13.
//  Copyright (c) 2013 Programming Sound. All rights reserved.
//

#import "ViewController.h"
#import "PdBase.h"

@interface ViewController () {
    void *patch;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    patch = [PdBase openFile:@"Keyboard.pd"
                        path:[[NSBundle mainBundle] resourcePath]];
}

- (IBAction)keyDown:(id)sender {
    UIView *sendingView = (UIView *)sender;
    int tag = [sendingView tag];
    [PdBase sendFloat:tag toReceiver:@"midinote"];
    [PdBase sendFloat:1.  toReceiver:@"gate"];
}

- (IBAction)keyUp:(id)sender {
    [PdBase sendFloat:0.  toReceiver:@"gate"];
}

@end
