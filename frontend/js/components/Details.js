import React from 'react';
import Relay from 'react-relay';

class Details extends React.Component {
  render() {
    var {method} = this.props.relay;
    if (method) {
      return (
        <ul>
        <li>name: {method.name}</li>
        </ul>
      );
    } else {
      return (
        <p>Click something to get started</p>
      );
    }
  }
}

export default Relay.createContainer(Details, {
  fragments: {
    method: () => Relay.QL`
      fragment on Method {
        name,
        file,
        line,
        source,
      }
    `,
  },
});
