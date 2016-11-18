import React from 'react';
import Relay from 'react-relay';
import TreeView from 'react-treeview';
import Method from './Method';

class Klass extends React.Component {
  render() {
    var {klass} = this.props;
    return (
      <TreeView key={klass.id} nodeLabel={klass.name} defaultCollapsed={true}>
        {klass.methods.map(method => (
          <Method key={method.id} inspector={this.props.inspector} method={method} />
        ))}
      </TreeView>
    );
  }
}

export default Relay.createContainer(Klass, {
  fragments: {
    klass: () => Relay.QL`
      fragment on Class {
        name,
        methods {
          id,
          ${Method.getFragment('method')}
        }
      }
    `,
  }
});
