//
//  DCType+CoreDataProperties.h
//  Connfa
//
//  Created by Oleh Kurnenkov on 5/4/17.
//  Copyright © 2017 Lemberg Solution. All rights reserved.
//

#import "DCType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DCType (CoreDataProperties)

+ (NSFetchRequest<DCType *> *)fetchRequest;

@property(nullable, nonatomic, copy) NSString *name;
@property(nullable, nonatomic, copy) NSNumber *order;
@property(nullable, nonatomic, copy) NSString *typeIcon;
@property(nullable, nonatomic, copy) NSNumber *typeID;
@property(nullable, nonatomic, retain) NSSet<DCEvent *> *events;

@end

@interface DCType (CoreDataGeneratedAccessors)

- (void)addEventsObject:(DCEvent *)value;

- (void)removeEventsObject:(DCEvent *)value;

- (void)addEvents:(NSSet<DCEvent *> *)values;

- (void)removeEvents:(NSSet<DCEvent *> *)values;

@end

NS_ASSUME_NONNULL_END
