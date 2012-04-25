/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark ** Constant Defines **

// I'm not terribly happy with the use of defines here, but it seems the best way to work with the Xcode template system...
#define RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY @"RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY"
#define RLCORE_DATA_BACKGROUND_CONTEXT_KEY @"RLCORE_DATA_BACKGROUND_CONTEXT_KEY"

#pragma mark -
#pragma mark ** RLCoreDataEnvironmentProtocol **
@protocol RLCoreDataEnvironmentProtocol <NSObject>

#pragma mark ** Accessors **

@property(retain, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property(retain, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;

#pragma mark ** Primitive Actions **

- (void)inContextForKey:(NSString *)contextKey performBlock:(void (^)(NSString *innerContextKey))blockWithContextKey;
- (void)inContextForKey:(NSString *)contextKey performBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey;
- (NSError *)saveContextForContextKey:(NSString *)contextKey;

#pragma mark ** NSManagedObject Actions **

- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID forContextKey:(NSString *)contextKey;
- (NSManagedObject *)objectForObjectIDString:(NSString *)objectIDString forContextKey:(NSString *)contextKey;
- (NSManagedObject *)convertManagedObjectOfUnknownContext:(NSManagedObject *)unknownContextManagedObject toContextKey:(NSString *)contextKey;

@end
