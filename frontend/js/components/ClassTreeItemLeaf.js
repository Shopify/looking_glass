import React from 'react';
import Relay from 'react-relay';

class ClassTreeItemLeaf extends React.Component {
  render() {
    var klass = this.props.store;
    return (
      <div className={"leaf"}><a href="#">{klass.demodulized_name}</a></div>
    );
  }
}

export default Relay.createContainer(ClassTreeItemLeaf, {
  initialVariables: {
    expanded: false,
  },
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        demodulized_name,
      }
    `,
  }
});
