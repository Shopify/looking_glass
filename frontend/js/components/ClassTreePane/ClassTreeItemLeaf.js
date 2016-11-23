import React from 'react';
import Relay from 'react-relay';
import classNames from 'classnames';

class ClassTreeItemLeaf extends React.Component {
  render() {
    var klass = this.props.store;

    let aClasses = classNames({
      "class-type":  klass.is_class,
      "module-type": !klass.is_class,
    })

    let selClasses = classNames({
      selection: true,
      selected:  this.props.selected,
    });

    return (
      <div onClick={this.props.select} className={"leaf"}>
        <div className={selClasses}></div>
        <a className={aClasses} href="#">{klass.demodulized_name}</a>
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
