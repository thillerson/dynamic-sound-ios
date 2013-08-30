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
    [PdBase sendFloat:1 toReceiver:@"bullet"];
}

@end
