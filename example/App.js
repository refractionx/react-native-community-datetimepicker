import React, {Component} from 'react';
import {StyleSheet, View, Text} from 'react-native';
import DatePicker from 'react-native-datetimepicker';

type Props = {};
export default class App extends Component<Props> {
  constructor(props) {
    super(props);
    this.state = {chosenDate: new Date()};

    this.setDate = this.setDate.bind(this);
  }

  setDate(newDate) {
    this.setState({chosenDate: newDate});
  }

  render() {
    return (
      <View style={styles.container}>
        <Text>Example Datetime Picker</Text>
        <DatePicker date={this.state.chosenDate} onDateChange={this.setDate} />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});
