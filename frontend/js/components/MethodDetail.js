import React from 'react';
import Relay from 'react-relay';
import Highlight from 'react-hljs';

class MethodDetail extends React.Component {
  render() {
    var method = this.props.store;
    if (method) {
      return (
        <div>
          <h1>{method.defining_class.name}#{method.name}</h1>
          <h3>Defined at {method.file}:{method.line}</h3>
          <hr />
          <h2>Source</h2>
          <Highlight key={method.id} className='ruby'>
            {method.comment}
            {method.source}
          </Highlight>
          <h2>Bytecode Disassembly</h2>
          <pre><code className={"hljs"}>{method.bytecode}</code></pre>
          <h2>AST</h2>
          <pre><code className={"hljs"}>{method.sexp}</code></pre>
        </div>
      );
    } else {
      return (
        <p>Click something to get started</p>
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
        defining_class { name }
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
