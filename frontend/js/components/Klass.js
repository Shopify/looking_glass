import React from 'react';
import Relay from 'react-relay';
import Method from './Method';

class Klass extends React.Component {
  render() {
    var {klass} = this.props;
    return (
      <li>
        {klass.name}
        <ul>
          {klass.methods.map(method => (
            <Method method={method} />
          ))}
        </ul>
      </li>
    );
  }
}

export default Relay.createContainer(Klass, {
  fragments: {
    klass: () => Relay.QL`
      fragment on Class {
        name,
        methods {
          ${Method.getFragment('method')}
        }
      }
    `,
  }
});
