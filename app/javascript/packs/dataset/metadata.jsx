import React from 'react';
import ReactDOM from 'react-dom';
import MetadataForm from 'rw-components/dist/components/metadata/form/MetadataForm';
import Title from 'rw-components/dist/components/UI/Title';

class DatasetMetadata extends React.Component {

  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge">
            Dataset metadata
          </Title>
          <MetadataForm
            application={['rw']}
            authorization={gon.data.authorization}
            language="en"
            dataset={gon.data.dataset_id}
            />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetMetadata />, document.getElementById('pageContent'));
});
