/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * Abtract Base class for various Core Data Entity Managers
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import "___FILEBASENAMEASIDENTIFIER___.h"
#include "TargetConditionals.h"

typedef void (^VoidBlockType)(void);

@interface ___FILEBASENAMEASIDENTIFIER___ ()
@property (nonatomic, strong, readwrite) NSObject <RLCoreDataEnvironmentProtocol> *environment;
@end

@implementation ___FILEBASENAMEASIDENTIFIER___
{
    NSString *_defaultEntityName;
}

#pragma mark ** Synthesis **

@synthesize environment = _environment;

#pragma mark ** Static Variables **

//*****************************************************************************
#pragma mark -
#pragma mark ** Instantiation **

- (id)init;
{
    NSAssert(NO, @"Should never get here");
    return nil;
}

- (id)initWithCoreDataEnvironment:(NSObject <RLCoreDataEnvironmentProtocol> *)environment;
{
    self = [super init];
    if (self)
    {
        NSAssert(environment, @"Environment must not be nil");
        self.environment = environment;
    }
    return self;
}

+ (RLBaseEntityManager *)manager;
{
    RLBaseEntityManager *manager = [[RLBaseEntityManager alloc] initWithCoreDataEnvironment:[RLCoreDataEnvironment singleton]];
    return manager;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** CoreDataManager Subclasses may override **

- (NSString *)defaultEntityName;
{
    // Subclasses may override this.
    
    // This method makes the assumption that your entity name (as defined in 
    // your .xcdatamodel file) is the the same as the name of this class, minus
    // the "Manager" suffix.
    // Example: [RLBookManager defaultEntityName] will return RLBook
    
    if (_defaultEntityName)
        return _defaultEntityName;
    
    _defaultEntityName = NSStringFromClass([self class]);
    
    //remove the "Manager"
    NSInteger suffixLength = [@"Manager" length];
    
    _defaultEntityName = [_defaultEntityName stringByReplacingCharactersInRange:NSMakeRange([_defaultEntityName length] - suffixLength, suffixLength)
                                                                     withString:@""];
    
    return _defaultEntityName;
}
- (NSArray *)defaultSortDescriptors;
{
    //Subclasses may override this.
    //Subclasses usually want to add sortDescriptors to the array returned by super
    
    //Example:
    //NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:CD_KEY_TS_ADD ascending:YES];
    //return [NSArray arrayWithObject:sorter];
    
    return [NSArray array];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Core Data Environment Convenience Methods **

- (NSError *)saveContextForContextKey:(NSString *)contextKey;
{
    return [self.environment saveContextForContextKey:contextKey];
}

- (void)inContextForKey:(NSString *)contextKey performBlock:(void (^)(NSString *innerContextKey))blockWithContextKey
{
    [self.environment inContextForKey:contextKey performBlock:blockWithContextKey];
}

- (void)inContextForKey:(NSString *)contextKey performBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey
{
    [self.environment inContextForKey:contextKey performBlockAndWait:blockWithContextKey];
}

// These four methods are the main mechanisms with with you should be interacting with Core Data.
- (void)inMainThreadContextPerformBlock:(void (^)(NSString *innerContextKey))blockWithContextKey;
{
    [self inContextForKey:RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY performBlock:blockWithContextKey];
}
- (void)inMainThreadContextPerformBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey;
{
    [self inContextForKey:RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY performBlockAndWait:blockWithContextKey];
}
- (void)inBackgroundContextPerformBlock:(void (^)(NSString *innerContextKey))blockWithContextKey;
{
    [self inContextForKey:RLCORE_DATA_BACKGROUND_CONTEXT_KEY performBlock:blockWithContextKey];
}
- (void)inBackgroundContextPerformBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey;
{
    [self inContextForKey:RLCORE_DATA_BACKGROUND_CONTEXT_KEY performBlockAndWait:blockWithContextKey];
}


//*****************************************************************************
#pragma mark -
#pragma mark ** NSManagedObjectID Methods **

- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID forContextKey:(NSString *)contextKey;
{
    return [self.environment objectForObjectID:objectID forContextKey:contextKey];
}
- (NSManagedObject *)objectForObjectIDString:(NSString *)objectIDString forContextKey:(NSString *)contextKey;
{
    return [self.environment objectForObjectIDString:objectIDString forContextKey:contextKey];
}
- (NSManagedObject *)convertManagedObjectOfUnknownContext:(NSManagedObject *)unknownContextManagedObject
                                             toContextKey:(NSString *)contextKey;
{
    return [self.environment convertManagedObjectOfUnknownContext:unknownContextManagedObject toContextKey:contextKey];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Utilities **

- (NSEntityDescription *)defaultEntityDescriptionForContextKey:(NSString *)contextKey;
{
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];

#if (TARGET_IPHONE_SIMULATOR)
    // For safety, do some validation here if we are in the simulator
    NSAssert(context, @"context must not be nil");
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [context persistentStoreCoordinator];
    NSAssert(persistentStoreCoordinator, @"persistentStoreCoordinator must not be nil");
    NSManagedObjectModel *managedObjectModel = [persistentStoreCoordinator managedObjectModel];
    NSAssert(managedObjectModel, @"managedObjectModel must not be nil");
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:self.defaultEntityName];
    NSAssert(entity, @"entityDescription must not be nil %@", self.defaultEntityName);
#endif

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:self.defaultEntityName 
                                                         inManagedObjectContext:context];
    
#if (TARGET_IPHONE_SIMULATOR)
    NSAssert(entityDescription, @"entityDescription must not be nil");
#endif

    return entityDescription;
}

+ (NSPredicate *)predicateWithAttributeName:(NSString *)attributeName value:(id)value;
{
    return [NSPredicate predicateWithFormat:@"%K == %@", attributeName, value];
}

- (NSFetchRequest *)defaultFetchRequestForContextKey:(NSString *)contextKey;
{
    return [self fetchRequestForPredicate:nil contextKey:contextKey];
}
- (NSFetchRequest *)fetchRequestForPredicate:(NSPredicate *)predicate
                                  contextKey:(NSString *)contextKey;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self defaultEntityDescriptionForContextKey:contextKey]];
    if (predicate)
        [fetchRequest setPredicate:predicate];
    if (self.defaultSortDescriptors)
        [fetchRequest setSortDescriptors:self.defaultSortDescriptors];
    return fetchRequest;
}

- (void)handleError:(NSError *)error forFetchRequest:(NSFetchRequest *)fetchRequest;
{
    //Custom error handling here...
    //feel free to log, assert or whatever.
    
    NSLog(@"\nerror:%@\nfetchRequest:%@", error, fetchRequest);
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Synchronous/blocking Core Data Primitive Actions **

- (id)insertNewObjectWithDefaultEntityForContextKey:(NSString *)contextKey;
{
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
    NSEntityDescription *entityDescription = [self defaultEntityDescriptionForContextKey:contextKey];
    
    NSManagedObject *newManagedObject = [[NSManagedObject alloc] initWithEntity:entityDescription
                                                 insertIntoManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    
    // added timestamp
    //[newManagedObject setValue:[NSDate date] forKey:CD_KEY_TS_ADD];
    // modified timestamp
    //[newManagedObject setValue:[NSDate date] forKey:CD_KEY_TS_MOD];
    
    return newManagedObject;
}

- (NSError *)deleteObject:(NSManagedObject *)managedObject contextKey:(NSString *)contextKey;
{
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
    
    [context deleteObject:managedObject];
    return nil;
}

/**
 * This makes the assumption that there is only one object with the actual value for the given key.
 */
- (NSManagedObject *)upsertObjectWithValue:(id)attributeValue
                          forAttributeName:(NSString *)attributeName
                                contextKey:(NSString *)contextKey;
{
    NSPredicate *predicate = [RLBaseEntityManager predicateWithAttributeName:attributeName value:attributeValue];
    NSManagedObject *coreDataObject = [self fetchOneWithPredicate:predicate contextKey:contextKey];
    
    if (coreDataObject == nil) {
        coreDataObject = [self insertNewObjectWithDefaultEntityForContextKey:contextKey];
        [coreDataObject setValue:attributeValue forKey:attributeName];
    }
    
    return coreDataObject;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Synchronous/blocking Core Data Results Count Actions Traditional **

- (NSUInteger)resultCountForFetchRequest:(NSFetchRequest *)fetchRequest
                              contextKey:(NSString *)contextKey;
{
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
    
    NSError *error = nil;
    NSUInteger result = [context countForFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        [self handleError:error forFetchRequest:fetchRequest];
        return NSNotFound;
    }
    
    return result;
}

- (NSUInteger)resultCountForContextKey:(NSString *)contextKey;
{
    return [self resultCountWithPredicate:nil contextKey:contextKey];
}

- (NSUInteger)resultCountWithPredicate:(NSPredicate *)predicate
                            contextKey:(NSString *)contextKey;
{
    NSFetchRequest *fetchRequest = [self fetchRequestForPredicate:predicate contextKey:contextKey];
    return [self resultCountForFetchRequest:fetchRequest
                                 contextKey:contextKey];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Synchronous/blocking Core Data Fetch Actions **

// Basic
- (NSArray *)fetchAllForFetchRequest:(NSFetchRequest *)fetchRequest
                          contextKey:(NSString *)contextKey;
{
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil || error)
    {
        [self handleError:error forFetchRequest:fetchRequest];
        return nil;
    }
    return fetchedObjects;
}

// Convenience
- (NSArray *)fetchAllForContextKey:(NSString *)contextKey;
{
    return [self fetchAllWithPredicate:nil
                            contextKey:contextKey];
}

- (NSArray *)fetchAllWithPredicate:(NSPredicate *)predicate
                        contextKey:(NSString *)contextKey;

{
    return [self fetchAllWithPredicate:predicate
                       sortDescriptors:nil
                            contextKey:contextKey];
}

- (NSArray *)fetchAllWithPredicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
                        contextKey:(NSString *)contextKey;
{
    return [self fetchAllWithPredicate:predicate
                       sortDescriptors:sortDescriptors
               prefetchedRelationships:nil
                            fetchLimit:0  // no limit
                            contextKey:contextKey];
}

- (NSArray *)fetchAllWithPredicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
           prefetchedRelationships:(NSArray *)relationshipKeys
                        fetchLimit:(NSUInteger)fetchLimit
                        contextKey:(NSString *)contextKey;
{
    NSFetchRequest *fetchRequest;
    if (predicate)
        fetchRequest = [self fetchRequestForPredicate:predicate contextKey:contextKey];
    else
        fetchRequest = [self defaultFetchRequestForContextKey:contextKey];
    
    if (sortDescriptors)
        [fetchRequest setSortDescriptors:sortDescriptors];
    if (relationshipKeys)
        [fetchRequest setRelationshipKeyPathsForPrefetching:relationshipKeys];
    if (fetchLimit)
        fetchRequest.fetchLimit = fetchLimit;
    
    return [self fetchAllForFetchRequest:fetchRequest
                              contextKey:contextKey];
}

- (NSArray *)fetchAllWithSortDescriptors:(NSArray *)sortDescriptors
                              contextKey:(NSString *)contextKey;
{
    return [self fetchAllWithPredicate:nil
                       sortDescriptors:sortDescriptors
                            contextKey:contextKey];
}

- (id)fetchOneWithPredicate:(NSPredicate *)predicate
                 contextKey:(NSString *)contextKey;
{
    NSFetchRequest *fetchRequest = [self fetchRequestForPredicate:predicate contextKey:contextKey];
    fetchRequest.fetchLimit = 1;
    NSArray *array = [self fetchAllForFetchRequest:fetchRequest
                                        contextKey:contextKey];
    
    if ([array count] == 0)
        return nil;
    return [array objectAtIndex:0];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** UI Objects **

#define CACHE_NAME NSStringFromClass([self class])
- (void)deleteFetchedResultsControllerCache;
{
    [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
}

- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                             contextKey:(NSString *)contextKey
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName;
{
    NSFetchedResultsController *newFetchedResultsController;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContextForContextKey:contextKey];
    newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                      managedObjectContext:managedObjectContext
                                                                        sectionNameKeyPath:sectionNameKeyPath
                                                                                 cacheName:cacheName];
    
    return newFetchedResultsController;    
}
    
- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                             contextKey:(NSString *)contextKey;
{
    return [self fetchedResultsControllerForFetchRequest:fetchRequest
                                              contextKey:contextKey
                                      sectionNameKeyPath:nil
                                               cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerForContextKey:(NSString *)contextKey;
{
    NSFetchRequest *fetchRequest = [self defaultFetchRequestForContextKey:contextKey];
    return [self fetchedResultsControllerForFetchRequest:fetchRequest
                                              contextKey:contextKey];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Core Data Environment Accesssors **

- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;
{
    return [self.environment managedObjectContextForContextKey:contextKey];
}

@end
