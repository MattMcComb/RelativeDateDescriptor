//
//  RelativeDateDescriptor.m
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

#import "RelativeDateDescriptor.h"

const double    kMilliSecondsInASecond = 1000;
const double    kSecondsInAMinute = 60;
const double    kSecondsInAnHour  = kSecondsInAMinute * 60;
const double    kSecondsInADay    = kSecondsInAMinute * 60 * 24;
const double    kSecondsInAMonth  = kSecondsInADay * 30.43;
const double    kSecondsInAYear   = kSecondsInADay * 356.242199;

@interface RelativeDateDescriptor ()

- (double)secondsInTimeUnit:(RDDTimeUnit)unit;

- (NSComparisonResult)compare:(NSDecimalNumber*)separation to:(double)interval;
- (NSString*)applyFormat:(NSString*)descriptionFormat toRelativeDifference:(NSString*)difference;
- (NSString*)formOfDateQuantifier:(NSString*)quantifier forCount:(NSInteger)count;

@end

@implementation RelativeDateDescriptor

@synthesize priorDateDescriptionFormat;
@synthesize postDateDescriptionFormat;

- (id)initWithPriorDateDescriptionFormat:(NSString*)priorFormat postDateDescriptionFormat:(NSString*)postFormat; {
    if (self = [super init]) {
        [self setPriorDateDescriptionFormat:priorFormat];
        [self setPostDateDescriptionFormat:postFormat];
    }
    return self;
}

- (id)init {
    return [self initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
}

- (NSString*)describeDate:(NSDate*)targetDate relativeTo:(NSDate*)referenceDate {
    
    NSTimeInterval separationInSeconds = [targetDate timeIntervalSinceDate:referenceDate];
    
    bool isPriorDate = separationInSeconds < 0;
    NSString *appropriateDateFormat = isPriorDate ? priorDateDescriptionFormat : postDateDescriptionFormat;
    separationInSeconds = isPriorDate ? -separationInSeconds : separationInSeconds;
    
    NSDecimalNumber *preciseSeparation = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:separationInSeconds];
    NSDecimalNumber *preciseSeparationInMilliSeconds = [preciseSeparation decimalNumberByMultiplyingByPowerOf10:3];
    
    
    
    NSString *intervalDescription;
    RDDTimeUnit appropriateTimeUnit = RDDTimeUnitSeconds;
    
    if ([self compare:preciseSeparationInMilliSeconds to:kMilliSecondsInASecond] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitMilliSeconds;
        
    } else if ([self compare:preciseSeparation to:kSecondsInAMinute] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitSeconds;
        
    } else if ([self compare:preciseSeparation to:kSecondsInAnHour] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitMinutes;
        
    } else if ([self compare:preciseSeparation to:kSecondsInADay] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitHours;
        
    } else if ([self compare:preciseSeparation to:kSecondsInAMonth] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitDays;
        
    } else if ([self compare:preciseSeparation to:kSecondsInAYear] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitMonths;
        
    } else {
        appropriateTimeUnit = RDDTimeUnitYears;
    }
    
    intervalDescription = [self describeInterval:preciseSeparation UsingQuantifier:appropriateTimeUnit];
    
    return [NSString stringWithFormat:appropriateDateFormat, intervalDescription];
}


# pragma mark -
# pragma mark - 

- (double)secondsInTimeUnit:(RDDTimeUnit)unit {
    switch (unit) {
        case RDDTimeUnitMilliSeconds:
            return 0.001f;
        case RDDTimeUnitSeconds:
            return 1.0f;
        case RDDTimeUnitMinutes:
            return kSecondsInAMinute;
        case RDDTimeUnitHours:
            return kSecondsInAnHour;
        case RDDTimeUnitDays:
            return kSecondsInADay;
        case RDDTimeUnitMonths:
            return kSecondsInAMonth;
        case RDDTimeUnitYears:
            return kSecondsInAYear;
        default:
            break;
    }
}

- (NSString*)quantifierForTimeUnit:(RDDTimeUnit)unit {
    switch (unit) {
        case RDDTimeUnitMilliSeconds:
            return @"millisecond";
        case RDDTimeUnitSeconds:
            return @"second";
        case RDDTimeUnitMinutes:
            return @"minute";
        case RDDTimeUnitHours:
            return @"hour";
        case RDDTimeUnitDays:
            return @"day";
        case RDDTimeUnitMonths:
            return @"month";
        case RDDTimeUnitYears:
            return @"year";
        default:
            break;
    }
}


# pragma mark -
# pragma mark - Comparison

- (NSInteger)preciselyDivide:(NSDecimalNumber*)dividend by:(double)divisor {
    NSDecimalNumber *divisorAsDecimalNumber = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:divisor];
    NSDecimalNumber *result = [dividend decimalNumberByDividingBy:divisorAsDecimalNumber];
    return [result intValue];
}

- (NSComparisonResult)compare:(NSDecimalNumber*)separation to:(double)interval {
    NSDecimalNumber *intervalAsDecimalNumber = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:interval];
    return [separation compare:intervalAsDecimalNumber];
}

- (NSString*)describeInterval:(NSDecimalNumber*)interval UsingQuantifier:(RDDTimeUnit)quantifier {
    double quantiferInterval = [self secondsInTimeUnit:quantifier];
    int quantifiedInterval = [self preciselyDivide:interval by:quantiferInterval];
    NSString *timeUnitQuantifier = [self formOfDateQuantifier:[self quantifierForTimeUnit:quantifier]
                                                     forCount:quantifiedInterval];
    return [NSString stringWithFormat:@"%i %@", quantifiedInterval, timeUnitQuantifier];
}

# pragma mark -
# pragma mark - Result string formatting

- (NSString*)applyFormat:(NSString*)descriptionFormat toRelativeDifference:(NSString*)difference {
    return [NSString stringWithFormat:descriptionFormat, difference];
}

/*
 * Given a date quanitifier i.e. hour or minute returns that quantifier in its singular or plural form 
 * depending on the supplied count
 */
- (NSString*)formOfDateQuantifier:(NSString*)quantifier forCount:(NSInteger)count {
    return count > 1 ? [NSString stringWithFormat:@"%@s", quantifier] : quantifier;
}

@end
