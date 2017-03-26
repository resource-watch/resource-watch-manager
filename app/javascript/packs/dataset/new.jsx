import React from 'react';
import ReactDOM from 'react-dom';
import DatasetForm from 'rw-components/dist/components/Dataset/Form';

const DatasetNew = () => (
  <div className="row">
    <div className="column small-12">
      <h2>New Dataset</h2>
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
