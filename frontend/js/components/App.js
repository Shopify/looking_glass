import React from 'react';
import Relay from 'react-relay';
import SplitPane from 'react-split-pane';

import ClassTreeItemList from './ClassTreeItemList';
import Details from './Details';

class App extends React.Component {
  _setObject = (obj) => {
    this.props.relay.setVariables({focusObj: obj});
  }

  render() {
    var {classes, method} = this.props.store;
    return (
      <SplitPane split="vertical" minSize={50} defaultSize={400}>
        <ClassTreeItemList
          store={classes}
          inspector={this._setObject} />
        <Details store={method} />
      </SplitPane>
    );
  }
}

export default Relay.createContainer(App, {
  initialVariables: {
    focusObj: null,
    methodId: "-1",
  },

  prepareVariables: (prevVariables) => {
    var id = "-1";
    if (prevVariables.focusObj !== null) {
      id = prevVariables.focusObj.__dataID__.toString();
    }
    return {
      ...prevVariables,
      methodId: id,
    };
  },

  fragments: {
    store: (variables) => Relay.QL`
      fragment on Viewer {
        classes {
          ${ClassTreeItemList.getFragment('store')}
        }
        method(id: $methodId) {
          ${Details.getFragment('store')}
        }
      }
    `,
  },
});
