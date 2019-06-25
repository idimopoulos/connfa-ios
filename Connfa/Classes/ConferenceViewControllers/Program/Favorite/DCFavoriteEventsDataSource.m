
#import "DCFavoriteEventsDataSource.h"
#import "DCDayEventsDataSource.h"
#import "DCMainProxy+Additions.h"
#import "DCSocialEvent+DC.h"

@class DCMainEvent, DCSocialEvent, DCBof;

@implementation DCFavoriteEventsDataSource

- (void)loadEvents:(BOOL)isFromPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self dataSourceStartUpdateEvents];
    dispatch_async(
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

                NSArray *eventsByTimeRange = [self favoriteEventsSource];

                dispatch_async(dispatch_get_main_queue(), ^{
                    //
                    __strong __typeof__(weakSelf) strongSelf = weakSelf;
                    strongSelf.eventsByTimeRange = eventsByTimeRange;
                    [strongSelf.tableView reloadData];

                    [weakSelf dataSourceEndUpdateEvents];

                    if (!isFromPullToRefresh && strongSelf.actualEventIndexPath) {
                        [strongSelf.tableView
                                scrollToRowAtIndexPath:strongSelf.actualEventIndexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:NO];
                    }
                });

            });
}
// kDCTimeslotKEY
// kDCTimeslotEventKEY

- (NSArray *)favoriteEventsSource {
    NSArray *eventClasses =
            @[[DCMainEvent class], [DCBof class], [DCSocialEvent class]];

    NSMutableArray *sections = [NSMutableArray array];
    for (Class class in eventClasses) {
        NSArray *uniqueTimeSlotForDay =
                [self uniqueTimeRangesForDay:self.selectedDay andEventClass:class];
        NSArray *eventsByTimeRange =
                [self eventsSortedByTimeRange:[self eventsForDay]
                          withUniqueTimeRange:uniqueTimeSlotForDay
                                        class:class];

        if ([eventsByTimeRange count]) {
            //[sections addObject:@{kDCTimeslotKEY : [self titleForClass:class]}];
            [sections addObjectsFromArray:eventsByTimeRange];
        }
    }

    NSArray *result = [self sortByTime:[NSArray arrayWithArray:sections]];

    return result;
}

- (NSArray *)sortByTime:(NSArray *)array {
    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DCTimeRange *objectOne = [obj1 valueForKey:@"timeslot_key"];
        DCTimeRange *objectTwo = [obj2 valueForKey:@"timeslot_key"];
        return [objectOne.from compare:objectTwo.from];
    }];

    return sortedArray;
}

- (NSString *)titleForSectionAtIdexPath:(NSInteger)section {
    if (section >= [self.eventsByTimeRange count]) {
        return nil;
    }
    NSDictionary *sectionsInfo = self.eventsByTimeRange[section];
    NSArray *events = sectionsInfo[kDCTimeslotEventKEY];
    return ![events count] ? sectionsInfo[kDCTimeslotKEY] : nil;
}

- (NSString *)titleForClass:(Class)class {
//  if ([NSStringFromClass(class)
//          isEqualToString:NSStringFromClass([DCBof class])]) {
//    return @"BoFs";
//  } else if ([NSStringFromClass(class)
//                 isEqualToString:NSStringFromClass([DCMainEvent class])]) {
//    return @"Sessions";
//  } else {
//    return @"Social Events";
//  }
    return @"";
}

- (void)reloadEvents:(BOOL)isFromPullToRefresh {
    [self loadEvents:isFromPullToRefresh];
}

- (NSArray *)eventsForDay {
    return [self.eventStrategy eventsForDay:self.selectedDay];
}

- (NSArray *)eventsForDay:(NSDate *)day andClass:(Class)eventClass {
    return [[DCMainProxy sharedProxy] eventsForDay:day
                                          forClass:eventClass
                                    sharedSchedule:self.eventStrategy.schedule
                                         predicate:self.eventStrategy.predicate];
}

- (NSArray *)uniqueTimeRangesForDay:(NSDate *)day
                      andEventClass:(Class)eventClass {
    return [[DCMainProxy sharedProxy]
            uniqueTimeRangesForDay:day
                          forClass:eventClass
                    sharedSchedule:self.eventStrategy.schedule
                         predicate:self.eventStrategy.predicate];
}

@end
