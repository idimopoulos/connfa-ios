
#import <Foundation/Foundation.h>

@interface NSDate (DC)

+ (NSDate *)fabricateWithEventString:(NSString *)string;

+ (BOOL)dc_isDateInToday:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)formattedDate format:(NSString *)dateFormat;

- (NSString *)dateToStringWithFormat:(NSString *)dateFormat;

+ (float)hoursFromDate:(NSDate *)date;

+ (float)currentHour;

+ (NSString *)currentDateFormat;

+ (BOOL)is24hourFormat;

- (NSDate *)dateWithoutTime;
@end
