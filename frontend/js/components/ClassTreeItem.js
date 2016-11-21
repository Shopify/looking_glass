import React from 'react';
import Relay from 'react-relay';
import TreeView from 'react-treeview';
import MethodTreeItem from './MethodTreeItem';

// We have to work around 'class' being a reserved word, so here's the rule:
// When the word would be rendered as 'class' exactly (regardless of whether it
// would be allowed in that context, but excepting strings presented to the
// user), use 'klass' instead. In all other cases ('classes', 'Class', etc.),
// use the normal spelling.

class ClassTreeItem extends React.Component {
  render() {
    var klass = this.props.store;
    return (
      <TreeView key={klass.id} nodeLabel={klass.name} defaultCollapsed={true}>
        {klass.methods.map(method => (
          <MethodTreeItem store={method} key={method.id} inspector={this.props.inspector} />
        ))}
      </TreeView>
    );
  }
}

export default Relay.createContainer(ClassTreeItem, {
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        name,
        methods {
          id,
          ${MethodTreeItem.getFragment('store')}
        }
      }
    `,
  }
});
