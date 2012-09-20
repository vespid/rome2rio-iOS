#import <Foundation/Foundation.h>
#import "R2RPath.h"

@interface R2RPathEncoder : NSObject

+ (NSString *)encode:(R2RPath *)path;
+ (R2RPath *)decode:(NSString *)data;

@end