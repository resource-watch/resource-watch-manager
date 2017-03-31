import React from 'react';
import ReactDOM from 'react-dom';
import DatasetTable from 'rw-components/dist/components/Dataset/Table';
import Title from 'rw-components/dist/components/UI/Title';

const classesDic = {
  status: {
    success: '-success',
    failed: '-failed',
    saved: '-saved',
    deleted: '-deleted',
    pending: '-pending'
  }
};

class DatasetIndex extends React.Component {

  getStatusTd(value, i) {
    const className = `status ${classesDic.status[value]}`;
    return <td key={i} className={className}>{value}</td>;
  }

  getEditMetadataAction(value) {
    return value.status === 'saved';
  }

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
              { label: 'status', value: 'status', td: this.getStatusTd },
              { label: 'provider', value: 'provider' }
            ]}
            actions={{
              show: true,
              list: [
                { name: 'Edit', path: 'datasets/:id/edit', show: true },
                { name: 'Remove', path: 'datasets/:id/remove', show: true },
                { name: 'Edit Metadata', path: 'datasets/:id/metadata', show: this.getEditMetadataAction }
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
