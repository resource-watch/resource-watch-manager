import React from 'react';
import ReactDOM from 'react-dom';
import DatasetTable from 'rw-components/dist/components/Dataset/Table';

const DatasetIndex = () => (
  <div className="row">
    <div className="column small-12">
      <h2>Datasets</h2>
      <DatasetTable application={['rw']} />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetIndex />, document.getElementById('pageContent'));
});
