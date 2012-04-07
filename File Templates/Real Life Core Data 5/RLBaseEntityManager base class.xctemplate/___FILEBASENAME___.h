/******************************************************************************
 *  \file RLCoreDataObjectManager.h
 *  \author ___FULLUSERNAME___
 *  \date ___DATE___
 *  \class ___FILEBASENAMEASIDENTIFIER___
 *  \brief Abtract Base class for the various Core Data Entity Managers
 *  \details from https://github.com/amattn/RealLifeXcode4Templates
 *
 *  \abstract Abtract Base class for the various Core Data Entity Managers 
 *  \copyright Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
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

#pragma mark ** Core Data Environment Properties & Accessors **
- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;

#pragma mark ** Utilities **

- (NSError *)saveContextForContextKey:(NSString *)contextKey;
- (NSEntityDescription *)defaultEntityDescriptionForContextKey:(NSString *)contextKey;
+ (NSPredicate *)predicateWithAttributeName:(NSString *)attributeName value:(id)value;
- (NSFetchRequest *)defaultFetchRequestForContextKey:(NSString *)contextKey;
- (NSFetchRequest *)fetchRequestForPredicate:(NSPredicate *)predicate
                                  contextKey:(NSString *)contextKey;
- (void)handleError:(NSError *)error forFetchRequest:(NSFetchRequest *)fetchRequest;  // default implementation just logs the error.  Subclasses may override

#pragma mark ** Asynchronous Core Data Primitive Actions **

- (void)insertNewObjectWithDefaultEntityForContextKey:(NSString *)contextKey
                                    completionHandler:(void (^)(id newObject))completionHandler;
- (void)deleteObject:(NSManagedObject *)managedObject
          contextKey:(NSString *)contextKey
        errorHandler:(void (^)(NSError *error))errorHandler;

#pragma mark ** Asynchronous Core Data Results Count Actions **

// Basic
- (void)resultCountForFetchRequest:(NSFetchRequest *)fetchRequest
                        contextKey:(NSString *)contextKey
                     resultHandler:(void (^)(NSUInteger count))resultHandler;

// Convenience
- (void)resultCountForContextKey:(NSString *)contextKey
                   resultHandler:(void (^)(NSUInteger count))resultHandler;
- (void)resultCountWithPredicate:(NSPredicate *)predicate
                      contextKey:(NSString *)contextKey
                   resultHandler:(void (^)(NSUInteger count))resultHandler;

#pragma mark ** Asynchronous Core Data Fetch Actions **

// Basic
- (void)fetchAllForFetchRequest:(NSFetchRequest *)fetchRequest
                     contextKey:(NSString *)contextKey
                  resultHandler:(void (^)(NSArray *fetchedObjects))resultHandler;

// Convenience
- (void)fetchAllForContextKey:(NSString *)contextKey
                resultHandler:(void (^)(NSArray *fetchedObjects))resultHandler;
- (void)fetchAllWithPredicate:(NSPredicate *)predicate
                   contextKey:(NSString *)contextKey
                resultHandler:(void (^)(NSArray *fetchedObjects))resultHandler;
- (void)fetchAllWithPredicate:(NSPredicate *)predicate
              sortDescriptors:(NSArray *)sortDescriptors
                   contextKey:(NSString *)contextKey
                resultHandler:(void (^)(NSArray *fetchedObjects))resultHandler;
- (void)fetchAllWithPredicate:(NSPredicate *)predicate
              sortDescriptors:(NSArray *)sortDescriptors
      prefetchedRelationships:(NSArray *)relationshipKeys
                   fetchLimit:(NSUInteger)fetchLimit
                   contextKey:(NSString *)contextKey
                resultHandler:(void (^)(NSArray *fetchedObjects))resultHandler;
- (void)fetchAllWithSortDescriptors:(NSArray *)sortDescriptors
                         contextKey:(NSString *)contextKey
                      resultHandler:(void (^)(NSArray *fetchedObjects))resultHandler;

- (void)fetchOneWithPredicate:(NSPredicate *)predicate
                   contextKey:(NSString *)contextKey
                resultHandler:(void (^)(id fetchedObject))resultHandler;

#pragma mark ** Synchronous/blocking Core Data Primitive Actions **

- (id)insertNewObjectWithDefaultEntityForContextKey:(NSString *)contextKey;
- (NSError *)deleteObject:(NSManagedObject *)managedObject
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
                                                             contextKey:(NSString *)contextKey
                                                              cacheName:(NSString *)cacheName;
- (NSFetchedResultsController *)fetchedResultsControllerForFetchRequest:(NSFetchRequest *)fetchRequest
                                                             contextKey:(NSString *)contextKey;
- (NSFetchedResultsController *)fetchedResultsControllerForContextKey:(NSString *)contextKey;

@end