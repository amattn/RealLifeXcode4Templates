/******************************************************************************
 *  \file ___FILENAME___
 *  \author ___FULLUSERNAME___
 *  \date ___DATE___
 *  \class ___FILEBASENAMEASIDENTIFIER___
 *  \brief <#BRIEF#>
 *  \details from https://github.com/amattn/RealLifeXcode4Templates
 *  \abstract <#ABSTRACT#>
 *  \copyright Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 */

#import <CoreData/CoreData.h>
#import "RLCoreDataEnvironmentProtocol.h"

#pragma mark ** Constant Defines **

#define RLCORE_DATA_FILE_NAME @"com.___ORGANIZATIONNAME___.___FILEBASENAMEASIDENTIFIER___.sqlite"
#define RLCORE_DATA_MOMD_FILENAME @"___FILEBASENAMEASIDENTIFIER___"

#pragma mark ** Protocols & Declarations **

typedef void (^RLCoreDataErrorHandlerType)(NSError *error, SEL selectorWithError, BOOL isFatal);

@interface ___FILEBASENAMEASIDENTIFIER___ : NSObject <RLCoreDataEnvironmentProtocol>
{

}

#pragma mark ** Singleton Accessor **
+ (___FILEBASENAMEASIDENTIFIER___ *)singleton;

#pragma mark ** Properties & Accessors **
@property(strong, readonly) NSManagedObjectModel *managedObjectModel;
@property(strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// NSManagedObjectContexts
@property(strong, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;
@property(strong, readonly) NSManagedObjectContext *backgroundManagedObjectContext;
@property(strong, readonly) NSArray *allContextKeys;
- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;
- (void)removeManagedObjectContextForKey:(NSString *)contextKey;

// Error handling
@property(copy) RLCoreDataErrorHandlerType errorHandlerBlock;

//Typically only changed for test or debug...
@property(nonatomic, assign) BOOL isTestEnvironment;
@property(nonatomic, strong, readonly) NSString *storeType;    //Default is NSSQLiteStoreType.
@property(nonatomic, strong, readonly) NSBundle *modelBundle;  //Default is [NSBundle mainBundle]

#pragma mark ** Helpers **

//Get NSManagedObject from an NSManagedObjectID
- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID; // if on main thread, uses mainThreadManagedObjectContext, else defaultBackgroundManagedObjectContext
- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID
                         forContextKey:(NSString *)contextKey;

//get NSManagedObject form an objectIDString
- (NSManagedObject *)objectForObjectIDString:(NSString *)objectIDString; // if on main thread, uses mainThreadManagedObjectContext, else defaultBackgroundManagedObjectContext
- (NSManagedObject *)objectForObjectIDString:(NSString *)objectIDString
                               forContextKey:(NSString *)contextKey;

//Save the specified context
- (NSError *)saveContextForContextKey:(NSString *)contextKey;

//Delete all core data items
- (void)resetCoreData;

@end
