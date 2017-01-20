class Select extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      valid: null,
      error: null
    }

    // BINDINGS
    this.onChange = this.onChange.bind(this);
    this.onValidate = this.onValidate.bind(this);
  }

  /**
   * UI EVENTS
   * - onChange
  */
  onChange(e) {
    // Valid input
    this.onValidate(e.currentTarget.value);
    // Publish the new value to the form
    this.props.onChange && this.props.onChange(e.currentTarget.value);
  }

  /**
   * VALIDATIONS
   * - onValidate (value)
   * - validate (value, validation)
  */
  onValidate(value) {
    const { validations } = this.props;
    if (validations) {
      const errors = validations.map((validation) => {
        return this.validate(value, validation);
      });

      this.setState({
        valid: errors.every(element => element)
      });
    } else {
      this.setState({
        valid: (value) ? true : null
      });
    }
  }

  validate(value, validation) {
    switch (validation) {
      case 'required':
        return !!value
        break;
      default:
        console.info('The validation you passed doesn\'t exist');
    }
  }

  setError(value) {
    const { properties } = this.props;

    // Required?
    if (properties.required && !value) {
    } else {
    }

    // Publish the new error to the form
    this.props.onError && this.props.onError(value);
  }


  render() {
    const { options, blank, properties, hint } = this.props;
    const { valid } = this.state;

    // Set classes
    const validClass = valid === true ? '-valid' : '';
    const errorClass = valid === false ? '-error' : '';

    return (
      <div className={`c-field ${validClass} ${errorClass}`}>
        {properties.label &&
          <label htmlFor={`select-${properties.name}`} className="label">
            {properties.label} {properties.required && <abbr title="required">*</abbr>}
          </label>
        }

        {hint &&
          <p className="hint">
            {hint}
          </p>
        }

        <select
          {...properties}
          id={`select-${properties.name}`}
          value={properties.value}
          defaultValue={properties.defaultValue}
          onChange={this.onChange}
        >
          {blank && <option value=""></option>}
          {options.map((o, i) => {
            return (
              <option key={i} value={o.value}>{o.text}</option>
            )
          })}
        </select>
      </div>
    );
  }
}

Select.propTypes = {
  properties: React.PropTypes.object.isRequired,
  options: React.PropTypes.array.isRequired,
  blank: React.PropTypes.bool,
  hint: React.PropTypes.string,
  validations: React.PropTypes.any,
  onChange: React.PropTypes.func
};
