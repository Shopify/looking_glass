import React from 'react';
import Relay from 'react-relay';
import SplitPane from 'react-split-pane';

import ClassTreePane from './ClassTreePane'
import ClassDetailPane from './ClassDetailPane';
import MethodDetailPane from './MethodDetailPane';

import AppController from '../controllers/AppController'

class App extends React.Component {
  constructor(props) {
    super(props);
    this.controller = new AppController(this);
  }

  render() {
    var {classes, classDetail, methodDetail} = this.props.store;
    return (
      <SplitPane split="vertical" minSize={50} defaultSize={300}>
        <ClassTreePane store={classes} controller={this.controller} />
        <SplitPane split="vertical" minSize={50} defaultSize={300}>
          <ClassDetailPane store={classDetail} controller={this.controller} />
          <MethodDetailPane store={methodDetail} controller={this.controller} />
        </SplitPane>
      </SplitPane>
    );
  }
}

export default Relay.createContainer(App, {
  initialVariables: {
    methodId: "-1",
    classId: "-1",
  },

  fragments: {
    store: (variables) => Relay.QL`
      fragment on Viewer {
        classes {
          ${ClassTreePane.getFragment('store')}
        }
        classDetail(id: $classId) {
          ${ClassDetailPane.getFragment('store')}
        }
        methodDetail(id: $methodId) {
          ${MethodDetailPane.getFragment('store')}
        }
      }
    `,
  },
});
