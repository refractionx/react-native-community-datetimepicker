#import <React/RCTShadowView.h>
#import "RNDateTimePicker.h"

@interface RNDateTimePickerShadowView : RCTShadowView

@property (nullable, nonatomic, strong) RNDateTimePicker *picker;
@property (nonatomic) NSDatePickerMode mode;
@property (nullable, nonatomic, strong) NSDate *date;
@property (nullable, nonatomic, strong) NSLocale *locale;
@property (nonatomic, assign) NSInteger timeZoneOffsetInMinutes;
@property (nullable, nonatomic, strong) NSString *timeZoneName;
@property (nonatomic, assign) NSDatePickerStyle displayIOS;

@end
