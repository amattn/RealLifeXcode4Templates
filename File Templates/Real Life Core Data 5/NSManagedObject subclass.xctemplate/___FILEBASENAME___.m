/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * NSManagedObject subclass.  Encapsulated functionality specific to a given 
 * Core Data Entity
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

/*
 * Methods you Must Not Override
 * NSManagedObject itself customizes many features of NSObject so that 
 * managed objects can be properly integrated into the Core Data 
 * infrastructure. Core Data relies on NSManagedObject’s implementation 
 * of the following methods, which you therefore absolutely must not 
 * override: primitiveValueForKey:, setPrimitiveValue:forKey:, isEqual:, 
 * hash, superclass, class, self, zone, isProxy, isKindOfClass:, 
 * isMemberOfClass:, conformsToProtocol:, respondsToSelector:, retain, 
 * release, autorelease, retainCount, managedObjectContext, entity, 
 * objectID, isInserted, isUpdated, isDeleted, and isFault.
 *
 * In addition to the methods listed above, on Mac OS X v10.5, you must
 * not override: alloc, allocWithZone:, new, instancesRespondToSelector:,
 * instanceMethodForSelector:, methodForSelector:, 
 * methodSignatureForSelector:, instanceMethodSignatureForSelector:, 
 * or isSubclassOfClass:.
 *
 * As with any class, you are strongly discouraged from overriding the 
 * key-value observing methods such as willChangeValueForKey: and 
 * didChangeValueForKey:withSetMutation:usingObjects:.
 * 
 * You are discouraged from overriding description—if this method 
 * fires a fault during a debugging operation, the results may be 
 * unpredictable. You are also discouraged from overriding 
 * initWithEntity:insertIntoManagedObjectContext:, dealloc, or finalize. 
 */

//#import "MacroUtilities.h"
#import "___FILEBASENAME___.h"
___COREDATAMANAGEDOBJECTIMPORTEDHEADERS___

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark ** Synthesis **

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecyle **

- (void)awakeFromFetch;
{
    [super awakeFromFetch];
    // Custom behavior should occur AFTER[ [super awakeFromFetch].
    
    // You should not modify relationships in this method as the inverse will not be set.
    // See deocumentation for details.
}

- (void)awakeFromInsert;
{
    [super awakeFromInsert];
    // Custom behavior should occur AFTER [super awakeFromInsert].
}

- (void)didTurnIntoFault;
{
    // Release any unnecessary or transient resources here.
    // Should not fetch or save or otherwise affect the Managed Object Context in this method.

    [super didTurnIntoFault];
}

- (void)willSave;
{
    // Care must be taken not to induce infinite loops by triggering further
    // save actions.  See documentation for details.

    [super willSave];
}

- (void)didSave;
{
    // optional, postSave actions can be done here, such as notifications
    // or updating transient or calculated values.  Be careful of side effects
    // on the context, especially w/ undo.  See documentation for more info.
    
    [super didSave];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Methods **

//*****************************************************************************
#pragma mark -
#pragma mark ** Utilities **

//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

//*****************************************************************************
#pragma mark -
#pragma mark ** Core Data Accesssors **

// Xcode will automatically generate Accessors for your attribuates and 
// relationships here. Attributes and To-One Relationships are generated with 
// the @dynamic directive.  To-Many Relationships have both the @dynamic as well 
// as some convenience accessor methods stubbed out.  
//
// It should be noted that the convenience methods are  optional and may be 
// deleted if you don't need them.  If you need public accessors for your 
// relationships, you can add them to the 
// ___FILEBASENAMEASIDENTIFIER___GeneratedAccessors protocol in the .h file.  

___COREDATAPROPERTYIMPLEMENTATIONS___
@end
