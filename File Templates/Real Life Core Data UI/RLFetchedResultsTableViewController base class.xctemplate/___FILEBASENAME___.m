/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

// This file has been developed with ARC, Xcode 4.3.1

#import "___FILEBASENAME___.h"
#import "RLBaseEntityManager.h"

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

@implementation ___FILEBASENAMEASIDENTIFIER___
{

}

#pragma mark ** Synthesis **

#pragma mark ** Static Variables **

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecycle & Memory Management **

- (void)dealloc;
{
    
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
    // Release anything that's not essential, such as cached data
}

//*****************************************************************************
#pragma mark -
#pragma mark ** UIViewController Methods **

- (void)viewDidLoad;
{
    [super viewDidLoad];

    // The typical place to performFetchWithErrorHandler: is here.
    // In some cases, it makes sense to "refetch" everytime the view appears.
    // Depending on you needs, you may need to move the performFetchWithErrorHandler:
    // into the viewWillAppear: method.
    
    [self.tableView reloadData];
}

- (void)viewDidUnload;
{
    // Anything you init in viewDidLoad should be nil'd here.
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}
/*
- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}
 */
/*
- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
}
 */
/*
- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
}
 */

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES; //support all orientations
}
 */

//*****************************************************************************
#pragma mark -
#pragma mark ** Methods that subclasses MUST implement **

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSAssert2(FALSE, @"%@ Subclasses MUST override this method:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));;
    
    // Typically looks like this:
    // NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // cell.textLabel.text = managedObject.someString;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Methods that subclasses MAY implement **

// Subclasses may customize behavior by override the defaults impemented here.

//*****************************************************************************
#pragma mark -
#pragma mark ** Utilities **

//*****************************************************************************
#pragma mark -
#pragma mark ** UITableViewData Helper Methods **

//*****************************************************************************
#pragma mark -
#pragma mark ** UITableViewDataSource **

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{   
    // Get the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (cell == nil) {
        // In this if statement, any attributes/properties that apply to all the 
        // cells may be configured here.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:self.cellIdentifier];
    }
    
    // Configure the cell.
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

//*****************************************************************************
#pragma mark -
#pragma mark ** UITableViewDelegate **

//*****************************************************************************
#pragma mark -
#pragma mark ** NSFetchedResultsControllerDelegate **

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type;
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath;
{
 
    UITableView *tableView = self.tableView;

    UITableViewRowAnimation defaultAnimation = UITableViewRowAnimationFade;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:defaultAnimation];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:defaultAnimation];
            break;

        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell)
                [self configureCell:cell forRowAtIndexPath:indexPath];
        }
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:defaultAnimation];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:defaultAnimation];
            break;
    }
}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;
{
    [self.tableView endUpdates];
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

@end
