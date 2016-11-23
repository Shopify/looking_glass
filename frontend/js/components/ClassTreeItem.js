import React from 'react';
import Relay from 'react-relay';
import TreeView from 'react-treeview';
import MethodTreeItem from './MethodTreeItem';
import ClassTreeItemList from './ClassTreeItemList';
import ClassTreeItemLeaf from './ClassTreeItemLeaf';

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
    if (klass.nested_class_count > 0) {
      var nested = klass.nested_classes || [];
      let type = klass.is_class ? "class-type" : "module-type";
      return (
        <TreeView
          onClick={this._handleClick}
          key={klass.id}
          nodeLabel={
            <a onClick={() => this.props.controller.setFocusModule(klass)} className={type} href="#">
              {klass.demodulized_name}
            </a>
          }
          defaultCollapsed={true}
        >
          <ClassTreeItemList store={nested} controller={this.props.controller} />
        </TreeView>
      );
    } else {
      return (
        <ClassTreeItemLeaf store={klass} controller={this.props.controller} />
      );
    }
  }
}

// var methods = klass.methods || [];
//
// {methods.map(method => (
//   <MethodTreeItem store={method} key={method.id} controller={this.props.controller} />
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
        is_class,
        demodulized_name,
        ${ClassTreeItemLeaf.getFragment('store')}
        nested_class_count,
        nested_classes @include(if: $expanded) {
          id,
          demodulized_name,
          ${ClassTreeItemList.getFragment('store')}
        }
      }
    `,
  }
});
