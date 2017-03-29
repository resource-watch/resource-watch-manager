// Note: You must restart bin/webpack-watcher for changes to take effect

var webpack = require('webpack')
var path = require('path')
var process = require('process')
var glob = require('glob')
var extname = require('path-complete-extname')
var distDir = process.env.WEBPACK_DIST_DIR || 'packs'

config = {
  devtool: 'sourcemap',

  stats: {
    errorDetails: true
  },

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
    new webpack.EnvironmentPlugin(Object.keys(process.env)),
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ],

  resolve: {
    extensions: [ '.js', '.jsx', '.coffee' ],
    modules: [
      path.resolve('app/javascript'),
      path.resolve('node_modules'),
      path.resolve('node_modules', 'rw-components', 'node_modules')
    ],
  },

  resolveLoader: {
    modules: [ path.resolve('node_modules') ]
  }
}


configs = glob.sync(path.join('app', 'javascript', 'packs', '**/*.js*')).map(function(entry, i) {
  var basename = path.basename(entry, extname(entry))
  // Uotput dir
  var dirArray = path.dirname(entry).split(path.sep)
  var packIndex = dirArray.indexOf('packs')
  var dirname = dirArray.slice(packIndex).join(path.sep)

  return Object.assign({}, config, {
    name: basename,
    entry: path.resolve(entry),
    output: {
       path: path.resolve('public', dirname),
       filename: basename + '.js'
    },
  })
});

module.exports = configs
