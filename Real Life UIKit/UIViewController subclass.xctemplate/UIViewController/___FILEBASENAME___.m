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

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecycle & Memory Management **

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
 */

- (void)releaseViewResources;
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc;
{
	[self releaseViewResources];
    
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
    // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

//*****************************************************************************
#pragma mark -
#pragma mark ** UIViewController Methods **

// A UIViewController will typically implement one of loadView or viewDidLoad.
// If the view controller and its subclasses are only created programatically,
// loadView should be implemented.  If they are created via nib files, then
// viewDidLoad should be implemented.

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{

}
 */

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)viewDidUnload;
{
	[self releaseViewResources];
    [super viewDidUnload];
}

/*
- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}
 */
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
#pragma mark ** Utilities **

//*****************************************************************************
#pragma mark -
#pragma mark ** IBActions **

//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

@end