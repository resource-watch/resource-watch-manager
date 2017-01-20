class Step2 extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      form: props.form
    };

    this.onLegendChange = this.onLegendChange.bind(this);
  }

  /**
   * HELPERS
   * - getHint
  */
  getHint() {
    const { form } = this.state;
    return PROVIDERDICTIONARY[form.provider].connectorUrlHint;
  }

  /**
   * UI EVENTS
   * - onLegendChange
  */
  onLegendChange(obj) {
    const legend = Object.assign({}, this.props.form.legend, obj);
    this.props.onChange({ legend });
  }

  render() {
    const { currentStep, step } = this.props;

    const hint = this.getHint();

    const activeClass = (currentStep == step) ? '-active' : '';

    return (

      <fieldset className={`c-field-container ${activeClass}`}>
        <Input
          onChange={value => this.props.onChange({ connectorUrl: value })}
          validations={['required']}
          hint={hint}
          properties={{
            name: "connectorUrl",
            label: "Url data endpoint",
            type: 'text',
            defaultValue: this.state.form.connectorUrl,
            required: true
          }}
        />

        {/* CSV additional fields */}
        {(this.state.form.provider) === 'csv' &&
          <Input
            onChange={value => this.onLegendChange({ lat: value })}
            validations={['required']}
            properties={{
              name: "lat",
              label: "Latitude",
              type: 'text',
              defaultValue: this.state.form.legend.lat,
              required: true
            }}
          />
        }
        {(this.state.form.provider) === 'csv' &&
          <Input
            onChange={value => this.onLegendChange({ long: value })}
            validations={['required']}
            properties={{
              name: "long",
              label: "Longitude",
              type: 'text',
              defaultValue: this.state.form.legend.long,
              required: true
            }}
          />
        }
        {(this.state.form.provider) === 'csv' &&
          <Input
            onChange={value => this.onLegendChange({ date: value })}
            validations={['required']}
            properties={{
              name: "date",
              label: "Date",
              type: 'text',
              defaultValue: this.state.form.legend.date,
              required: true
            }}
          />
        }
        {(this.state.form.provider) === 'csv' &&
          <Input
            onChange={value => this.onLegendChange({ country: value })}
            validations={['required']}
            properties={{
              name: "country",
              label: "Country",
              type: 'text',
              defaultValue: this.state.form.legend.country,
              required: true
            }}
          />
        }

      </fieldset>
    );
  }
}

Step2.propTypes = {
  step: React.PropTypes.number,
  form: React.PropTypes.object,
  providerDictionay: React.PropTypes.object
};
