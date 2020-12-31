import Rails from '@rails/ujs'
import $ from 'jquery'

if (!window._rails_loaded) Rails.start()
window.$ = $

import "stylesheets/intro/admin/application"