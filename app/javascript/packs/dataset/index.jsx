import React from 'react';
import ReactDOM from 'react-dom';
import { DatasetTable, Title, MetadataAction, StatusTD } from 'rw-components';

class DatasetIndex extends React.Component {

  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge">
            Datasets
          </Title>
          <DatasetTable
            application={['rw']}
            mode='table'
            columns={[
              { label: 'name', value: 'name' },
              { label: 'status', value: 'status', td: StatusTD },
              { label: 'provider', value: 'provider' }
            ]}
            actions={{
              show: true,
              list: [
                { name: 'Edit', path: 'datasets/:id/edit', show: true },
                { name: 'Remove', path: 'datasets/:id/remove', show: true },
                { name: 'Metadata', path: 'datasets/:id/metadata', component: MetadataAction }
              ]
            }}
          />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetIndex />, document.getElementById('pageContent'));
});
