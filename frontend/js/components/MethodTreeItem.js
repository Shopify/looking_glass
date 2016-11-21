import React from 'react';
import Relay from 'react-relay';

class MethodTreeItem extends React.Component {
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
    var method = this.props.store;
      return (
        <div>
          <a href="#" onClick={() => this.props.inspector(method)}>
            {this._visibilityGlyph(method)} {method.name}
          </a>
        </div>
      );
  }
}

export default Relay.createContainer(MethodTreeItem, {
  fragments: {
    store: () => Relay.QL`
      fragment on Method {
        name,
        visibility,
      }
    `,
  }
});
