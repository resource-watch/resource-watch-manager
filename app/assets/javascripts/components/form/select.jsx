class Select extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      valid: null,
      error: []
    }

    // VALIDATOR
    this.validator = new Validator();

    // BINDINGS
    this.triggerChange = this.triggerChange.bind(this);
    this.triggerValidate = this.triggerValidate.bind(this);
  }

  /**
   * UI EVENTS
   * - triggerChange
  */
  triggerChange(e) {
    this.setState({ value: e.currentTarget.value }, () => {
      // Trigger validation
      this.triggerValidate();
      // Publish the new value to the form
      this.props.onChange && this.props.onChange(this.state.value);
    });
  }

  /**
   * VALIDATIONS
   * - triggerValidate ()
  */
  triggerValidate() {
    const { validations } = this.props;
    const { value } = this.state;

    // Check if it has validations &&
    // if a value is defined or if required validation is present
    if (validations && (value || validations.indexOf('required') !== -1)) {
      // VALIDATE
      const validateArr = this.validator.validate(validations, value);
      const valid = validateArr.every(element => element.valid);
      const error = (!valid) ? validateArr.map(element => element.error) : [];

      this.setState({
        valid,
        error
      });
    } else {
      this.setState({
        valid: (value) ? true : null,
        error: []
      });
    }
  }

  isValid() {
    return this.state.valid;
  }

  render() {
    const { options, blank, properties, hint } = this.props;
    const { valid, error, value } = this.state;

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
          value={value}
          onChange={this.triggerChange}
        >
          {blank && <option value=""></option>}
          {options.map((o, i) => {
            return (
              <option key={i} value={o.value}>{o.text}</option>
            )
          })}
        </select>

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

Select.propTypes = {
  properties: React.PropTypes.object.isRequired,
  options: React.PropTypes.array.isRequired,
  blank: React.PropTypes.bool,
  hint: React.PropTypes.string,
  validations: React.PropTypes.any,
  onChange: React.PropTypes.func
};
