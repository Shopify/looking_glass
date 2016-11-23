import React from 'react';
import Relay from 'react-relay';
import SplitPane from 'react-split-pane';

import ClassTreeItemList from './ClassTreeItemList';
import ClassDetail from './ClassDetail';
import MethodDetail from './MethodDetail';

class App extends React.Component {
  controller = {
    setFocusMethod: (obj) => {
      this.props.relay.setVariables({focusMethod: obj});
    },

    setActiveMethod: (component) => {
      let prevMethod = this.state.selectedMethod;
      if (prevMethod) {
        prevMethod.setState({selected: false});
      }
      component.setState({selected: true});

      this.props.relay.setVariables({
        focusMethod: component.props.store,
      });
      this.setState({
        selectedMethod: component,
      })
    },

    setActiveClassTreeItem: (component) => {
      let prevClass = this.state.selectedClass;
      if (prevClass) {
        prevClass.setState({selected: false});
      }
      component.setState({selected: true});

      this.props.relay.setVariables({
        focusMethod: null,
        focusModule: component.props.store,
      });
      this.setState({
        selectedClass: component,
      });
    },
  }

  constructor(props) {
    super(props);
    this.state = {
      selectedClass:  null,
      selectedMethod: null,
    };
  }

  render() {
    var {classes, class_detail, method_detail} = this.props.store;
    return (
      <SplitPane split="vertical" minSize={50} defaultSize={300}>
        <ClassTreeItemList
          className="pane-content"
          store={classes}
          controller={this.controller} />
        <SplitPane split="vertical" minSize={50} defaultSize={300}>
          <ClassDetail controller={this.controller} store={class_detail} />
          <MethodDetail controller={this.controller} store={method_detail} />
        </SplitPane>
      </SplitPane>
    );
  }
}

export default Relay.createContainer(App, {
  initialVariables: {
    focusModule: null,
    focusMethod: null,
    methodId: "-1",
    classId: "-1",
  },

  prepareVariables: (prevVariables) => {
    var oid = "-1";
    if (prevVariables.focusMethod !== null) {
      oid = prevVariables.focusMethod.__dataID__.toString();
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
        method_detail(id: $methodId) {
          ${MethodDetail.getFragment('store')}
        }
      }
    `,
  },
});
