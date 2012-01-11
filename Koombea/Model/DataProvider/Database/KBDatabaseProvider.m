//
//  KBDatabaseProvider.m
//  TrackTopia
//
//  Created by Oscar De Moya on 12/1/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#import "KBDatabaseProvider.h"
#import "RTCustom.h"

#define DB_FILE @"database.sqlite"

@implementation KBDatabaseProvider

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

+ (KBDatabaseProvider *)shared
{
    static KBDatabaseProvider *instance = nil;
    if (nil == instance) {
        instance = [[KBDatabaseProvider alloc] init];
    }
    return instance;
}

+ (KBModel *)model:(NSString *)className withManagedObject:(NSManagedObject *)object
{
    id ModelClass = NSClassFromString(className);
    KBModel *model = [ModelClass modelWithDictionary:nil];
    NSMutableArray *properties = [NSMutableArray arrayWithArray:[RTCustom rt_properties:[model class]]];
    [properties addObjectsFromArray:[RTCustom rt_properties:[model superclass]]];
    for (RTProperty *prop in properties) {
        NSUInteger end = [prop.typeEncoding length]-3;
        NSString *className = [prop.typeEncoding substringWithRange:NSMakeRange(2, end)];
        if ([className isEqualToString:[[NSArray class] description]]) {
            // TODO ?
        } else if ([className isEqualToString:[[NSDictionary class] description]]) {
            // TODO ?
        } else if (![prop.name isEqualToString:@"delegate"] && ![prop.name isEqualToString:@"id"]) {
            // if ([RTCustom rt_propertyForName:prop.name fromClass:[model class]]) {
            @try {
                id value = [object valueForKey:prop.name];
                [model setValue:value forKey:prop.name];
            }
            @catch (NSException *exception) {
                NSLog(EXCEPTION_MESSAGE, exception);
            }
        }
    }
    model.id = [KBDatabaseProvider primaryKey:object];
    return model;
}

+ (NSNumber *)primaryKey:(NSManagedObject *)object
{
    NSString *primaryKey = [[[object objectID] URIRepresentation] lastPathComponent];
    return [NSNumber numberWithInt:[[primaryKey substringFromIndex:1] intValue]];
}

+ (NSMutableArray *)fillManagedObject:(NSManagedObject *)object withModel:(KBModel *)model
{
    NSMutableArray *properties = [NSMutableArray arrayWithArray:[RTCustom rt_properties:[model class]]];
    [properties addObjectsFromArray:[RTCustom rt_properties:[model superclass]]];
    NSMutableArray *subModels = [[NSMutableArray alloc] init];
    for (RTProperty *prop in properties) {
        id value;
        if ((value = [model valueForKey:prop.name])) {
            if ([value isKindOfClass:[NSArray class]]) {
                for (KBModel *subModel in value) {
                    [subModels addObject:subModel];
                }
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                // TODO ?
            } else {
                // if ([RTCustom rt_propertyForName:prop.name fromClass:[model class]]) {
                @try {
                    [object setValue:value forKey:prop.name];
                }
                @catch (NSException *exception) {
                    NSLog(EXCEPTION_MESSAGE, exception);
                }
            }
        }
    }
    return subModels;
}

#pragma mark - DataProvider protocol methods

- (id)find:(KBFindType)findType model:(NSString *)className withParams:(id)params
{
    id ModelClass = NSClassFromString(className);
    
    // Retrieve parent data
    NSArray *fetchedObjects = [self fetchObjects:findType model:className withParams:params];
    NSMutableArray *fetchedModels = [NSMutableArray array];
    NSMutableArray *parentIds = [NSMutableArray array];
    for (NSManagedObject *object in fetchedObjects) {
        KBModel *model = [KBDatabaseProvider model:className withManagedObject:object];
        [parentIds addObject:model.id];
        [fetchedModels addObject:model];
    }
    
    NSDictionary *settings = [ModelClass modelSettings];
    NSNumber *recursive = nil;
    if ([params isKindOfClass:[NSDictionary class]]) {
        recursive = [params objectForKey:MODEL_RECURSIVE];
    }
    if (!recursive) {
        recursive = [settings objectForKey:MODEL_RECURSIVE];
    }
    
    if ([recursive intValue] > 0) {
        // Retrieve children data
        recursive = [NSNumber numberWithInt:([recursive intValue]-1)];
        NSDictionary *hasMany = [settings objectForKey:MODEL_HAS_MANY];
        NSString *foreignKeyName = [className foreignKeyString];
        NSMutableDictionary *allSubModels = [NSMutableDictionary dictionary];
        for (NSString *subClassName in [hasMany allKeys]) {
            // TODO: read foreign key name from plist
            NSDictionary *conditions = [NSDictionary dictionaryWithObject:parentIds forKey:foreignKeyName];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    conditions, MODEL_CONDITIONS, recursive, MODEL_RECURSIVE, nil];
            id SubModelClass = NSClassFromString(subClassName);
            NSArray *subModels = [[SubModelClass shared] find:KBFindAll withParams:params];
            [allSubModels setObject:subModels forKey:subClassName];
        }
        for (KBModel *model in fetchedModels) {
            for (NSString *subClassName in [hasMany allKeys]) {
                NSArray *subModels = [allSubModels objectForKey:subClassName];
                NSMutableArray *subModelsFiltered = [NSMutableArray array];
                for (KBModel *subModel in subModels) {
                    NSString *foreignKeyName = [className foreignKeyString];
                    if ([subModel valueForKey:foreignKeyName] == model.id) {
                        [subModelsFiltered addObject:subModel];
                    }
                }
                [model setValue:subModelsFiltered forKey:[subClassName propertyPluralizedString]];
            }
        }
    }
    
    if (findType == KBFindFirst) {
        if ([fetchedModels count] > 0) {
            return [fetchedModels objectAtIndex:0];
        } else {
            return nil;
        }
    } else {
        return fetchedModels;
    }
}

- (id)save:(KBModel *)model withParams:(id)params
{
    NSError *error = nil;
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSArray *objects;
    
    if ([model isNew]) {
        // Insert a new object
        modelName = [[model class] description];
        model.created_at = [NSDate date];
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:moc];
        objects = [NSArray arrayWithObject:object];
        
    } else {
        // Update existing objects
        if ([params isKindOfClass:[NSString class]]) {
            NSString *modelId = [NSString stringWithFormat:@"%@", model.id];
            objects = [self fetchObjects:KBFindFirst model:[[model class] description] withParams:modelId];
        } else {
            objects = [self fetchObjects:KBFindAll model:[[model class] description] withParams:params];
        }
    }
    
    for (NSManagedObject *object in objects) {
        model.updated_at = [NSDate date];
        /* NSArray *subModels = */[KBDatabaseProvider fillManagedObject:object withModel:model];
        if (![moc save:&error]) {
            NSLog(ERROR_DATABASE_PROVIDER_CREATE, error, [error userInfo]);
            return error;
        }
        
        /*
         // TODO: save sub models recursively
         NSNumber *primaryKey = [KBDatabaseProvider primaryKey:object];
         for (KBModel *subModel in subModels) {
         NSString *foreignKeyName = [NSString stringWithFormat:@"%@_id", [[[model class] description] lowercaseString]];
         [subModel setValue:primaryKey forKey:foreignKeyName];
         [self save:subModel withParams:params];
         }
        */
    }
    
    return error;
}

- (id)del:(NSString *)className withParams:(id)params
{
    NSArray *fetchedObjects = [self fetchObjects:KBFindAll model:className withParams:params];
    NSManagedObjectContext *moc = [self managedObjectContext];
    for (NSManagedObject *object in fetchedObjects) {
        [moc deleteObject:object];
    }
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(ERROR_DATABASE_PROVIDER_CREATE, error, [error userInfo]);
        return @"NO";
    } else {
        return @"YES";
    }
}

#pragma mark - Database provider methods

- (NSArray *)fetchObjects:(KBFindType)findType model:(NSString *)className withParams:(id)params
{
    NSError *error = nil;
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:className inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    if ([params isKindOfClass:[NSString class]]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %d)", @"_pk", [params intValue]];
        [request setPredicate:predicate];
        
    } else if ([params isKindOfClass:[NSDictionary class]]) {
        id conditions = [params objectForKey:MODEL_CONDITIONS];
        if(conditions) {
            NSMutableArray *predicates = [NSMutableArray array];
            for (NSString *condKey in [conditions allKeys]) {
                id condValue = [conditions objectForKey:condKey];
                if ([condValue isKindOfClass:[NSArray class]]) {
                    [predicates addObject:[NSPredicate predicateWithFormat:@"(%K IN %@)", condKey, condValue]];
                } else if ([condValue isKindOfClass:[NSDictionary class]]) {
                    
                } else if ([condValue isKindOfClass:[NSString class]]) {
                    [predicates addObject:[NSPredicate predicateWithFormat:@"(%K == %@)", condKey, condValue]];
                }
            }
            [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
        }
        NSArray *order = [params objectForKey:MODEL_ORDER];
        if(order) {
            NSMutableArray *sortDescriptors = [NSMutableArray array];
            for (NSDictionary *sort in order) {
                NSString *key = [sort objectForKey:MODEL_ATTRIBUTE];
                BOOL ascending = [[sort objectForKey:MODEL_ASCENDING] boolValue];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
                [sortDescriptors addObject:sortDescriptor];
            }
            [request setSortDescriptors:sortDescriptors];
        }
    }
    NSArray *fetchedObjects = [moc executeFetchRequest:request error:&error];
    if(error) NSLog(ERROR_DATABASE_PROVIDER_READ, error, [error userInfo]);
    return fetchedObjects;
}

#pragma mark -

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DB_FILE]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(ERROR_PERSISTENT_STORE, error, [error userInfo]);
    }    
	
    return persistentStoreCoordinator;
}

@end