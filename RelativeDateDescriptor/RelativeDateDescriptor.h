//
//  RelativeDateDescriptor.h
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

#import <Foundation/Foundation.h>

typedef enum {
    RDDTimeUnitMilliSeconds,
    RDDTimeUnitYears,
    RDDTimeUnitMonths,
    RDDTimeUnitDays,
    RDDTimeUnitHours,
    RDDTimeUnitMinutes,
    RDDTimeUnitSeconds
} RDDTimeUnit;


/*
 * Class which can describe the time interval between two dates in a human readable format i.e. 'in 1 minute',
 * 'in 7 years', '6 days ago' etc.  
 * 
 * The returned description contains the most significant time unit only - i.e. if the two dates are 3 days and 2 hours
 * apart only the differences in days will be described.
 *
 * The description format is controlled by the priorDateDescriptionFormat and postDateDescriptionFormat properties.
 * Each of these properties MUST contain a single string format specifier (%@) that denotes the location to insert
 * the time interval description ('2 minutes' etc.).  Some examples...
 * 
 * priorDateDescriptionFormat: @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
 * postDateDescriptionFormat:  @"in %@", @"occuring in %@", @"happening in %@"
 * 
 */
@interface RelativeDateDescriptor : NSObject {
    
}

@property (nonatomic, copy) NSString* priorDateDescriptionFormat;
@property (nonatomic, copy) NSString* postDateDescriptionFormat;

/* Designated initializer
 *
 * Specify the formats used when describing dates - the prior format is used when the date occurs before the reference
 * date and the post format is used when the date occurs after.  The formats should include a string format character
 * %@ ie. '%@ ago' or 'in %@'
 *
 * To return 
 */
- (id)initWithPriorDateDescriptionFormat:(NSString*)priorFormat postDateDescriptionFormat:(NSString*)postFormat;


// Describe the time difference between referenceDate and targetDate in a human readable form
- (NSString*)describeDate:(NSDate*)targetDate relativeTo:(NSDate*)referenceDate;

@end
