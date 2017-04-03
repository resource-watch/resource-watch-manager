import React from 'react';
import ReactDOM from 'react-dom';
import { DatasetTable, Title } from 'rw-components';

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
          />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetIndex />, document.getElementById('pageContent'));
});
