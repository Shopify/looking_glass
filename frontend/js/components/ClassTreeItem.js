import React from 'react';
import Relay from 'react-relay';
import TreeView from 'react-treeview';
import MethodTreeItem from './MethodTreeItem';
import ClassTreeItemList from './ClassTreeItemList';

// We have to work around 'class' being a reserved word, so here's the rule:
// When the word would be rendered as 'class' exactly (regardless of whether it
// would be allowed in that context, but excepting strings presented to the
// user), use 'klass' instead. In all other cases ('classes', 'Class', etc.),
// use the normal spelling.

class ClassTreeItem extends React.Component {
  _handleClick = () => {
    this.props.relay.setVariables({
      expanded: true,
    });
  }

  render() {
    var klass = this.props.store;
    var methods = klass.methods || [];
    var nested = klass.nested_classes || [];
    return (
      <TreeView onClick={this._handleClick} key={klass.id} nodeLabel={klass.demodulized_name} defaultCollapsed={true}>
        <ClassTreeItemList store={nested} inspector={this.props.inspector} />
      </TreeView>
    );
  }
}

        // {methods.map(method => (
        //   <MethodTreeItem store={method} key={method.id} inspector={this.props.inspector} />
        // ))}


        // methods @include(if: $expanded) {
        //   ${MethodTreeItem.getFragment('store')}
        // }

export default Relay.createContainer(ClassTreeItem, {
  initialVariables: {
    expanded: false,
  },
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        id,
        demodulized_name,
        nested_classes @include(if: $expanded) {
          ${ClassTreeItemList.getFragment('store')}
        }
      }
    `,
  }
});
