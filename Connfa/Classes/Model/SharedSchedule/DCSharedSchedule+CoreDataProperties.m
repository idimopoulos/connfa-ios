//
//  DCSharedSchedule+CoreDataProperties.m
//  Connfa
//
//  Created by Oleh Kurnenkov on 5/4/17.
//  Copyright © 2017 Lemberg Solution. All rights reserved.
//

#import "DCSharedSchedule+CoreDataProperties.h"

@implementation DCSharedSchedule (CoreDataProperties)

+ (NSFetchRequest<DCSharedSchedule *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"DCSharedSchedule"];
}

@dynamic name;
@dynamic scheduleId;
@dynamic isMySchedule;
@dynamic events;

@end
