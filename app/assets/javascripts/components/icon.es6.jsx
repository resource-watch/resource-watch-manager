class Test extends React.Component {
  render () {
    return (
      <div>
        <div>Name: {this.props.name}</div>
      </div>
    );
  }
}

Test.propTypes = {
  name: React.PropTypes.string
};
