import React from 'react';
import ReactDOM from 'react-dom';
import DatasetTable from 'rw-components/dist/components/Dataset/Table';
import Title from 'rw-components/dist/components/UI/Title';

const DatasetIndex = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge">
      	Datasets
      </Title>
      <DatasetTable application={['rw']} />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetIndex />, document.getElementById('pageContent'));
});
