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

@end

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark ** Synthesis **

#pragma mark ** Static Variables **

//*****************************************************************************
#pragma mark -
#pragma mark ** Lifecycle & Memory Management **

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)dealloc;
{
    
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Methods **

//*****************************************************************************
#pragma mark -
#pragma mark ** UIView Methods **

- (void)drawRect:(CGRect)rect;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        CGContextSetGrayFillColor(context, 0.3, 1.0);
        CGContextAddEllipseInRect(context, rect);
        CGContextFillPath(context);
    }
    CGContextRestoreGState(context);
}

//*****************************************************************************
#pragma mark -
#pragma mark ** Accesssors **

@end
