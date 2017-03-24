import React from 'react';
import ReactDOM from 'react-dom';
import DatasetForm from 'rw-components/dist/components/Dataset/Form';

console.log('<%= @dataset_id %>');

const DatasetEdit = () => (
  <div className="row">
    <div className="column small-12">
      <h2>Edit Dataset</h2>
      <DatasetForm application={['rw']} />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetEdit />, document.getElementById('pageContent'));
});
