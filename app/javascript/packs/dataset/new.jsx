import React from 'react';
import ReactDOM from 'react-dom';
import { DatasetForm, Title } from 'rw-components';

const DatasetNew = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge -p-primary">
        New Dataset
      </Title>
      <DatasetForm
        application={['rw']}
        authorization={gon.data.authorization}
        onSubmit={() => window.location = "/datasets"}
      />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetNew />, document.getElementById('pageContent'));
});
