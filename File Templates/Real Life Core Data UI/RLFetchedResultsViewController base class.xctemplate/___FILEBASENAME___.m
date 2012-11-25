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
    
    // fetch request sort must match sectionNameKeyPath
    
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
