import React from 'react';
import ReactDOM from 'react-dom';
import { MetadataForm, Title } from 'rw-components';

class DatasetMetadata extends React.Component {

  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge -p-primary">
            Metadata
          </Title>
          <MetadataForm
            application={'rw'}
            authorization={gon.data.authorization}
            dataset={gon.data.dataset_id}
            onSubmit={() => window.location = "/datasets"}
          />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetMetadata />, document.getElementById('pageContent'));
});
