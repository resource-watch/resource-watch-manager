// Note: You must restart bin/webpack-watcher for changes to take effect

var webpack = require('webpack')
var path = require('path')
var process = require('process')
var glob = require('glob')
var extname = require('path-complete-extname')
var distDir = process.env.WEBPACK_DIST_DIR

if(distDir === undefined) {
  distDir = 'packs'
}

var entriesPaths = glob.sync(path.join('app', 'javascript', 'packs', '*.js*')).reduce(
  function(map, entry) {
    var basename = path.basename(entry, extname(entry))
    map[basename] = path.resolve(entry)
    return map
  }, {}
);

var datasetsPaths = glob.sync(path.join('app', 'javascript', 'packs', 'dataset', '*.js*')).reduce(
  function(map, entry) {
    var basename = path.basename(entry, extname(entry))
    map['dataset/' + basename] = path.resolve(entry)
    return map
  }, {}
);

config = {

  entry: Object.assign({}, entriesPaths, datasetsPaths),

  output: { filename: '[name].js', path: path.resolve('public', distDir) },

  module: {
    rules: [
      { test: /\.coffee(.erb)?$/, loader: "coffee-loader" },
      {
        test: /\.jsx?(.erb)?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: [
            'react',
            [ 'latest', { 'es2015': { 'modules': false } } ]
          ]
        }
      },
      {
        test: /.erb$/,
        enforce: 'pre',
        exclude: /node_modules/,
        loader: 'rails-erb-loader',
        options: {
          runner: 'DISABLE_SPRING=1 bin/rails runner'
        }
      },
    ]
  },

  plugins: [
    new webpack.EnvironmentPlugin(Object.keys(process.env))
  ],

  resolve: {
    extensions: [ '.js', '.jsx', '.coffee' ],
    modules: [
      path.resolve('app/javascript'),
      path.resolve('node_modules'),
      path.resolve('node_modules', 'rw-components', 'node_modules')
    ]
  },

  resolveLoader: {
    modules: [ path.resolve('node_modules') ]
  }
}

module.exports = {
  distDir: distDir,
  config: config
}
