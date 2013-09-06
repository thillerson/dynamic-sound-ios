//
//  AppDelegate.h
//  Belt Commander
//
//  Created by Lucas Jordan on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "PdInterface.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property(nonatomic, strong) PdInterface *pdInterface;

@end
