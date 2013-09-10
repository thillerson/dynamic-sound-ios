//
//  PdInterface.m
//  Belt Commander
//
//  Created by Tony Hillerson on 8/29/13.
//
//

#import "PdInterface.h"
#import "PdDispatcher.h"
#import "PdBase.h"

@interface PdInterface () {
    void *patch;
}

@property(nonatomic,strong) PdDispatcher *pdDispatcher;

@end

@implementation PdInterface

- (id) init {
    self = [super init];
    
    if (self) {
        self.pdDispatcher = [[PdDispatcher alloc] init];
        [PdBase setDelegate:self.pdDispatcher];
        patch = [PdBase openFile:@"BeltCommanderPatch.pd"
                            path:[[NSBundle mainBundle] resourcePath]];
    }
    
    return self;
}

- (void) bullet {
    [PdBase sendList:@[@25, @200] toReceiver:@"bullet"];
}

- (void) asteroidHit {
    [PdBase sendList:@[@100, @100] toReceiver:@"asteroid"];
}

- (void) shipHit {
    [PdBase sendList:@[@1000, @50] toReceiver:@"ship"];
}

- (void) thruster:(BOOL)on {
    int value = (on) ? 1 : 0;
    [PdBase sendFloat:value toReceiver:@"thruster"];
}

@end
