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

#import "___FILEBASENAME___.h"

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark ** Synthesis **

#pragma mark ** Static Variables **

static ___FILEBASENAMEASIDENTIFIER___ *__shared___FILEBASENAMEASIDENTIFIER___ = nil;

#pragma mark ** Singleton **

#if NS_BLOCKS_AVAILABLE
+ (___FILEBASENAMEASIDENTIFIER___ *)singleton;
{
    static dispatch_once_t createSingletonPredicate;
    dispatch_once(&createSingletonPredicate, ^
    {
        __shared___FILEBASENAMEASIDENTIFIER___ = [[___FILEBASENAMEASIDENTIFIER___ alloc] init];
    });
    return __shared___FILEBASENAMEASIDENTIFIER___;
}
#else
+ (___FILEBASENAMEASIDENTIFIER___ *)singleton;
{
    @synchronized(self)
    {
        if (__shared___FILEBASENAMEASIDENTIFIER___ == nil)
        {
            __shared___FILEBASENAMEASIDENTIFIER___ = [[self alloc] init];
        }
    }
    return __shared___FILEBASENAMEASIDENTIFIER___;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (__shared___FILEBASENAMEASIDENTIFIER___ == nil)
        {
            __shared___FILEBASENAMEASIDENTIFIER___ = [super allocWithZone:zone];
            return __shared___FILEBASENAMEASIDENTIFIER___;
        }
    }
    return nil;
}
#endif

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecyle Methods **

- (id)init;
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc;
{
    
}

//*****************************************************************************
#pragma mark -
#pragma mark ** NotificationHandlers **

//*****************************************************************************
#pragma mark -
#pragma mark ** Utilities **

//*****************************************************************************
#pragma mark -
#pragma mark ** IBActions **

//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

@end
