class Input extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      value: this.props.properties.default,
      valid: null,
      error: []
    }

    // VALIDATOR
    this.validator = new Validator();

    // BINDINGS
    this.onChange = this.onChange.bind(this);
    this.triggerValidate = this.triggerValidate.bind(this);
  }

  /**
   * UI EVENTS
   * - onChange
  */
  onChange(e) {
    this.setState({ value: e.currentTarget.value }, () => {
      // Trigger validation
      this.triggerValidate();
      // Publish the new value to the form
      this.props.onChange && this.props.onChange(this.state.value);
    });
  }

  /**
   * VALIDATIONS
   * - triggerValidate (value)
  */
  triggerValidate() {
    const { validations } = this.props;
    const { value } = this.state;

    if (validations) {
      // VALIDATE
      const validateArr = this.validator.validate(validations, value);
      const valid = validateArr.every(element => element.valid);

      this.setState({
        valid,
        error: (!valid) ? validateArr.map(element => element.error) : []
      });
    } else {
      this.setState({
        valid: (value) ? true : null,
        error: []
      });
    }
  }

  render() {
    const { properties, hint } = this.props;
    const { valid, error, value } = this.state;

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
          value={this.state.value}
          id={`input-${properties.name}`}
          onChange={this.onChange}
        />

        {error &&
          error.map((err, i) => {
            if (err) {
              return (
                <p key={i} className="error">
                  {err.message}
                </p>
              )
            }
          })
        }

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
