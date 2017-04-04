import React from 'react';
import ReactDOM from 'react-dom';
import { VocabulariesForm, Title } from 'rw-components';

class DatasetVocabularies extends React.Component {

  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge -p-primary">
            Vocabularies
          </Title>
          <VocabulariesForm
            application={'rw'}
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
  ReactDOM.render(<DatasetVocabularies />, document.getElementById('pageContent'));
});
