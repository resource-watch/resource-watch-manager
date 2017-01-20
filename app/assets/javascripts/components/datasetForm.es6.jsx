class DatasetForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      step: 2,
      form: {
        // STEP 1
        name: '',
        provider: 'csv',
        subtitle: '',
        tags: '',
        application: [props.application],
        topics: [],

        // STEP 2
        connectorType: '',
        legend: {
          lat: null,
          long: null,
          date: [],
          country: []
        }
      }
    };

    this.onSubmit = this.onSubmit.bind(this);
    this.onChange = this.onChange.bind(this);
  }

  /**
   * UI EVENTS
   * - onSubmit
   * - onChange
  */
  onSubmit(event) {
    console.log(this.state);
    event.preventDefault();
  }

  onChange(obj) {
    const form = Object.assign({}, this.state.form, obj);
    this.setState({ form }, () => console.log(this.state.form));
  }

  render() {
    return (
      <form className="c-form" onSubmit={this.onSubmit}>
        {(this.state.step === 1) ? <Step1 providerDictionay={PROVIDERDICTIONARY} onChange={value => this.onChange(value)} form={this.state.form} /> : null}

        {(this.state.step === 2) ? <Step2 providerDictionay={PROVIDERDICTIONARY} onChange={value => this.onChange(value)} form={this.state.form} /> : null}

        {(this.state.step === 3) ? <Step3 providerDictionay={PROVIDERDICTIONARY} onChange={value => this.onChange(value)} form={this.state.form} /> : null}

        <fieldset className="actions">
          <ol>
            <li className="action input_action " id="admin_user_submit_action">
              <input type="submit" name="commit" value="Create Admin user" data-disable-with="Create Admin user" />
            </li>
            <li className="cancel">
              <a href="/admin/admin_users">Cancel</a>
            </li>
          </ol>
        </fieldset>
      </form>
    );
  }
}

DatasetForm.propTypes = {
  application: React.PropTypes.string
};
