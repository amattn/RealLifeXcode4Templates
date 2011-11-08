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

#import "RLBaseEntityManager.h"

#pragma mark ** Constant Defines **

#pragma mark ** Protocols & Declarations **

@interface ___FILEBASENAMEASIDENTIFIER___ : RLBaseEntityManager
{
    
}
#pragma mark ** Designated Initializers **
- (id)initWithCoreDataEnvironment:(NSObject <RLCoreDataEnvironmentProtocol> *)environment;
+ (___FILEBASENAMEASIDENTIFIER___ *)manager; // Manager using default RLCoreDataEnvironment singleton

#pragma mark ** Core Data Properties **

#pragma mark ** Properties **

#pragma mark ** Methods **

// add custom methods here that apply to this entity.
// For example, RLBooksManager would likely contain:
//- (NSArray *)fetchAllBooksByAuthor:(RLAuthor *)someAuthor
//                 contextIdentifier:(RLContextIdentifier)contextIdentifier;

@end
