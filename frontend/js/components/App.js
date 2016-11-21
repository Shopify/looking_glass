import React from 'react';
import Relay from 'react-relay';
import SplitPane from 'react-split-pane';

import ClassTreeItem from './ClassTreeItem';
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
    var classes = this.props.viewer.classes;
    return (
      <SplitPane split="vertical" minSize={50} defaultSize={400}>
        <div>
          {classes.map(klass => (
            <ClassTreeItem key={klass.id} inspector={this._setObject} klass={klass} />
          ))}
        </div>
        <Details method={this.state.detailsObject} />
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
          ${ClassTreeItem.getFragment('klass')}
        }
        method(id: $methodId) {
          ${Details.getFragment('method')}
        }
      }
    `,
  },
});
