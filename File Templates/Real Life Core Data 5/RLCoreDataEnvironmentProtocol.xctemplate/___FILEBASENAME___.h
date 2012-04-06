/******************************************************************************
 *  \file ___FILENAME___
 *  \author ___FULLUSERNAME___
 *  \date ___DATE___
 *  \protocol ___FILEBASENAMEASIDENTIFIER___
 *  \brief <#BRIEF#>
 *  \details from https://github.com/amattn/RealLifeXcode4Templates
 *  \abstract <#ABSTRACT#> 
 *  \copyright Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
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

#pragma mark ** Properties **

@property(retain, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property(retain, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark ** Methods **

- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;
- (NSError *)saveContextForContextKey:(NSString *)contextKey;

@end
