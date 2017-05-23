import React from 'react';
import ReactDOM from 'react-dom';
import { WidgetWizard, Title } from 'rw-components';

const WidgetNew = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge -p-primary">
        New Widget
      </Title>
      <WidgetWizard
        application={['rw']}
        authorization={gon.data.authorization}
        dataset={gon.data.dataset_id}
        onSubmit={() => window.location = `/datasets/${gon.data.dataset_id}/widgets`}
      />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<WidgetNew />, document.getElementById('pageContent'));
});
