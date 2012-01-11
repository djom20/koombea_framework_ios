//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <objc/runtime.h>

NSDictionary * QRootElementJSONBuilderConversionDict;

@interface QRootElement ()
- (void)initializeMappings;
@end

@implementation QRootElement;

@synthesize title = _title;
@synthesize sections = _sections;
@synthesize grouped = _grouped;
@synthesize controllerName = _controllerName;

- (QRootElement *)init {
    self = [super init];
    return self;
}

- (void)addSection:(QSection *)section {
    if (_sections==nil)
        _sections = [[NSMutableArray alloc] init];

    [_sections addObject:section];
    section.rootElement = self;
}

- (QSection *)getSectionForIndex:(NSInteger)index {
   return [_sections objectAtIndex:(NSUInteger) index];
}

- (NSInteger)numberOfSections {
    return [_sections count];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    UITableViewCell *cell = [super getCellForTableView:tableView controller:controller];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = _title;
    return cell;
}

- (void)selected:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller indexPath:(NSIndexPath *)path {
    [super selected:tableView controller:controller indexPath:path];

    if (self.sections==nil)
            return;

    [controller displayViewControllerForRoot:self];
}

- (void)fetchValueIntoObject:(id)obj {
    for (QSection *s in _sections) {
        for (QElement *el in s.elements) {
            [el fetchValueIntoObject:obj];
        }
    }
}

#pragma mark - Added from category QRootElement+JSONBuilder

- (void)updateObject:(id)obj withPropertiesFrom:(NSDictionary *)dict {
    for (NSString *key in dict.allKeys){
        if ([key isEqualToString:@"type"])
            continue;
        id value = [dict valueForKey:key];
        if ([value isKindOfClass:[NSString class]] && [obj respondsToSelector:NSSelectorFromString(key)]) {
            [obj setValue:value forKey:key];
            if ([QRootElementJSONBuilderConversionDict objectForKey:key]!=nil) {
                [obj setValue:[[QRootElementJSONBuilderConversionDict objectForKey:key] objectForKey:value] forKey:key];
            }
        } else if ([value isKindOfClass:[NSNumber class]] || [key isEqualToString:@"values"]) {
            [obj setValue:value forKey:key];
        }
    }
}

- (QElement *)buildElementWithJson:(NSDictionary *)dict {
    id QElementClass = NSClassFromString([dict valueForKey:@"type"]);
    QElement *element = [[QElementClass alloc] init];
    if (element==nil)
        return nil;
    [self updateObject:element withPropertiesFrom:dict];
    return element;
}

- (void)buildSectionWithJSON:(NSDictionary *)dict {
    QSection *sect = [[QSection alloc] init];
    [self updateObject:sect withPropertiesFrom:dict];
    [self addSection:sect];
    for (id element in (NSArray *)[dict valueForKey:@"elements"]) {
        QElement *e = [self buildElementWithJson:element];
        if(e) [sect addElement:e];
    }
}

- (void)buildRootWithJSON:(NSDictionary *)dict {
    [self updateObject:self withPropertiesFrom:dict];
    for (id section in (NSArray *)[dict valueForKey:@"root"]) {
        [self buildSectionWithJSON:section];
    }
}

- (id)initWithJSONFile:(NSString *)jsonPath {
    self = [super init];
    
    Class JSONSerialization = objc_getClass("NSJSONSerialization");
    
    NSAssert(JSONSerialization != NULL, @"No JSON serializer available!");
    
    if (self!=nil){
        if (QRootElementJSONBuilderConversionDict==nil)
            [self initializeMappings];
        
        NSError *jsonParsingError = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
        NSDictionary *jsonRoot = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:0 error:&jsonParsingError];
        [self buildRootWithJSON:jsonRoot];
    }
    return self;
}

- (id)initWithJSONString:(NSString *)jsonString {
    self = [super init];
    
    Class JSONSerialization = objc_getClass("NSJSONSerialization");
    
    NSAssert(JSONSerialization != NULL, @"No JSON serializer available!");
    
    if (self!=nil) {
        if (QRootElementJSONBuilderConversionDict==nil)
            [self initializeMappings];
        
        NSError *jsonParsingError = nil;
        NSDictionary *jsonRoot = [JSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonParsingError];
        [self buildRootWithJSON:jsonRoot];
    }
    return self;
}

- (void)initializeMappings {
    
    [QLabelElement load];
    [QBadgeElement load];
    [QBooleanElement load];
    [QButtonElement load];
    [QDateTimeInlineElement load];
    [QPickerInlineElement load];
    [QFloatElement load];
    [QMapElement load];
    [QRadioElement load];
    [QRadioItemElement load];
    [QTextElement load];
    [QWebElement load];
    [QDecimalElement load];
    [QSortingSection load];
    [QDateTimeElement load];
    
    QRootElementJSONBuilderConversionDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSNumber numberWithInt:UITextAutocapitalizationTypeNone], @"None",
                                              [NSNumber numberWithInt:UITextAutocapitalizationTypeWords], @"Words",
                                              [NSNumber numberWithInt:UITextAutocapitalizationTypeSentences], @"Sentences",
                                              [NSNumber numberWithInt:UITextAutocapitalizationTypeAllCharacters], @"AllCharacters",
                                              nil], @"autocapitalizationType",
                                             
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSNumber numberWithInt:UITextAutocorrectionTypeDefault], @"Default",
                                              [NSNumber numberWithInt:UITextAutocorrectionTypeNo], @"No",
                                              [NSNumber numberWithInt:UITextAutocorrectionTypeYes], @"Yes",
                                              nil], @"autocorrectionType",
                                             
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSNumber numberWithInt:UIKeyboardTypeDefault], @"Default",
                                              [NSNumber numberWithInt:UIKeyboardTypeASCIICapable], @"ASCIICapable",
                                              [NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation], @"NumbersAndPunctuation",
                                              [NSNumber numberWithInt:UIKeyboardTypeURL], @"URL",
                                              [NSNumber numberWithInt:UIKeyboardTypeNumberPad], @"NumberPad",
                                              [NSNumber numberWithInt:UIKeyboardTypePhonePad], @"PhonePad",
                                              [NSNumber numberWithInt:UIKeyboardTypeNamePhonePad], @"NamePhonePad",
                                              [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], @"EmailAddress",
                                              [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], @"DecimalPad",
                                              [NSNumber numberWithInt:UIKeyboardTypeTwitter], @"Twitter",
                                              [NSNumber numberWithInt:UIKeyboardTypeAlphabet], @"Alphabet",
                                              nil], @"keyboardType",
                                             
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSNumber numberWithInt:UIKeyboardAppearanceDefault], @"Default",
                                              [NSNumber numberWithInt:UIKeyboardAppearanceAlert], @"Alert",
                                              nil], @"keyboardAppearance",
                                             
                                             
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSNumber numberWithInt:UIReturnKeyDefault], @"Default",
                                              [NSNumber numberWithInt:UIReturnKeyGo], @"Go",
                                              [NSNumber numberWithInt:UIReturnKeyGoogle], @"Google",
                                              [NSNumber numberWithInt:UIReturnKeyJoin], @"Join",
                                              [NSNumber numberWithInt:UIReturnKeyNext], @"Next",
                                              [NSNumber numberWithInt:UIReturnKeyRoute], @"Route",
                                              [NSNumber numberWithInt:UIReturnKeySearch], @"Search",
                                              [NSNumber numberWithInt:UIReturnKeySend], @"Send",
                                              [NSNumber numberWithInt:UIReturnKeyYahoo], @"Yahoo",
                                              [NSNumber numberWithInt:UIReturnKeyDone], @"Done",
                                              [NSNumber numberWithInt:UIReturnKeyEmergencyCall], @"EmergencyCall",
                                              nil], @"returnKeyType",
                                             
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [NSNumber numberWithInt:UIDatePickerModeDate], @"Date",
                                              [NSNumber numberWithInt:UIDatePickerModeTime], @"Time",
                                              [NSNumber numberWithInt:UIDatePickerModeDateAndTime], @"DateAndTime",
                                              [NSNumber numberWithInt:UIDatePickerModeCountDownTimer], @"CountDownTimer",
                                              nil], @"mode",
                                             
                                             nil];
}

@end