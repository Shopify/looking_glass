import React from 'react';
import Relay from 'react-relay';
import Highlight from 'react-hljs';

class MethodDetail extends React.Component {
  render() {
    var method = this.props.store;
    if (method) {
      return (
        <div className="pane-content">
          <h1 className="inset">{method.definingClass.name}#{method.name}</h1>
          <h3 className="inset">Defined at {method.file}:{method.line}</h3>
          <hr />
          <h2 className="inset">Source</h2>
          <Highlight key={method.id} className='ruby'>
            {method.comment}
            {method.source}
          </Highlight>
          <h2 className="inset">Bytecode Disassembly</h2>
          <pre><code className={"hljs"}>{method.bytecode}</code></pre>
          <h2 className="inset">AST</h2>
          <pre><code className={"hljs"}>{method.sexp}</code></pre>
        </div>
      );
    } else {
      return (
        <div />
        // <p className="inset pane-content">Click something to get started</p>
      );
    }
  }
}

export default Relay.createContainer(MethodDetail, {
  fragments: {
    store: () => Relay.QL`
      fragment on Method {
        id,
        name,
        definingClass { name }
        file,
        line,
        source,
        comment,
        bytecode,
        sexp,
      }
    `,
  },
});
