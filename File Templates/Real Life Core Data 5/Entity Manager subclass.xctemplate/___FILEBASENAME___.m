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

@interface ___FILEBASENAMEASIDENTIFIER___ ()
//@property (nonatomic, strong) <#object type#> *<#name#>;
//@property (nonatomic, assign) <#scaler type#> <#name#>;
@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark ** Synthesis **

#pragma mark ** Static Variables **

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecyle & Memory Management **

+ (___FILEBASENAMEASIDENTIFIER___ *)manager; // Manager using default RLCoreDataEnvironment singleton
{
    return [[___FILEBASENAMEASIDENTIFIER___ alloc] initWithCoreDataEnvironment:[RLCoreDataEnvironment singleton]];
}

- (id)initWithCoreDataEnvironment:(NSObject <RLCoreDataEnvironmentProtocol> *)environment;
{
    self = [super initWithCoreDataEnvironment:environment];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    
}

//*****************************************************************************
#pragma mark -
#pragma mark ** CoreDataManager Subclasses may override **

- (NSArray *)defaultSortDescriptors;
{
    // Here is an example of how to add a custom sort descriptor in addition to
    // the default sort descriptors:
    //
    // NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:CD_KEY_TS_ADD ascending:YES];
    // NSArray *newSortDescriptors = [NSArray arrayWithObject:sorter];
    // return [newSortDescriptors arrayByAddingObjectsFromArray:super.defaultSortDescriptors];

    return super.defaultSortDescriptors;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Actions **

//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

@end
