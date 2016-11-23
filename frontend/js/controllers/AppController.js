export default class AppController {
  constructor(app) {
    this.app = app;
  }

  setActiveMethod(component) {
    if (this.selectedMethod) {
      this.selectedMethod.setState({selected: false});
    }
    component.setState({selected: true});
    this.selectedMethod = component;

    this._setRelayVariables({
      methodId: this._dataID(component.props.store),
    });
  }

  setActiveClassTreeItem(component) {
    if (this.selectedClass) {
      this.selectedClass.setState({selected: false});
    }
    component.setState({selected: true});
    this.selectedClass = component;

    this._setRelayVariables({
      methodId: "-1",
      classId: this._dataID(component.props.store),
    });
  }

  _dataID(obj) {
    return obj === null ? "-1" : obj.__dataID__.toString();
  }

  _setRelayVariables(vars) {
    return this.app.props.relay.setVariables(vars);
  }
}
