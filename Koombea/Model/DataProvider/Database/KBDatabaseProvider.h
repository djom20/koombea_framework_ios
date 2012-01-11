//
//  KBDatabaseProvider.h
//  TrackTopia
//
//  Created by Oscar De Moya on 12/1/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBDataProvider.h"

@interface KBDatabaseProvider : KBDataProvider<NSFetchedResultsControllerDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (KBDatabaseProvider *)shared;
+ (KBModel *)model:(NSString *)className withManagedObject:(NSManagedObject *)object;
+ (NSNumber *)primaryKey:(NSManagedObject *)object;
+ (NSMutableArray *)fillManagedObject:(NSManagedObject *)object withModel:(KBModel *)model;
- (NSArray *)fetchObjects:(KBFindType)findType model:(NSString *)className withParams:(id)params;

@end
