class CheckboxGroup extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      selected: props.properties.defaultValue || []
    };

    // BINDINGS
    this.onChange = this.onChange.bind(this);
  }

  /**
   * UI EVENTS
   * - onChange
  */
  onChange(e) {
    // - newSelected: Clone the current selected array
    // - i: Get the indexOf the the current selection
    const newSelected = [].concat(this.state.selected);
    const i = this.state.selected.indexOf(e.currentTarget.value);

    // Toggle element from the array
    (i === -1) ?
      newSelected.push(e.currentTarget.value) :
      newSelected.splice(i, 1);

    // Set state
    this.setState({
      selected: newSelected
    });

    this.props.onChange && this.props.onChange(newSelected);
  }

  render() {
    const { properties, hint, name, items } = this.props;
    const { valid, selected } = this.state;

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

        <div className="c-checkbox-box">
          {items.map((item, i) => (
            <div key={i} className="c-checkbox">
              <input
                type="checkbox"
                name={name}
                id={`checkbox-${name}-${item.value}`}
                value={item.value}
                checked={selected.indexOf(item.value) !== -1}
                onChange={this.onChange}
              />
              <label htmlFor={`checkbox-${name}-${item.value}`}>
                <span />
                {item.label}
              </label>
            </div>
          ))}
        </div>
      </div>
    );
  }
}

CheckboxGroup.propTypes = {
  items: React.PropTypes.array.isRequired,
  name: React.PropTypes.string.isRequired,
  defaultValue: React.PropTypes.array,
  hint: React.PropTypes.string,
  className: React.PropTypes.string,
  onChange: React.PropTypes.func
};
