import React from 'react';
import Relay from 'react-relay';
import ClassTreeItemList from './ClassTreeItemList'

class ClassTreePane extends React.Component {
  render() {
    return (
      <ClassTreeItemList
        className="pane-content"
        store={this.props.store}
        controller={this.props.controller} />
    );
  }
}

export default Relay.createContainer(ClassTreePane, {
  fragments: {
    store: () => Relay.QL`
      fragment on Class @relay(plural: true) {
        ${ClassTreeItemList.getFragment('store')},
      }
    `,
  }
})
