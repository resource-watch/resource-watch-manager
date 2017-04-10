import React from 'react';
import ReactDOM from 'react-dom';
import { DatasetForm, Title }  from 'rw-components';

const DatasetEdit = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge -p-primary">
        Edit Dataset
      </Title>
      <DatasetForm
        application={['rw']}
        authorization={gon.data.authorization}
        dataset={gon.data.id}
      />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetEdit />, document.getElementById('pageContent'));
});
