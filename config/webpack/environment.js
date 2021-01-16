const { environment } = require('@rails/webpacker')

// 以下追記 21/1/15
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default']
  })
)
// ここまで

module.exports = environment