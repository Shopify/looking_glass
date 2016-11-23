import React from 'react';
import Relay from 'react-relay';
import TreeView from 'react-treeview';
import classNames from 'classnames';
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
    console.log( "hc" );
    this.props.relay.setVariables({
      expanded: true,
    });
    return false;
  }

  _setSelected = (evt) => {
    console.log( "setsel" );
    // I thought we could just stop event propagation but it doesn't seem to be
    // working...
    if (evt.target.classList.contains('tree-view_arrow')) {
      return;
    }
    this.props.controller.setActiveClassTreeItem(this);
    return false;
  }

  constructor(props) {
    super(props);
    this.state = {selected: false};
  }

  render() {
    var klass = this.props.store;

    let divClasses = classNames({
      selection: true,
      selected:  this.state.selected,
    });

    if (klass.nestedClassCount > 0) {
      var nested = klass.nestedClasses || [];
      let type = klass.isClass ? "class-type" : "module-type";
      return (
        <TreeView
          onClick={this._handleClick}
          key={klass.id}
          nodeLabel={
            <span onClick={this._setSelected}>
              <div className={divClasses}></div>
              <a className={type} href="#">
                {klass.demodulizedName}
              </a>
            </span>
          }
          defaultCollapsed={true}
        >
          <ClassTreeItemList store={nested} controller={this.props.controller} />
        </TreeView>
      );
    } else {
      return (
        <ClassTreeItemLeaf
          selected={this.state.selected}
          select={this._setSelected}
          store={klass}
          controller={this.props.controller}
        />
      );
    }
  }
}

export default Relay.createContainer(ClassTreeItem, {
  initialVariables: {
    expanded: false,
  },
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        id,
        isClass,
        demodulizedName,
        ${ClassTreeItemLeaf.getFragment('store')}
        nestedClassCount,
        nestedClasses @include(if: $expanded) {
          id,
          demodulizedName,
          ${ClassTreeItemList.getFragment('store')}
        }
      }
    `,
  }
});
