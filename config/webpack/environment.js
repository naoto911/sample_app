const { environment } = require('@rails/webpacker')

// 追記 21/1/6
// jQueryとBootstapのJSを使えるように
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: 'popper.js'
  })
)
// ここまで

module.exports = environment