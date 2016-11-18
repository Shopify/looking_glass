import React from 'react';
import Relay from 'react-relay';

class Method extends React.Component {
  _hasLink(method) {
    return method.file && method.line;
  }
  _link(method) {
    return `file://${method.file}#${method.line}`;
  }
  _visibilityGlyph(method) {
    if (method.visibility == "private") {
      return "-";
    } else if (method.visibility == "public") {
      return "+";
    } else {
      return "#";
    }
  }
  render() {
    var {method} = this.props;
    if (this._hasLink(method)) {
      return (
        <li>{this._visibilityGlyph(method)} <a href={this._link(method)}>{method.name}</a></li>
      );
    } else {
      return (
        <li>{this._visibilityGlyph(method)} {method.name}</li>
      );
    }
  }
}

export default Relay.createContainer(Method, {
  fragments: {
    method: () => Relay.QL`
      fragment on Method {
        name,
        file,
        line,
        visibility,
      }
    `,
  }
});
