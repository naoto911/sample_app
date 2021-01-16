// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require('jquery') // 追記 21/1/6
// require('jquery_ujs') // 追記 21/1/6
require('test.js')

import 'bootstrap';
//import '../src/application.scss'; 非表示 21/1/15 非表示によりjs読み込みが可能に

import "@fortawesome/fontawesome-free/js/all"; // 追記 21/1/6

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
