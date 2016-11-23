import React from 'react';
import Relay from 'react-relay';
import MethodDetail from './MethodDetail';

class MethodDetailPane extends React.Component {
  render() {
    return (
      <MethodDetail controller={this.props.controller} store={this.props.store} />
    );
  }
}

export default Relay.createContainer(MethodDetailPane, {
  fragments: {
    store: () => Relay.QL`
      fragment on Method {
        ${MethodDetail.getFragment('store')},
      }
    `,
  }
})
