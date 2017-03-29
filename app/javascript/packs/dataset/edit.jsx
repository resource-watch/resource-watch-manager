import React from 'react';
import ReactDOM from 'react-dom';
import DatasetForm from 'rw-components/dist/components/Dataset/Form';
import Title from 'rw-components/dist/components/UI/Title';

const DatasetEdit = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge">
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
