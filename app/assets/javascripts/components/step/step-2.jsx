class Step2 extends React.Component {
  constructor(props) {
    super(props);

    this.children = [];

    this.state = {
      form: props.form
    };

    this.onLegendChange = this.onLegendChange.bind(this);
  }

  validate() {
    this.children.forEach((c) => {
      c.triggerValidate();
    });
  }

  isValid() {
    const valid = this.children.map(c => {
      return c.isValid()
    }).filter(v => {
      return v !== null
    }).every(element => element);

    return valid;
  }

  shouldComponentUpdate(){
    this.children = [];
    return true
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
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ connectorUrl: value })}
          validations={['required', 'url']}
          hint={hint}
          properties={{
            name: "connectorUrl",
            label: "Url data endpoint",
            type: 'text',
            default: this.state.form.connectorUrl,
            required: true
          }}
        />

        {/* CSV additional fields */}
        {(this.state.form.provider) === 'csv' &&
          <Input
            ref={(c) => { c && this.children.push(c) }}
            onChange={value => this.onLegendChange({ lat: value })}
            hint="Name of column with latitude value"
            properties={{
              name: "lat",
              label: "Latitude",
              type: 'text',
              default: this.state.form.legend.lat
            }}
          />
        }
        {(this.state.form.provider) === 'csv' &&
          <Input
            ref={(c) => { c && this.children.push(c) }}
            onChange={value => this.onLegendChange({ long: value })}
            hint="Name of column with longitude value"
            properties={{
              name: "long",
              label: "Longitude",
              type: 'text',
              default: this.state.form.legend.long
            }}
          />
        }
        {(this.state.form.provider) === 'csv' &&
          <Input
            ref={(c) => { c && this.children.push(c) }}
            onChange={value => this.onLegendChange({ date: value })}
            hint="Name of columns with date value (ISO Format)"
            properties={{
              name: "date",
              label: "Date",
              type: 'text',
              default: this.state.form.legend.date
            }}
          />
        }
        {(this.state.form.provider) === 'csv' &&
          <Input
            ref={(c) => { c && this.children.push(c) }}
            onChange={value => this.onLegendChange({ country: value })}
            hint="Name of columns with country value (ISO3 code)"
            properties={{
              name: "country",
              label: "Country",
              type: 'text',
              default: this.state.form.legend.country
            }}
          />
        }

      </fieldset>
    );
  }
}

Step2.propTypes = {
  step: React.PropTypes.number,
  form: React.PropTypes.object
};
