import React from 'react';
import Relay from 'react-relay';
import PackageList from './PackageList'

class ClassTreePane extends React.Component {
  render() {
    return (
      <PackageList
        className="pane-content"
        store={this.props.store}
        controller={this.props.controller} />
    );
  }
}

export default Relay.createContainer(ClassTreePane, {
  fragments: {
    store: () => Relay.QL`
      fragment on Package @relay(plural: true) {
        ${PackageList.getFragment('store')},
      }
    `,
  }
})
