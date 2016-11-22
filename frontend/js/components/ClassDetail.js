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
          <ul className={"methods"}>
            {klass.methods.map(method => (
              <li className={method.visibility}>
                <a href="#">
                  {method.name}
                </a>
              </li>
            ))}
          </ul>
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
        methods {
          name,
          visibility,
        }
      }
    `,
  },
});
