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

#import "QEntryTableViewCell.h"
#import "QPickerEntryTableViewCell.h"
#import "QPickerInlineElement.h"

@implementation QPickerEntryTableViewCell

@synthesize pickerView = _pickerView;
@synthesize values = _values;
@synthesize centeredLabel = _centeredLabel;


- (QPickerEntryTableViewCell *)init {
    self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuickformPickerInlineElement"];
    if (self!=nil){
        [self createSubviews];
		self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)createSubviews {
    [super createSubviews];
    _textField.hidden = YES;

    _pickerView = [[UIPickerView alloc] init];
    [_pickerView sizeToFit];
    _pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    _textField.inputView = _pickerView;

    self.centeredLabel = [[UILabel alloc] init];
    self.centeredLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
    self.centeredLabel.highlightedTextColor = [UIColor whiteColor];
    self.centeredLabel.font = [UIFont systemFontOfSize:17];
    self.centeredLabel.textAlignment = UITextAlignmentCenter;
	self.centeredLabel.backgroundColor = [UIColor clearColor];
    self.centeredLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width-20, self.contentView.frame.size.height-20);
    [self.contentView addSubview:self.centeredLabel];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *value = [_values objectAtIndex:[_pickerView selectedRowInComponent:component]];
    ((QPickerInlineElement *)  _entryElement).pickerValue = value;
    [self prepareForElement:_entryElement inTableView:_quickformTableView];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_values objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_values count];
}

- (void)prepareForElement:(QEntryElement *)element inTableView:(QuickDialogTableView *)tableView {
    QPickerInlineElement *entry = (QPickerInlineElement *)element;
    [super prepareForElement:element inTableView:tableView];
    _values = entry.values;
    
    QPickerInlineElement *pickerElement = ((QPickerInlineElement *) element);
    
    for (NSString *value in _values) {
        UILabel *row = [[UILabel alloc] init];
        row.text = value;
        [_pickerView addSubview:row];
    }
    
    if (!entry.centerLabel) {
		self.textLabel.text = element.title;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.centeredLabel.text = nil;
		self.detailTextLabel.text = entry.pickerValue;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.text = nil;
		self.centeredLabel.text = entry.pickerValue;
    }
	
	_textField.text = entry.pickerValue;
    _textField.placeholder = pickerElement.placeholder;
    _textField.inputAccessoryView.hidden = entry.hiddenToolbar;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView selectRow:[_values indexOfObject:entry.pickerValue] inComponent:0 animated:NO];
}


@end