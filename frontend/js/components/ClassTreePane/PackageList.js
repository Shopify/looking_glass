import React from 'react';
import Relay from 'react-relay';
import PackageListItem from './PackageListItem';

class PackageList extends React.Component {
  render() {
    var packages = this.props.store || [];
    return (
      <div className={this.props.className}>
        {packages.map(pkg => (
          <PackageListItem
            store={pkg}
            key={pkg.id}
            controller={this.props.controller} />
        ))}
      </div>
    );
  }
}

export default Relay.createContainer(PackageList, {
  fragments: {
    store: () => Relay.QL`
      fragment on Package @relay(plural: true) {
        id,
        ${PackageListItem.getFragment('store')},
      }
    `,
  }
});
