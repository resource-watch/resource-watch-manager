import React from 'react';
import ReactDOM from 'react-dom';
// import DatasetTable from 'rw-components';
import DatasetTable from 'rw-components/dist/components/Dataset/Table';

const DatasetIndex = () => (
  <div className="row">
    <div className="column small-12">
      <h2>Datasets</h2>
      <DatasetTable 
        application={['rw']} 
        mode='table'
        columns={[
          {label: 'name', value: 'name'}, 
          {label: 'status', value: 'status'},
          {label: 'provider', value: 'provider'}
        ]}
        actions={{
          show: true,
          list: [
            { name: 'Edit', path: 'datasets/:id/edit', show: true },
            { name: 'Remove', path: 'datasets/:id/remove', show: true }
          ]
        }}
      />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetIndex />, document.getElementById('pageContent'));
});
