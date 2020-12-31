import Rails from '@rails/ujs'
import Turbolinks from "turbolinks"
import $ from 'jquery'

if (!window._rails_loaded) Rails.start()
Turbolinks.start()
window.$ = $

import "stylesheets/intro/admin/application"