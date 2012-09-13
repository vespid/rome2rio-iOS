#import <Foundation/Foundation.h>
#import "R2RPosition.h"

@interface R2RPath : NSObject
{
	NSMutableArray *positions;
}

@property (strong, nonatomic, readonly) NSArray *positions;

-(void) addPosition:(R2RPosition *)position;

@end