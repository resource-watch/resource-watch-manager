import React from 'react';
import ReactDOM from 'react-dom';
import { WidgetWizard, Title } from 'rw-components';

const WidgetEdit = () => (
  <div className="row">
    <div className="column small-12">
      <Title className="-huge -p-primary">
        Edit Widget
      </Title>
      <WidgetWizard
        application={['rw']}
        authorization={gon.data.authorization}
        dataset={gon.data.dataset_id}
        widget={gon.data.id}
        onSubmit={() => window.location = `/datasets/${gon.data.dataset_id}/widgets`}
      />
    </div>
  </div>
);

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<WidgetEdit />, document.getElementById('pageContent'));
});
