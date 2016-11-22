import React from 'react';
import Relay from 'react-relay';

class ClassDetail extends React.Component {
  render() {
    var klass = this.props.store;
    if (klass) {
      return (
        <div>
          <h1>{klass.name}</h1>
          <hr />
          {klass.ancestors.map(anc => (
            <div key={anc.id}>
              <h2 className={"ancestor"}>Defined on <span className={"module"}>{anc.name}</span></h2>
              <ul className={"methods"}>
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
        <p>Click something to get started</p>
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
          name,
          methods {
            name,
            visibility,
          }
        }
      }
    `,
  },
});
