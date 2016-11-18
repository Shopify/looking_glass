import React from 'react';
import Relay from 'react-relay';
import SplitPane from 'react-split-pane';

import Klass from './Klass';
import Details from './Details';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      detailsObject: null,
    };
  }
  _setObject = (obj) => {
    this.setState({
      detailsObject: obj,
    });
    this.props.relay.setVariables({methodId: obj.__dataID__});
  }
  render() {
    var klasses = this.props.viewer.classes;
    return (
      <SplitPane split="vertical" minSize={50} defaultSize={400}>
        <div>
          {klasses.map(klass => (
            <Klass key={klass.id} inspector={this._setObject} klass={klass} />
          ))}
        </div>
        <div>
          <Details method={this.state.detailsObject} />
        </div>
      </SplitPane>
    );
  }
}

export default Relay.createContainer(App, {
  initialVariables: {
    methodId: "-1",
  },
  fragments: {
    viewer: (variables) => Relay.QL`
      fragment on Viewer {
        classes {
          id,
          ${Klass.getFragment('klass')}
        }
        method(id: $methodId) {
          ${Details.getFragment('method')}
        }
      }
    `,
  },
});
