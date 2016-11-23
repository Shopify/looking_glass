export default class AppController {
  constructor(app) {
    this.app = app;
  }

  setFocusMethod(obj) {
    this._setRelayVariables({focusMethod: obj});
  }

  setActiveMethod(component) {
    let prevMethod = this._getState("selectedMethod");
    if (prevMethod) {
      prevMethod.setState({selected: false});
    }
    component.setState({selected: true});

    this._setRelayVariables({
      focusMethod: component.props.store,
    });
    this._setState({
      selectedMethod: component,
    })
  }

  setActiveClassTreeItem(component) {
    let prevClass = this._getState("selectedClass");
    if (prevClass) {
      prevClass.setState({selected: false});
    }
    component.setState({selected: true});

    this._setRelayVariables({
      focusMethod: null,
      focusModule: component.props.store,
    });
    this._setState({
      selectedClass: component,
    });
  }

  _setRelayVariables(vars) {
    return this.app.props.relay.setVariables(vars);
  }

  _getState(k) {
    return this.app.state[k];
  }

  _setState(state) {
    return this.app.setState(state);
  }
}
