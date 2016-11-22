import React from 'react';
import Relay from 'react-relay';
import SplitPane from 'react-split-pane';

import ClassTreeItemList from './ClassTreeItemList';
import ClassDetail from './ClassDetail';

class App extends React.Component {
  controller = {
    setFocusModule: (obj) => {
      console.log('neat');
      this.props.relay.setVariables({focusModule: obj});
    },
    setFocusObject: (obj) => {
      this.props.relay.setVariables({focusObj: obj});
    },
  }

  render() {
    var {classes, class_detail} = this.props.store;
    return (
      <SplitPane split="vertical" minSize={50} defaultSize={300}>
        <ClassTreeItemList
          store={classes}
          controller={this.controller} />
        <ClassDetail store={class_detail} />
      </SplitPane>
    );
  }
}

export default Relay.createContainer(App, {
  initialVariables: {
    focusModule: null,
    focusObj: null,
    methodId: "-1",
    classId: "-1",
  },

  prepareVariables: (prevVariables) => {
    var oid = "-1";
    if (prevVariables.focusObj !== null) {
      oid = prevVariables.focusObj.__dataID__.toString();
    }
    var mid = "-1";
    if (prevVariables.focusModule !== null) {
      mid = prevVariables.focusModule.__dataID__.toString();
    }
    return {
      ...prevVariables,
      methodId: oid,
      classId: mid,
    };
  },

  fragments: {
    store: (variables) => Relay.QL`
      fragment on Viewer {
        classes {
          ${ClassTreeItemList.getFragment('store')}
        }
        class_detail(id: $classId) {
          ${ClassDetail.getFragment('store')}
        }
      }
    `,
  },
});
