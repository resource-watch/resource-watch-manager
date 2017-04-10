var webpack = require('webpack')
var merge   = require('webpack-merge')

var sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig.config, {
  devtool: 'cheap-module-source-map',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ]
})
