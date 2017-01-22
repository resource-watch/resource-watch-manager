class Step3 extends React.Component {
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
   * UI EVENTS
   * - onLegendChange
  */
  onLegendChange(obj) {
    const legend = Object.assign({}, this.props.form.legend, obj);
    this.props.onChange({ legend });
  }

  render() {
    const { currentStep, step } = this.props;

    const activeClass = (currentStep == step) ? '-active' : '';

    return (

      <fieldset className={`c-field-container ${activeClass}`}>
        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'short-summary': value })}
          properties={{
            name: "short-summary",
            label: "Short summary",
            type: 'text',
            default: this.state.form['short-summary']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'temporal-resolution': value })}
          properties={{
            name: "temporal-resolution",
            label: "Temporal resolution",
            type: 'text',
            default: this.state.form['temporal-resolution']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'temporal-coverage': value })}
          properties={{
            name: "temporal-coverage",
            label: "Temporal coverage",
            type: 'text',
            default: this.state.form['temporal-coverage']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'spatial-resolution': value })}
          properties={{
            name: "spatial-resolution",
            label: "Spatial resolution",
            type: 'text',
            default: this.state.form['spatial-resolution']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'description': value })}
          validations={['required']}
          properties={{
            name: "description",
            label: "Description",
            type: 'text',
            default: this.state.form['description'],
            required: true
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'citation': value })}
          validations={['required']}
          properties={{
            name: "citation",
            label: "Citation",
            type: 'text',
            default: this.state.form['citation'],
            required: true
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'source-url': value })}
          validations={['url']}
          properties={{
            name: "source-url",
            label: "Source url",
            type: 'text',
            default: this.state.form['source-url']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'sdg-indicator': value })}
          validations={['url']}
          hint="Please enter codes separated with commas. Codes here http://unstats.un.org/sdgs/indicators/Official%20List%20of%20Proposed%20SDG%20Indicators.pdf"
          properties={{
            name: "sdg-indicator",
            label: "SDG-indicator",
            type: 'text',
            default: this.state.form['sdg-indicator']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'organization': value })}
          properties={{
            name: "organization",
            label: "Organization",
            type: 'text',
            default: this.state.form['organization']
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ 'data-download-url': value })}
          validations={['url']}
          properties={{
            name: "data-download-url",
            label: "Data download url",
            type: 'text',
            default: this.state.form['data-download-url']
          }}
        />

      </fieldset>
    );
  }
}

Step3.propTypes = {
  step: React.PropTypes.number,
  form: React.PropTypes.object
};
