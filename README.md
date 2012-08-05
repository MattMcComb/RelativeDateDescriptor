# RelativeDateDescriptor.m

## About RelativeDateDescriptor.m

Often when comparing dates it is useful to provide the user with a human readable description of the interval between two dates.  The RelativeDateDescriptor can be used to produce a string based description of the interval between two dates i.e. '10 seconds ago', '5 hours 32 minutes ago', 'in 5 months' or '1000000 years ago'.

## Real World Example

Start by creating an instance of RelativeDateDescriptor...

    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

Notice that init method takes two parameters - the prior and post date description formats. These formats determine the structure of the returned description and must contain a single string format character (%@) that denotes the location to insert the time interval value (i.e. '3 hours', '2 seconds etc).  Alternative format examples would include...

    // Example Prior Date Description Formats:  @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
    // Example Post Date Description Formats:   @"in %@", @"occuring in %@", @"happening in %@"

Once we hae a RelativeDateDescriptor we can obtain our human readable description as follows...

    NSString *description = [descriptor describeDate:laterDate relativeTo:earlierDate]; 

When describing a date we do so in relation to another date i.e. that specified by the relativeTo: parameter, the reference date.  If the date being described (describeDate:) occurs before the reference date (relativeTo:) the prior date format as specified in the init method will be used, and if later the post date format will be used.

By default the RelativeDateDescriptor expresses the time differences using the most significant unit of time.  As an example if the two dates are 69 seconds apart the descriptor would return '1 minute'.  If you wish to define the time units in which the description will be expressed you can set the expressedUnits property, which takes a bitwise OR'd list of RDDTimeUnit constants i.e.
    
    [aRelativeDateDescriptorInstance setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes];


## Example Output

    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];

    // date1: 1st January 2000, 00:00:00
    // date2: 6th January 2000, 00:00:00
    [descriptor describeDate:date2 relativeTo:date1]; // Returns '5 days ago'
    [descriptor describeDate:date1 relativeTo:date2]; // Returns 'in 5 days'

    // date1: 1st January 2000, 00:00:00
    // date2: 1st January 2000, 00:00:18
    [descriptor describeDate:date2 relativeTo:date1]; // Returns '18 seconds ago'
    descriptor describeDate:date1 relativeTo:date2];  // Returns 'in 18 seconds'

    // date1: 1st January 2000, 00:12:18
    // date2: 1st January 2000, 09:45:39
    [descriptor describeDate:date2 relativeTo:date1]; // Returns 'in 9 hours 33 minutes 21 seconds'

## Using RelativeDateDescriptor

The easiest way to use the library is to simply add the classes (RelativeDateDescriptor.h and RelativeDateDescriptor.m) to your project.  

Alternatively, the project can be built as a static library and added to your own project.

## Things You Should Know

- The implementation uses NSDecimalNumber rather than floats so the accuracy should be good for fairly large date/time intervals.

- The project builds as a static library with integrated unit tests - these serve as a useful example for usage of the classes.

