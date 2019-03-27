//
//  NSString+CoreText.h
//  DBLineChart
//
//  Created by bob on 2019/3/25.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (CoreText)

- (CFAttributedStringRef)createCFStringWithFont:(UIFont *)font color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
