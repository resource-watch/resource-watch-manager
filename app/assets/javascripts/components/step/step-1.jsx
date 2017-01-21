class Step1 extends React.Component {
  constructor(props) {
    super(props);
    this.children = [];
    this.state = {
      form: props.form
    };
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

  render() {
    const { currentStep, step } = this.props;

    const activeClass = (currentStep == step) ? '-active' : '';

    return (
      <fieldset className={`c-field-container ${activeClass}`}>
        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ name: value })}
          validations={['required']}
          properties={{
            name: "name",
            label: "Title",
            type: 'text',
            required: true,
            default: this.state.form.name
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ subtitle: value })}
          properties={{
            name: "subtitle",
            label: "Subtitle",
            type: 'text',
            default: this.state.form.subtitle
          }}
        />

        {/* <CheckboxGroup
          onChange={value => this.props.onChange({ application: value })}
          items={[
            { value: 'rw', label: 'Resource Watch' },
            { value: 'gfw', label: 'Global Forest Watch' },
            { value: 'prep', label: 'PREP' },
            { value: 'aqueduct', label: 'Aqueduct' },
            { value: 'forest-atlas', label: 'Forest Atlas' },
            { value: 'data4sdgs', label: 'Data 4 SDGs' },
            { value: 'gfw-climate', label: 'GFW Climate' },
          ]}
          name="application"
          properties={{
            label: "Application",
            default: this.state.form.application,
            required: true
          }}
        /> */}

        <Select
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ topics: [value] })}
          validations={['required']}
          blank={true}
          options={[
            { text: 'Cities', value: 'cities' },
            { text: 'Climate', value: 'climate' },
            { text: 'Energy', value: 'energy' },
            { text: 'Forests', value: 'forests' },
            { text: 'Food', value: 'food' },
            { text: 'Land classification', value: 'land_classification' },
            { text: 'Society', value: 'society' },
            { text: 'Supply chain', value: 'supply_chain' },
            { text: 'Water', value: 'water' }
          ]}
          properties={{
            name: "topics",
            label: "Topics",
            default: this.state.form.subtitle,
            required: true
          }}
        />

        <Input
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ tags: value })}
          validations={['required']}
          hint="This will cover different vocabularies that represent this dataset. please write them comma separated: water,food"
          properties={{
            name: "tags",
            label: "Tags",
            type: 'text',
            default: this.state.form.tags,
            required: true
          }}
        />

        <Select
          ref={(c) => { c && this.children.push(c) }}
          onChange={value => this.props.onChange({ ...PROVIDERDICTIONARY[value] })}
          validations={['required']}
          blank={true}
          options={[
            { text: 'Carto', value: 'cartodb' },
            { text: 'ArcGIS', value: 'arcgis' },
            { text: 'WMS', value: 'wms' },
            { text: 'CSV', value: 'csv' },
            { text: 'Google Earth Engine', value: 'gee' }
          ]}
          properties={{
            name: "provider",
            label: "Provider",
            default: this.state.form.provider,
            required: true
          }}
        />
      </fieldset>
    );
  }
}

Step1.propTypes = {
  step: React.PropTypes.number,
  form: React.PropTypes.object,
  onChange: React.PropTypes.func
};
