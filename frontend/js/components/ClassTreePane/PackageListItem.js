import React from 'react';
import Relay from 'react-relay';
import ClassTreeItemList from './ClassTreeItemList';
import PackageList from './PackageList';
import TreeView from 'react-treeview';

class PackageListItem extends React.Component {
  _handleClick = () => {
    this.props.relay.setVariables({
      expanded: true,
    });
    return false;
  }

  _defaultExpand = () => {
    return this.props.store.name == 'application';
  }

  componentDidMount() {
    if (this._defaultExpand()) {
      this._handleClick();
    }
  }

  render() {
    var pkg = this.props.store || [];

    var subpackages = [];
    var classes = [];

    (pkg.children || []).forEach(child => {
      if (child.__typename == "Package") {
        subpackages.push(child);
      } else {
        classes.push(child);
      }
    })

    return (
      <TreeView
        onClick={this._handleClick}
        key={pkg.id}
        nodeLabel={<a className={"package-type"} href="#">{pkg.name}</a>}
        defaultCollapsed={!this._defaultExpand()}
      >
        <PackageList
          store={subpackages}
          controller={this.props.controller} />
        <ClassTreeItemList
          store={classes}
          controller={this.props.controller} />
      </TreeView>
    );
  }
}

export default Relay.createContainer(PackageListItem, {
  initialVariables: {
    expanded: false,
  },
  fragments: {
    store: () => Relay.QL`
      fragment on Package {
        id,
        name,
        children @include(if: $expanded) {
          __typename,
          ${ClassTreeItemList.getFragment('store')},
          ${PackageList.getFragment('store')},
        }
      }
    `,
  }
});
