//
//  RelativeDateDescriptorTests.h
//  RelativeDateDescriptor
//
//  Created by Matthew McComb on 12/05/12

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RelativeDateDescriptorTests.h"
#import "RelativeDateDescriptor.h"

@interface RelativeDateDescriptorTests ()

- (NSDate*)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour
                minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

@end

@implementation RelativeDateDescriptorTests

- (void)testThatPostDateFormatIsUsedWhenComparedDateIsLater {
    NSDate* earlierDate = [self dateWithYear:2012 month:5 day:16 hour:1 minutes:1 seconds:10];
    NSDate* laterDate = [self dateWithYear:2012 month:5 day:18 hour:12 minutes:18 seconds:30];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    NSString *description = [descriptor describeDate:earlierDate relativeTo:laterDate];
    STAssertTrue([description rangeOfString:@"ago"].location != NSNotFound, @"Expected description 'in 2 days' but got %@",
                 description);
}

- (void)testThatPriorDateFormatIsUsedWhenComparedDateIsEarlier {
    NSDate* earlierDate = [self dateWithYear:2012 month:5 day:16 hour:1 minutes:1 seconds:10];
    NSDate* laterDate = [self dateWithYear:2012 month:5 day:18 hour:12 minutes:18 seconds:30];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    NSString *description = [descriptor describeDate:laterDate relativeTo:earlierDate];
    STAssertTrue([description rangeOfString:@"in"].location != NSNotFound, @"Expected description 'in 2 days' but got %@",
                 description);
}


- (void)testThatDescriptionIsCorrectWhenDatesAreMilliSecondsApart {
    NSDate *firstMilliSecondOfMillenium = [self dateWithYear:2000 month:0 day:0 hour:0 minutes:0 seconds:0];
    NSDate *verySoonAfter = [firstMilliSecondOfMillenium dateByAddingTimeInterval:0.201];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:verySoonAfter relativeTo:firstMilliSecondOfMillenium];
    NSString *expectedDescription = @"200 milliseconds";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatDescriptionIsCorrectWhenDatesAreSecondsApart {
    NSDate *firstSecondOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:0 seconds:1];
    NSDate *fourthSecondOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:0 seconds:3];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:fourthSecondOfMillenium relativeTo:firstSecondOfMillenium];
    NSString *expectedDescription = @"2 seconds";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatDescriptionIsCorrectWhenDatesAreMinutesApart {
    NSDate *firstMinuteOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:1 seconds:0];
    NSDate *eleventhMinuteOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:10 seconds:0];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:eleventhMinuteOfMillenium relativeTo:firstMinuteOfMillenium];
    NSString *expectedDescription = @"9 minutes";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatDescriptionIsCorrectWhenDatesAreHoursApart {
    NSDate *firstHourOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:0 seconds:0];
    NSDate *seventhHourOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:6 minutes:0 seconds:0];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:seventhHourOfMillenium relativeTo:firstHourOfMillenium];
    NSString *expectedDescription = @"6 hours";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}


- (void)testThatDescriptionIsCorrectWhenDatesAreDaysApart {
    NSDate *firstDayOfMillenium = [self dateWithYear:2000 month:0 day:0 hour:0 minutes:0 seconds:0];
    NSDate *sixthDayOfMillenium = [self dateWithYear:2000 month:0 day:6 hour:0 minutes:0 seconds:0];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:sixthDayOfMillenium relativeTo:firstDayOfMillenium];
    NSString *expectedDescription = @"6 days";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatDescriptionIsCorrectWhenDatesAreWeeksApart {
    NSDate *firstWeekOfMillenium = [self dateWithYear:2000 month:0 day:0 hour:0 minutes:0 seconds:0];
    NSDate *thirdWeekOfMillenium = [self dateWithYear:2000 month:0 day:22 hour:0 minutes:0 seconds:0];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:thirdWeekOfMillenium relativeTo:firstWeekOfMillenium];
    NSString *expectedDescription = @"3 weeks";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatDescriptionIsCorrectWhenDatesAreMonthsApart {
    NSDate *firstMonthOfMillenium = [self dateWithYear:2000 month:0 day:1 hour:0 minutes:0 seconds:0];
    NSDate *twelthMonthOfMillenium = [self dateWithYear:2000 month:11 day:1 hour:0 minutes:0 seconds:0];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:twelthMonthOfMillenium relativeTo:firstMonthOfMillenium];
    NSString *expectedDescription = @"11 months";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatDescriptionIsCorrectWhenDatesAreYearsApart {
    NSDate *firstYearOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:0 seconds:0];
    NSDate *hundredthYearOfMillenium = [self dateWithYear:2080 month:0 day:0 hour:0 minutes:0 seconds:0];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:hundredthYearOfMillenium relativeTo:firstYearOfMillenium];
    NSString *expectedDescription = @"81 years";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description '%@' but got %@",
                 expectedDescription, description);
}

- (void)testThatNilIsReturnedWhenRelativeToDateIsNil {
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:[NSDate date] relativeTo:nil];
    STAssertTrue(description == nil, @"Expected the date description to be nil when the relative to parameter was nil");
}

- (void)testThatNilIsReturnedWhenDateIsNil {
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    NSString *description = [descriptor describeDate:nil relativeTo:[NSDate date]];
    STAssertTrue(description == nil, @"Expected the date description to be nil when the date parameter was nil");
}

#pragma mark - 
#pragma mark - Expressed Time Unit Tests

// Tests that when the user specifies a time unit to express the date in that the returned description is expressed
// using that unit and that unit only
- (void)testThatDescriptionIsCorrectForASingleExpressedUnit {
    NSDate *firstHourOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:1 seconds:0];
    NSDate *eigthHourOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:8 minutes:10 seconds:12];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    [descriptor setExpressedUnits:RDDTimeUnitHours];
    NSString *description = [descriptor describeDate:eigthHourOfMillenium relativeTo:firstHourOfMillenium];
    NSString *expectedDescription = @"8 hours";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description %@ but got %@", expectedDescription, description);
}

// Tests that when the user specified two different time units that the returned description is expressed using both
// the supplied units
- (void)testThatDescriptionIsCorrectWhenExpressingTwoUnits {
    NSDate *firstHourOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:0 minutes:1 seconds:0];
    NSDate *eigthHourOfMillenium = [self dateWithYear:2000 month:1 day:1 hour:8 minutes:10 seconds:12];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    [descriptor setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes];
    NSString *description = [descriptor describeDate:eigthHourOfMillenium relativeTo:firstHourOfMillenium];
    NSString *expectedDescription = @"8 hours 9 minutes";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description %@ but got %@", expectedDescription, description);
}


// Test that if the expressed units are not valid (0) that the descriptor defaults to using the most significant time
// unit
- (void)testThatTheMostSignificantUnitIsUsedWhenExpressedUnitsInvalid {
    NSDate *secondMonthOfMillenium = [self dateWithYear:2000 month:2 day:1 hour:0 minutes:1 seconds:0];
    NSDate *twelthMonthOfMillenium = [self dateWithYear:2000 month:11 day:29 hour:8 minutes:10 seconds:12];
    RelativeDateDescriptor *descriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@" postDateDescriptionFormat:@"%@"];
    [descriptor setExpressedUnits:0];
    NSString *description = [descriptor describeDate:twelthMonthOfMillenium relativeTo:secondMonthOfMillenium];
    NSString *expectedDescription = @"9 months";
    STAssertTrue([description isEqualToString:expectedDescription], @"Expected description %@ but got %@", expectedDescription, description);
}

# pragma mark -
# pragma mark - Helper methods for building test dates

- (NSDate*)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour
                minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minutes];
    [dateComponents setSecond:seconds];
    [dateComponents setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [gregorianCalendar dateFromComponents:dateComponents];
    
}

@end
