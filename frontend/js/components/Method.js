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
      return (
        <div>
          <a href="#" onClick={() => this.props.inspector(method)}>
            {this._visibilityGlyph(method)} {method.name}
          </a>
        </div>
      );
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
