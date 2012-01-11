//
//  NSString+ActiveSupportInflector.m
//  ActiveSupportInflector
//

//#import "NSString+MSAdditions.h"
#import "ActiveSupportInflector.h"

@implementation NSString (ActiveSupportInflector)

- (NSString *)pluralizeString
{
    static ActiveSupportInflector *inflector = nil;
    if (!inflector) {
        inflector = [[ActiveSupportInflector alloc] init];
    }
    return [inflector pluralize:self];
}

- (NSString *)singularizeString
{
    static ActiveSupportInflector *inflector = nil;
    if (!inflector) {
        inflector = [[ActiveSupportInflector alloc] init];
    }
    return [inflector singularize:self];
}

- (NSString *)propertyString
{
    NSString *expression = @"(?<!^)(?=[A-Z])";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:0 error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@"_$1"];
    return [modifiedString lowercaseString];
}

- (NSString *)propertyPluralizedString
{
    return [[self propertyString] pluralizeString];
}

- (NSString *)foreignKeyString
{
    return [NSString stringWithFormat:@"%@_id", [self propertyString]];
}

@end
