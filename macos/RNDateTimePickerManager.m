/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNDateTimePickerManager.h"
#import "RNDateTimePickerShadowView.h"

#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import "RNDateTimePicker.h"
#import <React/UIView+React.h>

#ifndef __IPHONE_15_0
@interface NSColor (Xcode12)
+ (instancetype) tintColor;
@end
#endif

@implementation RCTConvert(NSDatePicker)

RCT_ENUM_CONVERTER(NSDatePickerMode, (@{
  @"single": @(NSDatePickerModeSingle),
  @"range": @(NSDatePickerModeRange),
}), NSDatePickerModeSingle, integerValue)


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

typedef NSDatePickerStyle RNCNSDatePickerStyle;

// using UIDatePickerStyle directly conflicts with RN implementation
RCT_ENUM_CONVERTER(RNCNSDatePickerStyle, (@{
    @"text": @(NSDatePickerStyleTextField),
    @"text-stepper": @(NSDatePickerStyleTextFieldAndStepper),
    @"clock-calendar": @(NSDatePickerStyleClockAndCalendar),
}), NSDatePickerStyleTextField, integerValue)


//RCT_ENUM_CONVERTER(NSUserInterfaceStyle, (@{
//    @"dark": @(NSUserInterfaceStyleDark),
//    @"light": @(NSUserInterfaceStyleLight),
//}), NSUserInterfaceStyleUnspecified, integerValue)

#pragma clang diagnostic pop


@end

@implementation RNDateTimePickerManager {
  RNDateTimePicker* _picker;
}

RCT_EXPORT_MODULE()

- (instancetype)init {
  if (self = [super init]) {
    _picker = [RNDateTimePicker new];
  }
  return self;
}

+ (BOOL)requiresMainQueueSetup {
  return true;
}

- (NSView *)view
{
  return [RNDateTimePicker new];
}

- (RCTShadowView *)shadowView
{
  RNDateTimePickerShadowView* shadowView = [RNDateTimePickerShadowView new];
  shadowView.picker = _picker;
  return shadowView;
}

+ (NSString*) datepickerStyleToString: (NSDatePickerStyle) style {
    switch (style) {
        case NSDatePickerStyleTextField:
            return @"text";
        case NSDatePickerStyleTextFieldAndStepper:
            return @"text-stepper";
        case NSDatePickerStyleClockAndCalendar:
            return @"clock-calendar";
        default:
            [NSException raise:@"Unsupported style value" format:@"NSDatePickerStyle of %ld is unsupported", (long)style];
            return @"";
    }
}

RCT_EXPORT_SHADOW_PROPERTY(date, NSDate)
RCT_EXPORT_SHADOW_PROPERTY(mode, NSDatePickerMode)
RCT_EXPORT_SHADOW_PROPERTY(locale, NSLocale)
RCT_EXPORT_SHADOW_PROPERTY(displayIOS, RNCNSDatePickerStyle)
RCT_EXPORT_SHADOW_PROPERTY(timeZoneName, NSString)

RCT_EXPORT_VIEW_PROPERTY(date, NSDate)
RCT_EXPORT_VIEW_PROPERTY(locale, NSLocale)
RCT_EXPORT_VIEW_PROPERTY(minimumDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(maximumDate, NSDate)
RCT_EXPORT_VIEW_PROPERTY(minuteInterval, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPickerDismiss, RCTBubblingEventBlock)

RCT_REMAP_VIEW_PROPERTY(mode, datePickerMode, NSDatePickerMode)
RCT_REMAP_VIEW_PROPERTY(timeZoneOffsetInMinutes, timeZone, NSTimeZone)
//
//RCT_CUSTOM_VIEW_PROPERTY(themeVariant, NSUserInterfaceStyle, RNDateTimePicker) {
//    // TODO
////    if (@available(iOS 13.0, *)) {
////        if (json) {
////            NSUserInterfaceStyle propValue = [RCTConvert NSUserInterfaceStyle:json];
////            view.overrideUserInterfaceStyle = propValue;
////        } else {
////            view.overrideUserInterfaceStyle = UserInterfaceStyleUnspecified;
////        }
////    }
//}

RCT_CUSTOM_VIEW_PROPERTY(textColor, NSColor, RNDateTimePicker)
{
  if (@available(iOS 14.0, *)) {
//    if (view.datePickerStyle != UIDatePickerStyleWheels) {
//      // prevents #247
//      return;
//    }
  }
  if (json) {
    [view setValue:[RCTConvert UIColor:json] forKey:@"textColor"];
    [view setValue:@(NO) forKey:@"highlightsToday"];
  } else {
    NSColor* defaultColor;
    if (@available(iOS 13.0, *)) {
        defaultColor = [NSColor labelColor];
    } else {
        defaultColor = [NSColor blackColor];
    }
    [view setValue:defaultColor forKey:@"textColor"];
    [view setValue:@(YES) forKey:@"highlightsToday"];
  }
}

RCT_CUSTOM_VIEW_PROPERTY(accentColor, NSColor, RNDateTimePicker)
{
    // TODO
//    if (json) {
//        [view setTintColor:[RCTConvert NSColor:json]];
//    } else {
//        if (@available(iOS 15.0, *)) {
//            [view setTintColor:[NSColor tintColor]];
//        } else {
//            [view setTintColor:[NSColor systemBlueColor]];
//        }
//    }
}

// TODO vonovak setting preferredDatePickerStyle invalidates minuteinterval
RCT_CUSTOM_VIEW_PROPERTY(displayIOS, RNCNSDatePickerStyle, RNDateTimePicker)
{
    // officially since 13.4 (https://developer.apple.com/documentation/uikit/uidatepickerstyle?language=objc) but practically since 14
//    if (@available(iOS 14.0, *)) {
//        if (json) {
//            UIDatePickerStyle propValue = [RCTConvert RNCUIDatePickerStyle:json];
//            view.preferredDatePickerStyle = propValue;
//        } else {
//            view.preferredDatePickerStyle = UIDatePickerStyleAutomatic;
//        }
//    }
}

RCT_CUSTOM_VIEW_PROPERTY(timeZoneName, NSString, RNDateTimePicker)
{
    if (json) {
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:json];
        if (timeZone == nil) {
            RCTLogWarn(@"'%@' does not exist in NSTimeZone.knownTimeZoneNames fallback to localTimeZone=%@", json, NSTimeZone.localTimeZone.name);
            view.timeZone = NSTimeZone.localTimeZone;
        } else {
            view.timeZone = timeZone;
        }
    } else {
        view.timeZone = NSTimeZone.localTimeZone;
    }
}

@end
