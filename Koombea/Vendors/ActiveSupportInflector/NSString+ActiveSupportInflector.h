//
//  NSString+ActiveSupportInflector.h
//  ActiveSupportInflector
//

@interface NSString (ActiveSupportInflector)

- (NSString *)pluralizeString;
- (NSString *)singularizeString;
- (NSString *)propertyString;
- (NSString *)propertyPluralizedString;
- (NSString *)foreignKeyString;

@end
