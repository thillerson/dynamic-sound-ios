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
    
    // Thanks! https://gist.github.com/marlonSci5/6006700
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationSlide];
    }
    patch = [PdBase openFile:@"Keyboard.pd"
                        path:[[NSBundle mainBundle] resourcePath]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
