import React from 'react';
import Relay from 'react-relay';

class MethodDetail extends React.Component {
  render() {
    var method = this.props.store;
    if (method) {
      return (
        <ul>
        <li>name: {method.name}</li>
        <li>file: {method.file}</li>
        <li>line: {method.line}</li>
        <li>source:<code><pre>{method.source}</pre></code></li>
        <li>bytecode:<code><pre>{method.bytecode}</pre></code></li>
        </ul>
      );
    } else {
      return (
        <p>Click something to get started</p>
      );
    }
  }
}

export default Relay.createContainer(MethodDetail, {
  fragments: {
    store: () => Relay.QL`
      fragment on Method {
        name,
        file,
        line,
        source,
        bytecode,
      }
    `,
  },
});
