
#import "NSDictionary+DC.h"
#import "NSArray+DC.h"

@implementation NSDictionary (DC)

- (NSDictionary *)dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";

    for (NSString *key in self) {
        id object = self[key];
        if (object == nul)
            replaced[key] = blank;
        else if ([object isKindOfClass:[NSDictionary class]])
            replaced[key] = [object dictionaryByReplacingNullsWithStrings];
        else if ([object isKindOfClass:[NSArray class]])
            replaced[key] = [object dictionaryByReplacingNullsWithStrings];
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}
@end
