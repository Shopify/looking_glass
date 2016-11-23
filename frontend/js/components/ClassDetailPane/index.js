import React from 'react';
import Relay from 'react-relay';
import ClassDetail from './ClassDetail';

class ClassDetailPane extends React.Component {
  render() {
    return (
      <ClassDetail controller={this.props.controller} store={this.props.store} />
    );
  }
}

export default Relay.createContainer(ClassDetailPane, {
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        ${ClassDetail.getFragment('store')},
      }
    `,
  }
})
