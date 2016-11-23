import React from 'react';
import Relay from 'react-relay';

class ClassDetail extends React.Component {
  render() {
    var klass = this.props.store;
    if (klass) {
      return (
        <div className="pane-content">
          <h1 className="inset">{klass.name}</h1>
          <hr />
          {klass.ancestors.map(anc => (
            <div key={anc.id}>
              <h2 className="ancestor inset">Defined on <span className={"module"}>{anc.name}</span></h2>
              <ul className="methods inset">
                {anc.methods.map(method => (
                  <li key={method.id} className={method.visibility}>
                    <a onClick={() => this.props.controller.setFocusMethod(method)} href="#">
                      {method.name}
                    </a>
                  </li>
                ))}
              </ul>
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
        demodulized_name,
        ancestors {
          id,
          name,
          methods {
            id,
            name,
            visibility,
          }
        }
      }
    `,
  },
});
