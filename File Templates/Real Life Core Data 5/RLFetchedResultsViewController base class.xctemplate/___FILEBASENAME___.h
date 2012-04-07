/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

// This class is implemented as a UIViewController for maximum flexibility.
// To convert it to a UITableViewController:
// In this .h file, simple change the super class to UITableViewController 
// and comment out the line @property (nonatomic, weak) IBOutlet UITableView *tableView;
// In the .m file, TODO... finish explaination

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#pragma mark ** Constant Defines **

#pragma mark ** Protocols & Declarations **

@class RLBaseEntityManager;

@interface ___FILEBASENAMEASIDENTIFIER___ : UIViewController <NSFetchedResultsControllerDelegate>
{
    // The ivars declared under the @protected directive are strictly for the use of the base classes
    @protected
    NSFetchedResultsController *_fetchedResultsController;
    NSString *_predicateString;
    NSArray *_sortDescriptors;
}
#pragma mark ** Designated Initializer **
// use parent class initializers

#pragma mark ** Properties **
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) RLBaseEntityManager *entityManager;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

#pragma mark ** Methods **

#pragma mark ** Methods that subclasses MUST implement **

@property (nonatomic, strong, readonly) Class entityManagerClass;
@property (nonatomic, strong, readonly) NSString *cellIdentifier;
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark ** Methods that subclasses MAY implement **

@property (nonatomic, strong) NSString *predicateString;
@property (nonatomic, strong) NSArray *sortDescriptors;
@property (nonatomic, assign, readonly) BOOL shouldUseSections; // The default implementation returns YES.

#pragma mark ** Utilities **

- (NSFetchedResultsController *)fetchedResultsControllerWithSortDescriptors:(NSArray *)sortDescriptors;

@end
