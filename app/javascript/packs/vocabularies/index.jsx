import React from 'react';
import ReactDOM from 'react-dom';
import { VocabulariesForm } from 'rw-components';

class VocabulariesIndex extends React.Component {

  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <VocabulariesForm
            application={'rw'}
            authorization={gon.data.authorization}
            language="en"
          />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<VocabulariesIndex />, document.getElementById('pageContent'));
});
