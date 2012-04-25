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

#import "RLCoreDataEnvironment.h"

#pragma mark ** Protocols & Declarations **

@interface ___FILEBASENAMEASIDENTIFIER___ : NSObject

#pragma mark ** Designated Initializers **
- (id)initWithCoreDataEnvironment:(NSObject <RLCoreDataEnvironmentProtocol> *)environment;
+ (RLBaseEntityManager *)manager; // Manager using default RLCoreDataEnvironment singleton

#pragma mark ** CoreDataManager Subclasses may override **
@property(nonatomic, strong, readonly) NSString *defaultEntityName;
@property(nonatomic, strong, readonly) NSArray *defaultSortDescriptors;

#pragma mark ** Core Data Environment Methods **
// These are primarily for the use of subclasses, and not intended for general use.
- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;
- (void)inContextForKey:(NSString *)contextKey performBlock:(void (^)(NSString *innerContextKey))blockWithContextKey;
- (void)inContextForKey:(NSString *)contextKey performBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey;

// These four methods are the main mechanisms with with you should be interacting with Core Data.
- (void)inMainThreadContextPerformBlock:(void (^)(NSString *innerContextKey))blockWithContextKey;
- (void)inMainThreadContextPerformBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey;
- (void)inBackgroundContextPerformBlock:(void (^)(NSString *innerContextKey))blockWithContextKey;
- (void)inBackgroundContextPerformBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey;

#pragma mark ** Core Data Actions ***

// As a general rule, if you are doing Core Data on the background or a user defined context, 
// It must be done withing onde of the xxxPerformBlock: or xxxPerformBlockAndWait argument blocks
//
// The main thread is a very special case, where you may use these methods safely as long as you
// guaruntee that you are on the main thread or main thread queue. 

#pragma mark ** NSManagedObjectID Convenience Methods **

- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID forContextKey:(NSString *)contextKey;
- (NSManagedObject *)objectForObjectIDString:(NSString *)objectIDString forContextKey:(NSString *)contextKey;
- (NSManagedObject *)convertManagedObjectOfUnknownContext:(NSManagedObject *)unknownContextManagedObject toContextKey:(NSString *)desiredContextKey;

#pragma mark ** Utilities **

- (NSError *)saveContextForContextKey:(NSString *)contextKey;
- (NSEntityDescription *)defaultEntityDescriptionForContextKey:(NSString *)contextKey;
+ (NSPredicate *)predicateWithAttributeName:(NSString *)attributeName value:(id)value;
- (NSFetchRequest *)defaultFetchRequestForContextKey:(NSString *)contextKey;
- (NSFetchRequest *)fetchRequestForPredicate:(NSPredicate *)predicate
                                  contextKey:(NSString *)contextKey;
- (void)handleError:(NSError *)error forFetchRequest:(NSFetchRequest *)fetchRequest;  // default implementation just logs the error.  Subclasses may override

#pragma mark ** Synchronous/blocking Core Data Primitive Actions **

// Basic
- (id)insertNewObjectWithDefaultEntityForContextKey:(NSString *)contextKey;
- (NSError *)deleteObject:(NSManagedObject *)managedObject
               contextKey:(NSString *)contextKey;

// Convenience
- (NSManagedObject *)upsertObjectWithValue:(id)attributeValue
                          forAttributeName:(NSString *)attributeName
                                contextKey:(NSString *)contextKey;

#pragma mark ** Synchronous/blocking Core Data Results Count Actions **

// Basic
- (NSUInteger)resultCountForFetchRequest:(NSFetchRequest *)fetchRequest
                              contextKey:(NSString *)contextKey;
// Convenience
- (NSUInteger)resultCountForContextKey:(NSString *)contextKey;
- (NSUInteger)resultCountWithPredicate:(NSPredicate *)predicate
                            contextKey:(NSString *)contextKey;

#pragma mark ** Synchronous/blocking Core Data Fetch Actions **

// Basic
- (NSArray *)fetchAllForFetchRequest:(NSFetchRequest *)fetchRequest
                          contextKey:(NSString *)contextKey;
// Convenience
- (NSArray *)fetchAllForContextKey:(NSString *)contextKey;
- (NSArray *)fetchAllWithPredicate:(NSPredicate *)predicate
                        contextKey:(NSString *)contextKey;
- (NSArray *)fetchAllWithPredicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
                        contextKey:(NSString *)contextKey;
- (NSArray *)fetchAllWithPredicate:(NSPredicate *)predicate
                   sortDescriptors:(NSArray *)sortDescriptors
           prefetchedRelationships:(NSArray *)relationshipKeys
                        fetchLimit:(NSUInteger)fetchLimit
                        contextKey:(NSString *)contextKey;

- (NSArray *)fetchAllWithSortDescriptors:(NSArray *)sortDescriptors
                              contextKey:(NSString *)contextKey;

- (id)fetchOneWithPredicate:(NSPredicate *)predicate
                 contextKey:(NSString *)contextKey;

#pragma mark ** UI Objects **

- (void)deleteFetchedResultsControllerCache;
- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                             contextKey:(NSString *)contextKey
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName;
- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                             contextKey:(NSString *)contextKey;
- (NSFetchedResultsController *)fetchedResultsControllerForContextKey:(NSString *)contextKey;

@end