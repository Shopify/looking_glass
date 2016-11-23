import React from 'react';
import Relay from 'react-relay';
import ClassTreeItem from './ClassTreeItem';
import MethodTreeItem from './MethodTreeItem';

class ClassTreeItemList extends React.Component {
  render() {
    var classes = this.props.store || [];
    return (
      <div className={this.props.className}>
        {classes.map(klass => (
          <ClassTreeItem
            store={klass}
            key={klass.id}
            controller={this.props.controller} />
        ))}
      </div>
    );
  }
}

export default Relay.createContainer(ClassTreeItemList, {
  fragments: {
    store: () => Relay.QL`
      fragment on Class @relay(plural: true) {
        id,
        ${ClassTreeItem.getFragment('store')}
      }
    `,
  }
});
