import React from 'react';
import ReactDOM from 'react-dom';
import { DatasetTable, ButtonContainer, Title } from 'rw-components';

class DatasetIndex extends React.Component {


  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge -p-primary">
            Datasets
          </Title>

          <ButtonContainer
            className="-end"
            buttons={[{
              label: 'New +',
              path: '/datasets/new',
              className: ''
            }]}
          />

          <DatasetTable
            application={['rw']}
            authorization={gon.data.authorization}
          />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetIndex />, document.getElementById('pageContent'));
});
