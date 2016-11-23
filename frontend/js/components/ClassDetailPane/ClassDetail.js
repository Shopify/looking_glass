import React from 'react';
import Relay from 'react-relay';
import TreeView from 'react-treeview';
import MethodListItem from './MethodListItem'

class ClassDetail extends React.Component {
  render() {
    var klass = this.props.store;

    if (klass) {
      return (
        <div className="class-detail pane-content">
          <h1 className="inset">{klass.name}</h1>
          <hr />
          {klass.ancestors.map(anc => (
            <div key={anc.id}>
              <TreeView
                nodeLabel={
                  <span>Defined on <span className={"module"}>{anc.name}</span></span>
                }
                defaultCollapsed={false}
              >
                <ul className="methods inset">
                  {anc.methods.map(method => (
                    <MethodListItem key={method.id} store={method} controller={this.props.controller} />
                  ))}
                </ul>
              </TreeView>
            </div>
          ))}
        </div>
      );
    } else {
      return (
        <div />
        // <p className="inset pane-content">Click something to get started</p>
      );
    }
  }
}

export default Relay.createContainer(ClassDetail, {
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        name,
        is_class,
        demodulized_name,
        ancestors {
          id,
          name,
          methods {
            id,
            ${MethodListItem.getFragment('store')},
          }
        }
      }
    `,
  },
});
