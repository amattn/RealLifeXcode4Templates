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

// This file has been developed with ARC, Xcode 4.3.1

#import "___FILEBASENAME___.h"
#import "RLBaseEntityManager.h"

@interface ___FILEBASENAMEASIDENTIFIER___ ()

@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark ** Synthesis **

@synthesize tableView = _tableView;
@synthesize entityManager = _entityManager;
@synthesize sortDescriptors = _sortDescriptors;
@synthesize predicateString = _predicateString;

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
	
	[self performFetchWithErrorHandler:^(NSFetchedResultsController *fetchedResultsController, NSError *error) {
		NSLog(@"performFetchWithErrorHandler: failed with error:%@", error);
	}];
	
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

- (NSString *)cellIdentifier;
{
	NSAssert2(FALSE, @"%@ Subclasses MUST override this method:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));;
	return nil;
}

- (Class)entityManagerClass;
{
	NSAssert2(FALSE, @"%@ Subclasses MUST override this method:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));;
	return nil;
}

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

- (NSArray *)sortDescriptors;
{
	return [NSArray array];
}

- (NSFetchedResultsController *)fetchedResultsController;
{
	if (_fetchedResultsController == nil)
	{
		_fetchedResultsController = [self fetchedResultsControllerWithSortDescriptors:self.sortDescriptors];
		_fetchedResultsController.delegate = self;
	}
	return _fetchedResultsController;
}

- (BOOL)shouldUseSections;
{
	return YES;

}

//*****************************************************************************
#pragma mark -
#pragma mark ** Utilities **

- (void)performFetchWithErrorHandler:(void (^)(NSFetchedResultsController *fetchedResultsController, NSError *error))errorHandler;
{
	__autoreleasing NSError *error = nil;
	BOOL didFetch = [self.fetchedResultsController performFetch:&error];
	if (error || didFetch == NO) {
		if (errorHandler)
			errorHandler(self.fetchedResultsController, error);
	}
}

- (NSFetchedResultsController *)fetchedResultsControllerWithSortDescriptors:(NSArray *)sortDescriptors;
{
	for (id obj in sortDescriptors) {
		NSAssert1([obj isKindOfClass:[NSSortDescriptor class]], @"Expected class:NSSortDescriptor but got:%@", obj);
	}
	
	NSFetchedResultsController *controllerToReturn;
	
	// fetch request sort must match sectionNaneKeyPath
	
	NSPredicate *predicate = nil;
	if (self.predicateString)
		predicate = [NSPredicate predicateWithFormat:self.predicateString];
	NSFetchRequest *fetchRequest = [self.entityManager fetchRequestForPredicate:predicate contextKey:nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSString *sectionNameKeyPath = nil;
	if (self.shouldUseSections && [sortDescriptors count] > 1) {
		sectionNameKeyPath = [[sortDescriptors objectAtIndex:0] key]; // sectionNameKeyPath must always match the primary sort key
	}
	
	controllerToReturn = [self.entityManager fetchedResultsControllerForFetchRequest:fetchRequest
																		  contextKey:nil
																  sectionNameKeyPath:sectionNameKeyPath
																		   cacheName:nil];
	
	return controllerToReturn;
}

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

- (RLBaseEntityManager *)entityManager;
{
	if (_entityManager == nil) {
		NSAssert([self.entityManagerClass isSubclassOfClass:[RLBaseEntityManager class]], @"class %@ is not a subclass of RLBaseEntityManager", NSStringFromClass([self.entityManagerClass class]));
		_entityManager = [self.entityManagerClass manager];
	}
	return _entityManager;
}


@end
