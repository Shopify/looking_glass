import React from 'react';
import Relay from 'react-relay';
import ClassTreeItem from './ClassTreeItem';

class ClassTreeItemList extends React.Component {
  render() {
    var classes = this.props.store || [];
    return (
      <div>
        {classes.map(klass => (
          <ClassTreeItem
            store={klass}
            key={klass.id}
            inspector={this.props.inspector} />
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
