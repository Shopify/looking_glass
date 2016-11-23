import React from 'react';
import Relay from 'react-relay';

class ClassTreeItemLeaf extends React.Component {
  render() {
    var klass = this.props.store;
    let type = klass.is_class ? "class-type" : "module-type";
    return (
      <div className={"leaf"}>
        <a onClick={() => this.props.controller.setFocusModule(klass)} className={type} href="#">
          {klass.demodulized_name}
        </a>
      </div>
    );
  }
}

export default Relay.createContainer(ClassTreeItemLeaf, {
  initialVariables: {
    expanded: false,
  },
  fragments: {
    store: () => Relay.QL`
      fragment on Class {
        is_class,
        demodulized_name,
      }
    `,
  }
});
