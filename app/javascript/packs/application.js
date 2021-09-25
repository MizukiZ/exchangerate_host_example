// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import 'bootstrap'
import 'select2'
import 'select2/dist/css/select2.css'
import 'select2-bootstrap-theme/dist/select2-bootstrap'
import "chartkick/chart.js"

Rails.start()
Turbolinks.start()

$(document).on("turbolinks:before-cache", function() {
  $('.multi-select').select2('destroy')
})

$(document).on('turbolinks:load', function() {
  $('.multi-select').select2({
    theme: 'bootstrap'
  })
})