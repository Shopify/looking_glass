import React from 'react';
import Relay from 'react-relay';
import classNames from 'classnames';

class ClassTreeItemLeaf extends React.Component {
  render() {
    var klass = this.props.store;

    let aClasses = classNames({
      "class-type":  klass.isClass,
      "module-type": !klass.isClass,
    })

    let selClasses = classNames({
      selection: true,
      selected:  this.props.selected,
    });

    return (
      <div onClick={this.props.select} className={"leaf"}>
        <div className={selClasses}></div>
        <a className={aClasses} href="#">{klass.demodulizedName}</a>
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
        isClass,
        demodulizedName,
      }
    `,
  }
});
