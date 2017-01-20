class Input extends React.Component {

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
    const { properties, hint } = this.props;
    const { valid } = this.state;

    // Set classes
    const validClass = valid === true ? '-valid' : '';
    const errorClass = valid === false ? '-error' : '';

    return (
      <div className={`c-field ${validClass} ${errorClass}`}>
        {properties.label &&
          <label htmlFor={`input-${properties.name}`} className="label">
            {properties.label} {properties.required && <abbr title="required">*</abbr>}
          </label>
        }

        {hint &&
          <p className="hint">
            {hint}
          </p>
        }

        <input
          {...properties}
          id={`input-${properties.name}`}
          value={properties.value}
          defaultValue={properties.defaultValue}
          onChange={this.onChange}
        />
      </div>
    );
  }
}

Input.propTypes = {
  properties: React.PropTypes.object.isRequired,
  hint: React.PropTypes.string,
  validations: React.PropTypes.any,
  onChange: React.PropTypes.func
};
