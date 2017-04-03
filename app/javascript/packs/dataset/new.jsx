import React from 'react';
import ReactDOM from 'react-dom';
import DatasetForm from 'rw-components/dist/components/Dataset/Form';
import Title from 'rw-components/dist/components/UI/Title';

const DatasetNew = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge -p-primary">
        New Dataset
      </Title>
      <DatasetForm
        application={['rw']}
        authorization={gon.data.authorization}
      />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetNew />, document.getElementById('pageContent'));
});
