import React from 'react';
import Relay from 'react-relay';
import Klass from './Klass';

class App extends React.Component {
  render() {
    var klasses = this.props.viewer.classes;
    return (
      <div>
        <ul>
          {klasses.map(klass => (
            <Klass klass={klass} />
          ))}
        </ul>
      </div>
    );
  }
}

export default Relay.createContainer(App, {
  fragments: {
    viewer: () => Relay.QL`
      fragment on Viewer {
        classes {
          ${Klass.getFragment('klass')}
        }
      }
    `,
  },
});
