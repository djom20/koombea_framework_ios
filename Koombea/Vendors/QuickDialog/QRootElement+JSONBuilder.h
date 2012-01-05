//
//  Created by escoz on 11/1/11.
//
#import <Foundation/Foundation.h>
#import "QRootElement.h"


@interface QRootElement (JSONBuilder)

- (id)initWithJSONFile:(NSString *)jsonPath;
- (id)initWithJSONString:(NSString *)jsonString;

@end