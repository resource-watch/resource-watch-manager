import React from 'react';
import ReactDOM from 'react-dom';
import { WidgetTable, ButtonContainer, Title } from 'rw-components';

class WidgetIndex extends React.Component {
  render() {
    return (
      <div className="row">
        <div className="column small-12">
          <Title className="-huge -p-primary">
            Widgets
          </Title>

          <ButtonContainer
            className="-end"
            buttons={[{
              label: 'New +',
              path: `/datasets/${gon.data.dataset_id}/widgets/new`,
              className: ''
            }]}
          />

          <WidgetTable
            application={['rw']}
            dataset={gon.data.dataset_id}
            authorization={gon.data.authorization}
          />
        </div>
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', (e) => {
  ReactDOM.render(<WidgetIndex />, document.getElementById('pageContent'));
});
