/******************************************************************************
 * - Created ___DATE___ by ___FULLUSERNAME___
 * - Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
 * - License: <#LICENSE#>
 *
 * <#SUMMARY INFORMATION#>
 *
 * Created from templates: https://github.com/amattn/RealLifeXcode4Templates
 */

#import <SenTestingKit/SenTestingKit.h>

// @interface <#MyClass#> (test_only)
//
// You can declare methods here that are normally internal only by you want to 
// expose for testing
// - (id)internalProcessorMethod:(id)object;
// @end

@interface ___FILEBASENAMEASIDENTIFIER___ : SenTestCase
{
    // Most test cases don't need an explicit .h file.
    // However if you plan on having test cases that inherit from 
    // other test cases, you can extract this @interface into 
    // a .h file for other test cases to inherit from.
}
@end

@implementation ___FILEBASENAMEASIDENTIFIER___
{

}

- (void)setUp;
{
    NSLog(@"Open Console.app to see log messages");
}

- (void)tearDown;
{
    
}

- (void)testTestFramework;
{
//    STFail(@"uncomment to verify unit tests are being run");

    NSString *string1 = @"test";
    NSString *string2 = @"test";
    // Shouldn't use colons (:) in the STAssert... function messages.
    // Xcode will strip out everything before the colon.
    STAssertEqualObjects(string1, string2, @"FAILURE- %@ does not equal %@ ", string1, string2);

    NSUInteger uint_1 = 4;
    NSUInteger uint_2 = 4;
    STAssertEquals(uint_1, uint_2, @"FAILURE- %d does not equal %d", uint_1, uint_2);

}

@end
