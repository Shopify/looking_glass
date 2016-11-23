import React from 'react';
import Relay from 'react-relay';
import classNames from 'classnames';

class MethodListItem extends React.Component {
  constructor(props) {
    super(props);
    this.state = {selected: false};
  }

  render() {
    let method = this.props.store;

    let selClasses = classNames({
      selection: true,
      selected:  this.state.selected,
    });

    return (
      <div style={{position: "relative"}}>
        <div className={selClasses}></div>
        <li onClick={() => this.props.controller.setActiveMethod(this)} className={method.visibility}>
          <a href="#">
            {method.name}
          </a>
        </li>
      </div>
    );
  }
}

export default Relay.createContainer(MethodListItem, {
  fragments: {
    store: () => Relay.QL`
      fragment on Method {
        name,
        visibility,
      }
    `,
  },
});
