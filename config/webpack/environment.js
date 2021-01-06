const { environment } = require('@rails/webpacker')

// 追記 21/1/6
const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
}))
// ここまで 21/1/6
module.exports = environment