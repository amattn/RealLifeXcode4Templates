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
#import "RLFetchedResultsViewController.h"

#pragma mark ** Constant Defines **

#pragma mark ** Protocols & Declarations **

@class RLBaseEntityManager;

@interface ___FILEBASENAMEASIDENTIFIER___ : RLFetchedResultsViewController <NSFetchedResultsControllerDelegate>

#pragma mark ** Designated Initializer **
// use parent class initializers

#pragma mark ** Properties **
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

#pragma mark ** Methods **

#pragma mark ** Methods that subclasses MUST implement **

- (void)configureCell:(UICollectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark ** Methods that subclasses MAY implement **

#pragma mark ** Utilities **

@end
