import 'babel-polyfill';
import 'whatwg-fetch';

import React from 'react';
import ReactDOM from 'react-dom';
import Relay from 'react-relay';

import {
  RelayNetworkLayer, urlMiddleware, deferMiddleware
} from 'react-relay-network-layer';

import App from './components/App';
import AppHomeRoute from './routes/AppHomeRoute';

Relay.injectNetworkLayer(new RelayNetworkLayer([
  urlMiddleware({
    url: '/graphql',
    batchUrl: '/graphql/batch',
  }),
  deferMiddleware(),
], { disableBatchQuery: false }));

ReactDOM.render(
  <Relay.Renderer
    environment={Relay.Store}
    Container={App}
    queryConfig={new AppHomeRoute()}
  />,
  document.getElementById('root')
);
