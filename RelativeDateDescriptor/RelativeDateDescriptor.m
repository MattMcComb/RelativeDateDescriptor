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

// Time unit handling
- (BOOL)expressMostSignificantUnitOnly;
- (BOOL)isExpressedUnit:(RDDTimeUnit)timeUnit;
- (NSArray*)expressedTimeUnits;
- (RDDTimeUnit)mostSignificantUnitForTimeDifference:(NSDecimalNumber*)separaionInSeconds;

@end

@implementation RelativeDateDescriptor

@synthesize priorDateDescriptionFormat;
@synthesize postDateDescriptionFormat;
@synthesize expressedUnits = _expressedUnits;

- (id)initWithPriorDateDescriptionFormat:(NSString*)priorFormat postDateDescriptionFormat:(NSString*)postFormat; {
    if (self = [super init]) {
        [self setPriorDateDescriptionFormat:priorFormat];
        [self setPostDateDescriptionFormat:postFormat];
        [self setExpressedUnits:RDDTimeUnitMostSignificant];
    }
    return self;
}

- (id)init {
    return [self initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
}

- (NSString*)describeDate:(NSDate*)targetDate relativeTo:(NSDate*)referenceDate {
    
    if (!targetDate || !referenceDate) {
        return nil;
    }
    
    NSTimeInterval separationInSeconds = [targetDate timeIntervalSinceDate:referenceDate];
    
    bool isPriorDate = separationInSeconds < 0;
    NSString *appropriateDateFormat = isPriorDate ? priorDateDescriptionFormat : postDateDescriptionFormat;
    separationInSeconds = isPriorDate ? -separationInSeconds : separationInSeconds;
    
    NSDecimalNumber *preciseSeparation = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:separationInSeconds];
    
    NSArray *expressedTimeUnits = [self expressedTimeUnits];
    
    NSString *intervalDescription;
    if ([self expressMostSignificantUnitOnly] || [expressedTimeUnits count] == 0) {
        RDDTimeUnit mostSignificantUnit = [self mostSignificantUnitForTimeDifference:preciseSeparation];
        expressedTimeUnits = [NSArray arrayWithObject:[NSNumber numberWithInt:mostSignificantUnit]];
    }
        
    intervalDescription = [self describeInterval:preciseSeparation usingQuantifiers:expressedTimeUnits];
    
    return [NSString stringWithFormat:appropriateDateFormat, intervalDescription];
}

#pragma mark - 
#pragma mark - Description Time Unit Handling

- (BOOL)expressMostSignificantUnitOnly {
    return (_expressedUnits & RDDTimeUnitMostSignificant) == RDDTimeUnitMostSignificant;
}

- (BOOL)isExpressedUnit:(RDDTimeUnit)timeUnit {
    return (_expressedUnits & timeUnit) == timeUnit;
}

- (NSArray*)expressedTimeUnits {
    NSMutableArray *expressedTimeUnits = [NSMutableArray array];
    int i = 0;
    for (int timeUnit = RDDTimeUnitMilliSeconds; timeUnit <= RDDTimeUnitYears; timeUnit = 1 << (i++)) {
        if ([self isExpressedUnit:timeUnit]) {
            [expressedTimeUnits addObject:[NSNumber numberWithInt:timeUnit]];
        }
    }
    return expressedTimeUnits;
}

- (RDDTimeUnit)mostSignificantUnitForTimeDifference:(NSDecimalNumber*)separaionInSeconds {
    
    RDDTimeUnit appropriateTimeUnit = RDDTimeUnitSeconds;
    
    NSDecimalNumber *preciseSeparationInMilliSeconds = [separaionInSeconds decimalNumberByMultiplyingByPowerOf10:3];
    
    if ([self compare:preciseSeparationInMilliSeconds to:kMilliSecondsInASecond] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitMilliSeconds;
        
    } else if ([self compare:separaionInSeconds to:kSecondsInAMinute] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitSeconds;
        
    } else if ([self compare:separaionInSeconds to:kSecondsInAnHour] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitMinutes;
        
    } else if ([self compare:separaionInSeconds to:kSecondsInADay] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitHours;
        
    } else if ([self compare:separaionInSeconds to:kSecondsInAMonth] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitDays;
        
    } else if ([self compare:separaionInSeconds to:kSecondsInAYear] == NSOrderedAscending) {
        appropriateTimeUnit = RDDTimeUnitMonths;
        
    } else {
        appropriateTimeUnit = RDDTimeUnitYears;
    }
    
    return appropriateTimeUnit;
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
            return 0;
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
            return nil;
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

- (NSString*)describeInterval:(NSDecimalNumber*)interval usingQuantifiers:(NSArray*)quantifiers {
    
    NSArray *mostSignificantTimeUnitSort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    NSArray *sortedQuantifiers = [quantifiers sortedArrayUsingDescriptors:[NSArray arrayWithObject:mostSignificantTimeUnitSort]];
    
    // Iterate over the list of units and build a description with a component for each unit - as we go we subtract
    // the magnitude of each unit to get the remaining seconds/interval to be expressed in terms of the following units
    NSMutableString *intervalDescription = [[NSMutableString alloc] init];
    NSDecimalNumber *remainingInterval = [interval copy];
    for (int i = 0; i < [sortedQuantifiers count]; i++) {
        
        NSInteger timeUnitQuantifier = [[sortedQuantifiers objectAtIndex:i] integerValue];
        
        double secondsInTimeUnit = [self secondsInTimeUnit:timeUnitQuantifier];
        int intervalInTimeUnit = [self preciselyDivide:remainingInterval by:secondsInTimeUnit];
        double subtractedSeconds = secondsInTimeUnit * intervalInTimeUnit;
        
        NSString *quantifierFormat = [self formOfDateQuantifier:[self quantifierForTimeUnit:timeUnitQuantifier]
                                                         forCount:intervalInTimeUnit];
        
        NSString *intervalDescribedUsingQuanitifer = [NSString stringWithFormat:@"%i %@", intervalInTimeUnit, quantifierFormat];
        
        [intervalDescription appendString:intervalDescribedUsingQuanitifer];
        
        // Deduct the expressed time from the interval - the resulting time interval will be described in terms of the
        // remaining time units (if any)
        remainingInterval = [remainingInterval decimalNumberBySubtracting:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:subtractedSeconds]];
        
        // Place a space between the expressed time units 
        if (i != [sortedQuantifiers count] - 1) {
            [intervalDescription appendString:@" "];
        }
        
    }
    return intervalDescription;
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
