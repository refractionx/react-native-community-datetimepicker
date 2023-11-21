/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * This is a controlled component version of RNDateTimePicker
 *
 * @format
 * @flow strict-local
 */
import RNDateTimePicker from './picker';
import {dateToMilliseconds, sharedPropsValidation} from './utils';
import {
  MACOS_DISPLAY,
  EVENT_TYPE_SET,
  EVENT_TYPE_DISMISSED,
  MACOS_MODE,
} from './constants';
import * as React from 'react';
import {Platform} from 'react-native';

import type {
  DateTimePickerEvent,
  NativeEventIOS,
  MACOSSNativeProps,
  MACOSDisplay,
} from './types';

const getDisplaySafe = (display: MACOSDisplay): MACOSDisplay => {

  return display;
};

export default function Picker({
  value,
  locale,
  maximumDate,
  minimumDate,
  minuteInterval,
  timeZoneOffsetInMinutes,
  timeZoneName,
  textColor,
  accentColor,
  themeVariant,
  onChange,
  mode = MACOS_MODE.single,
  display: providedDisplay = MACOS_DISPLAY.text,
  disabled = false,
  ...other
}: MACOSSNativeProps): React.Node {
  sharedPropsValidation({value, timeZoneOffsetInMinutes, timeZoneName});

  const display = getDisplaySafe(providedDisplay);

  const _onChange = (event: NativeEventIOS) => {
    const timestamp = event.nativeEvent.timestamp;
    const unifiedEvent: DateTimePickerEvent = {
      ...event,
      type: EVENT_TYPE_SET,
    };

    const date = timestamp !== undefined ? new Date(timestamp) : undefined;

    onChange && onChange(unifiedEvent, date);
  };

  const onDismiss = () => {
    // TODO introduce separate onDismissed event listener
    onChange &&
      onChange(
        {
          type: EVENT_TYPE_DISMISSED,
          nativeEvent: {
            timestamp: value.getTime(),
            utcOffset: 0, // TODO vonovak - the dismiss event should not carry any date information
          },
        },
        value,
      );
  };

  return (
    <RNDateTimePicker
      {...other}
      date={dateToMilliseconds(value)}
      locale={locale !== null && locale !== '' ? locale : undefined}
      maximumDate={dateToMilliseconds(maximumDate)}
      minimumDate={dateToMilliseconds(minimumDate)}
      mode={mode}
      minuteInterval={minuteInterval}
      timeZoneOffsetInMinutes={timeZoneOffsetInMinutes}
      timeZoneName={timeZoneName}
      onChange={_onChange}
      onPickerDismiss={onDismiss}
      textColor={textColor}
      accentColor={accentColor}
      themeVariant={themeVariant}
      onStartShouldSetResponder={() => true}
      onResponderTerminationRequest={() => false}
      displayIOS={display}
      enabled={disabled !== true}
    />
  );
}
