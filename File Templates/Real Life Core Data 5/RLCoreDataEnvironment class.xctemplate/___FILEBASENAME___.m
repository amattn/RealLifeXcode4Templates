/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import "___FILEBASENAME___.h"
#include "TargetConditionals.h"

#define RLQUICK_ERROR(error_code, error_description) [NSError errorWithDomain:NSStringFromClass([self class]) code:error_code userInfo:[NSDictionary dictionaryWithObject:error_description forKey:NSLocalizedDescriptionKey]];

@interface ___FILEBASENAMEASIDENTIFIER___ ()
@property (strong, readonly) NSMutableDictionary *managedObjectContextHash;
@property (nonatomic, strong, readwrite) NSString *storeType;
@property (nonatomic, strong, readwrite) NSBundle *modelBundle;
@property (nonatomic, strong, readwrite) NSDate *lastResetToken;
@end

@implementation ___FILEBASENAMEASIDENTIFIER___

@synthesize managedObjectContextHash = _managedObjectContextHash;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize errorHandlerBlock = _errorHandlerBlock;
@synthesize storeType = _storeType;
@synthesize modelBundle = _modelBundle;
@synthesize lastResetToken = _lastResetToken;
@synthesize isTestEnvironment = _isTestEnvironment;

#pragma mark ** Singleton **

+ (___FILEBASENAMEASIDENTIFIER___ *)singleton;
{
    static ___FILEBASENAMEASIDENTIFIER___ *__sharedCoreDataEnvironment = nil;
    static dispatch_once_t __singletonCreationToken;

    void (^onlyOnceBlock)(void) = ^
    {
        __sharedCoreDataEnvironment = [[self alloc] init];
    };

    dispatch_once(&__singletonCreationToken, onlyOnceBlock);
    return __sharedCoreDataEnvironment;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecyle Methods **

- (id)init
{
    self = [super init];
    if (self)
    {
        __weak id weakSelf = self;

        //simple default error handler
        self.errorHandlerBlock = ^(NSError *error, SEL selectorWithError, BOOL isFatal)
        {
            __strong id strongSelf = weakSelf;

            // typically, errors fall into one of two classes, fatal and non-fatal.
            NSLog(@"environment %@", strongSelf);
            NSLog(@"selectorWithError %@", NSStringFromSelector(selectorWithError));
            NSLog(@"error %@", error);
            
            if (isFatal)
            {
                
                NSString *desc = [NSString stringWithFormat:@"FATAL ___FILEBASENAMEASIDENTIFIER___ ERROR: %@", error];
                
                [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd
                                                                    object:strongSelf
                                                                      file:[NSString stringWithUTF8String:__FILE__]
                                                                lineNumber:__LINE__
                                                               description:desc];

                abort();
                /*
                 Replace this implementation with code to handle the error appropriately.

                 abort() causes the application to generate a crash log and terminate.
                 NSAssert() will trigger an assert and bring up the debugger in debug mode, 
                 or just crash otherwise.

                 You should not use this function in a shipping application, although it
                 may be useful during development. If it is not possible to recover
                 from the error, display an alert panel that instructs the user to quit
                 the application by pressing the Home button.
                 */
            }
        };
    }
    return self;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Filesystem Utilities **

/*!
    @method     persistentStoreDirectory
    @abstract   Convenience method to directory where the core data DB is stored
    @result     Path to directory as a string
*/
- (NSString *)persistentStoreDirectory;
{
    //A good default is the user's documents directory.
    //Feel free to customize here.
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Helpers **

- (NSManagedObject *)objectForObjectID:(NSManagedObjectID *)objectID
                         forContextKey:(NSString *)contextKey;
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContextForContextKey:contextKey];
    NSManagedObject *managedObject = [managedObjectContext existingObjectWithID:objectID
                                                                          error:&error];
    if (error)
    {
        self.errorHandlerBlock(error, _cmd, NO);
        return nil;
    }
    return managedObject;
}

/*!
    @method     objectForObjectIDString:
    @abstract   Convenience method to get an NSManagedObject from its ID
    @discussion CoreData ManagedObjectContext's aren't truly thread-safe.  If passing
                CoreData objects between threads, you must only pass the ID and
                not the object itself.
    @param      objectIDString String representation of an NSManagedObjectID
    @result     NSManagedObject for the specified objectIDString
*/
- (NSManagedObject *)objectForObjectIDString:(NSString *)objectIDString
                               forContextKey:(NSString *)contextKey;
{
    NSURL *url = [NSURL URLWithString:objectIDString];
    if ([[url scheme] isEqualToString:@"x-coredata"])
    {
        NSManagedObjectID *objectID = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
        return [self objectForObjectID:objectID forContextKey:contextKey];
    }
    else
    {
        NSString *errorDescription = [NSString stringWithFormat:@"Could not get object for ObjectIDString %@ in %@", objectIDString, NSStringFromSelector(_cmd)];
        NSError *error = RLQUICK_ERROR(23384, errorDescription); //random, arbitrary error code.
        self.errorHandlerBlock(error, _cmd, NO);
    }
    return nil;
}

/*
 * If you try to use a given NSManagedObject from context A, with 
 * an NSManagedObject of context B (such as setting relationships) it will 
 * crash.
 * This method will convert the given NSManagedObject to the approptiate
 * context if necessary.
 */
- (NSManagedObject *)convertManagedObjectOfUnknownContext:(NSManagedObject *)unknownContextManagedObject
                                             toContextKey:(NSString *)desiredContextKey;
{
    NSManagedObjectContext *desiredContext = [self managedObjectContextForContextKey:desiredContextKey];

    // if the context matches, nothing to be done.  We're good!
    if ([unknownContextManagedObject.managedObjectContext isEqual:desiredContext])
        return unknownContextManagedObject;
    
    NSManagedObjectID *managedObjectID = [unknownContextManagedObject objectID];
    return [self objectForObjectID:managedObjectID forContextKey:desiredContextKey];
}


//*****************************************************************************
#pragma mark -
#pragma mark ** Save & Reset **

/*!
    @method     saveContextForContextKey:
    @abstract   Save the specified context
    @discussion 
    @param      contextKey 
    @result     nil on success, NSError on failure
*/
- (NSError *)saveContextForContextKey:(NSString *)contextKey;
{
    __autoreleasing NSError *error = nil;
    
    // Unfortunately, one big global lock is the safest way to save Core Data.
    // If your saves are taking too long, it's probably because you are saving 
    // one big huge data set.  Consider breaking it up into smaller saves if 
    // possible, especially in the background.

    @synchronized(self) {
        [self.persistentStoreCoordinator lock];
        NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
        [context save:&error];
        [self.persistentStoreCoordinator unlock];

        if (error)
            self.errorHandlerBlock(error, _cmd, YES);  // errors here are fatal.
        
        // push the changes up to the parent, so that other children contextes will see them.
        NSManagedObjectContext *parentContext = context.parentContext;
        if (parentContext)
        {
            void (^parentSaveBlock)(void) = ^{
                NSError *parentError = nil;
                [self.persistentStoreCoordinator lock];
                [parentContext save:&parentError];
                [self.persistentStoreCoordinator unlock];
                if (parentError)
                    self.errorHandlerBlock(parentError, _cmd, YES);
            };
            [parentContext performBlock:parentSaveBlock];   
        }
    }

    return error;
}


// Reset related creation tokens
// Normally these are embedded in the lazy loading accessors, but as a very special case,
// we make these available strictly for the use of our reset methods
static dispatch_once_t __persistentStoreCoordinatorCreationToken;
static dispatch_once_t __managedObjectModelCreationToken;
static dispatch_once_t __managedObjectContextHashCreationToken;

/*!
    @method     resetCoreData
    @abstract   Delete all core data items
    @discussion Primarily used for testing.  If you choose to use this in production, please be very aware of it's limitations.  
                If you have operations in flight (say in a network callback) the behavior is undefined.
*/
- (void)resetCoreData;
{
    @synchronized(self)
    {
        self.lastResetToken = [NSDate date];
        
        _managedObjectModel = nil;
        __managedObjectModelCreationToken = 0; // setting creation tokens to zero is either genius or terrible hack to allow us to perform dispatch_once more than once.

        // if there are any performBlock: operations in flight we need to keep our contexts around just a little bit longer so they can safely exit
        // be aware, that sometimes, Core Data will launch performBlock operations internally in some cases.
        __autoreleasing NSMutableDictionary *justALittleBitLonger = _managedObjectContextHash;
        [justALittleBitLonger self]; // appease the compiler
        _managedObjectContextHash = nil;
        __managedObjectContextHashCreationToken = 0;
        
        NSArray *stores = [_persistentStoreCoordinator persistentStores];
        for (NSPersistentStore *store in stores)
        {
            [_persistentStoreCoordinator removePersistentStore:store error:nil];
            if ([self.storeType isEqualToString:NSInMemoryStoreType] == NO) {
                [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
            }
        }
        
        _persistentStoreCoordinator = nil;
        __persistentStoreCoordinatorCreationToken = 0;
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Primitive Block Based Actions **

/* 
 * These methods are used to safely perform actions in a given context.
 * Any Core Data operations performed on the background or user created
 * contexts must use these performBlock warppers
 *
 */

- (void)inContextForKey:(NSString *)contextKey performBlock:(void (^)(NSString *innerContextKey))blockWithContextKey
{
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
    [context performBlock:^{
        blockWithContextKey(contextKey);
    }];
}

- (void)inContextForKey:(NSString *)contextKey performBlockAndWait:(void (^)(NSString *innerContextKey))blockWithContextKey
{
    NSManagedObjectContext *context = [self managedObjectContextForContextKey:contextKey];
    [context performBlockAndWait:^{
        blockWithContextKey(contextKey);
    }];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Core Data Notifications **

/*!
 @method        handleManagedObjectContextDidSave:
 @abstract  updated all contexts when a context performs a save operation
 @discussion Changes to ManagedObjectContext happen in isolation.  If a context performs a save,
 the best thing to do is notify _all_ other contexts about the change.
 This method does exactly that via the built-in convience method
 mergeChangesFromContextDidSaveNotification
 @param     notification
 */
- (void)handleManagedObjectContextDidSave:(NSNotification *)notification;
{
    NSManagedObjectContext *notificationFromContext = [notification object];
    
#if (TARGET_IPHONE_SIMULATOR)
    NSAssert([notificationFromContext isKindOfClass:[NSManagedObjectContext class]], @"%@: unexpected class in notification object", NSStringFromSelector(_cmd));
#endif
    
    //Here if a certain context send a didSave notification, we have to notify all other context of the changes.
    
    for (id key in self.allContextKeys)
    {
        NSManagedObjectContext *contextToUpdate = [self.managedObjectContextHash objectForKey:key];
        
        //we don't need to update the context that sends the update...
        if (notificationFromContext != contextToUpdate)
        {
            NSDate *currentResetToken = self.lastResetToken;
            [contextToUpdate performBlock:^{
                // we only want to merge if we have NOT reset this environment.
                if (currentResetToken == self.lastResetToken) {
                    [contextToUpdate mergeChangesFromContextDidSaveNotification:notification];
                }
            }];
        }
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark ** ManagedObjectContext Methods **

- (NSManagedObjectContext *)mainThreadManagedObjectContext;
{
    return [self managedObjectContextForContextKey:RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY];
}

- (NSArray *)allContextKeys;
{
    return [self.managedObjectContextHash allKeys];
}

- (NSManagedObjectContext *)managedObjectContextForContextKey:(NSString *)contextKey;
{
    @synchronized(self)
    {
        // First things first:
        NSAssert(self.managedObjectContextHash != nil, @"\n\n\n\nself.managedObjectContextHash cannot be nil!!!\n\n\n\n");

        NSString *safeContextKey = contextKey;
        //If contectKey == nil, use one of the default contexts
        if (safeContextKey == nil)
        {
            if (dispatch_get_main_queue() == dispatch_get_current_queue())
                safeContextKey = RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY;
            else
                safeContextKey = RLCORE_DATA_BACKGROUND_CONTEXT_KEY;
        }
    
        NSManagedObjectContext *managedObjectContext = [self.managedObjectContextHash objectForKey:safeContextKey];
        
        // if the object exists, just return it.  we're done.
        if (managedObjectContext)
            return managedObjectContext;
        
            // doesn't seem to exist, let's make a new managedObjectContext
            NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
            
            if (coordinator != nil)
            {
                if ([safeContextKey isEqualToString:RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY])
                    managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
                else
                    managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                
                managedObjectContext.persistentStoreCoordinator = coordinator;
                [self.managedObjectContextHash setObject:managedObjectContext 
                                                  forKey:safeContextKey];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(handleManagedObjectContextDidSave:)
                                                             name:NSManagedObjectContextDidSaveNotification
                                                           object:managedObjectContext];
            return managedObjectContext;
        }
    }    
        
    // oops, something went terribly wrong.
    return nil;
}

- (void)removeManagedObjectContextForKey:(NSString *)contextKey;
{
    // we disallow removal of the two built-in contexts
    if ([contextKey isEqualToString:RLCORE_DATA_MAIN_THREAD_CONTEXT_KEY]
        || [contextKey isEqualToString:RLCORE_DATA_BACKGROUND_CONTEXT_KEY])
    {
        NSString *errorDescription = [NSString stringWithFormat:@"Attempting to remove built in managed object context"];
        NSError *error = RLQUICK_ERROR(3401610958, errorDescription); //random, arbitrary error code.
        self.errorHandlerBlock(error, _cmd, NO); // NO is for non-fatal error

        return;
    }
    
    @synchronized(self) {
        NSManagedObjectContext *objectToRemove = [self.managedObjectContextHash objectForKey:contextKey];
        if (objectToRemove == nil)
        {
            NSString *errorDescription = [NSString stringWithFormat:@"Key not found (%@) while attempting to remove managed object context", contextKey];
            NSError *error = RLQUICK_ERROR(1230159715, errorDescription); //random, arbitrary error code.
            self.errorHandlerBlock(error, _cmd, NO); // NO is for non-fatal error
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:objectToRemove];
        
        [self.managedObjectContextHash removeObjectForKey:contextKey];
    }
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Core Data Accesssors **

/*!
    @method     managedObjectModel
    @abstract   Returns the managed object model for the application.
    @discussion If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
    @result     NSManagedObjectModel
*/
- (NSManagedObjectModel *)managedObjectModel;
{
    dispatch_once(&__managedObjectModelCreationToken, ^{
        NSBundle *bundle = self.modelBundle;
        NSAssert(bundle, @"bundle must not be nil");
        NSURL *modelURL = [bundle URLForResource:RLCORE_DATA_MOMD_FILENAME withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        // A Unit test bundle requires a slightly different syntax to load then an app bundle.
        if (_managedObjectModel == nil)
        {
            NSArray *array = [NSArray arrayWithObject:bundle];
            _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:array];
        }

        // still don't have a model.  Time to error out.
        if (_managedObjectModel == nil)
        {
            NSString *errorDescription = @"Fatal Error: _managedObjectModel cannot be nil";
            NSError *error = RLQUICK_ERROR(2055978778, errorDescription); //random, arbitrary error code.
            self.errorHandlerBlock(error, _cmd, YES);
        }
    });

    return _managedObjectModel;
}

/*!
    @method     persistentStoreCoordinator
    @abstract   Returns the persistent store coordinator for the application.
    @discussion If the coordinator doesn't already exist, it is created and the application's store added to it.
    @result     NSPersistentStoreCoordinator
*/
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
{
    dispatch_once(&__persistentStoreCoordinatorCreationToken, ^{
        NSURL *storeUrl;
        if ([self.storeType isEqualToString:NSInMemoryStoreType]) {
            storeUrl = nil;
        } else {
            storeUrl = [NSURL fileURLWithPath:[[self persistentStoreDirectory] stringByAppendingPathComponent:RLCORE_DATA_FILE_NAME]];
        }
        NSError *error = nil;

        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        // options dictionary may be customized
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption,
                                 nil];

        NSPersistentStore *newPersistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:self.storeType 
                                                                                          configuration:nil 
                                                                                                    URL:storeUrl 
                                                                                                options:options
                                                                                                  error:&error];

        if (!newPersistentStore)
        {
            /*
             Typical reasons for an error here include:
             * The persistent store is not accessible
             * The schema for the persistent store is incompatible with current managed object model
             Check the error message to determine what the actual problem was.
             */

            NSString *errorDescription = [NSString stringWithFormat:@"Fatal Error: NSPersistentStoreCoordinator cannot be nil, storeType: %@, storeUrl:%@, reason: %@", self.storeType, storeUrl, error];
            NSError *innerError = RLQUICK_ERROR(58172, errorDescription); //random, arbitrary error code.
            self.errorHandlerBlock(innerError, _cmd, YES);
            _persistentStoreCoordinator = nil;
        }
    });

    return _persistentStoreCoordinator;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Other Accessors **

- (NSMutableDictionary *)managedObjectContextHash;
{
    dispatch_once(&__managedObjectContextHashCreationToken, ^{
        _managedObjectContextHash = [NSMutableDictionary dictionaryWithCapacity:2]; // The most common case is just two contexts: mainThread and background.
    });
    return _managedObjectContextHash;
}

- (void)setIsTestEnvironment:(BOOL)newValue
{
    _isTestEnvironment = newValue;

    if (_isTestEnvironment)
    {
        self.storeType = NSInMemoryStoreType;
        self.modelBundle = [NSBundle bundleWithIdentifier:RLCORE_DATA_UNIT_TEST_BUNDLE_IDENFIER];
    }
    else
    {
        self.storeType = nil;
        self.modelBundle = nil;
    }
}

- (NSBundle *)modelBundle;
{
    if (_modelBundle)
        return _modelBundle;
    return [NSBundle mainBundle];
}

- (NSString *)storeType;
{
    if (_storeType)
        return _storeType;
    return NSSQLiteStoreType;
//    return NSInMemoryStoreType;  //InMemory can be used for development/debugging/automated tests
}

- (NSString *)description;
{
    NSString *stringToReturn;
    stringToReturn = [NSString stringWithFormat:@"%@ storeType:%@, contexts:%@", [super description], self.storeType, self.managedObjectContextHash];
    return stringToReturn;
}

@end

