const { environment } = require('@rails/webpacker')

// 以下jquery導入のため追記 21/1/6
const webpack = require('webpack')
environment.plugins.prepend('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)
// ここまで
module.exports = environment
