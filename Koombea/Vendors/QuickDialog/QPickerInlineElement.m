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

#import "QPickerInlineElement.h"
#import "QPickerEntryTableViewCell.h"

@implementation QPickerInlineElement

@synthesize pickerValue = _pickerValue;
@synthesize values = _values;
@synthesize centerLabel = _centerLabel;

- (QPickerInlineElement *)init {
    self = [super init];
    self.pickerValue = [NSString string];
    return self;
}

- (QPickerInlineElement *)initWithKey:(NSString *)key {
    self = [super initWithKey:key];
    return self;
}

- (QPickerInlineElement *)initWithTitle:(NSString *)string value:(NSString *)value {
    self = [super initWithTitle:string Value:value];
    if (self!=nil){
        _pickerValue = value;
    }
    return self;
}

- (QPickerInlineElement *)initWithValue:(NSString *)value {
    return [self initWithTitle:nil value:value];
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {

    QPickerEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickformPickerInlineElement"];
    if (cell==nil){
        cell = [[QPickerEntryTableViewCell alloc] init];
    }
    [cell prepareForElement:self inTableView:tableView];
    return cell;

}

- (void)fetchValueIntoObject:(id)obj {
	if (_key==nil)
		return;
    [obj setValue:_pickerValue forKey:_key];
}


@end