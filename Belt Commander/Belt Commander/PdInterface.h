//
//  PdInterface.h
//  Belt Commander
//
//  Created by Tony Hillerson on 8/29/13.
//
//

#import <Foundation/Foundation.h>

@interface PdInterface : NSObject

- (void) bullet;
- (void) asteroidHit;
- (void) shipHit;
- (void) thruster:(BOOL)on;

@end
