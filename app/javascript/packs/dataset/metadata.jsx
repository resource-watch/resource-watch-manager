import React from 'react';
import ReactDOM from 'react-dom';
import Title from 'rw-components/dist/components/UI/Title';

class DatasetMetadata extends React.Component {

  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge">
            Dataset metadata
          </Title>
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<DatasetMetadata />, document.getElementById('pageContent'));
});
