import Rails from "@rails/ujs"
import {$,jQuery} from 'jquery'

Rails.start()
window.$ = $
window.jQuery = jQuery

import "lib/shepherd";

import "stylesheets/intro/application"