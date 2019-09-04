//= require shepherd.min

(function () {
  // utils

  /**
   * Merge defaults with user options
   * @private
   * @param {Object} defaults Default settings
   * @param {Object} options User options
   * @returns {Object} Merged values of defaults and options
   * @thanks https://gist.github.com/pbojinov/8f3765b672efec122f66
   */
  function extend (defaults, options) {
    var extended = {}
    var prop
    for (prop in defaults) {
      if (Object.prototype.hasOwnProperty.call(defaults, prop)) {
        extended[prop] = defaults[prop]
      }
    }
    for (prop in options) {
      if (Object.prototype.hasOwnProperty.call(options, prop)) {
        extended[prop] = options[prop]
      }
    }
    return extended
  }

  /**
   * JavaScript cookies - cookies.js
   * @thanks https://gist.github.com/abhiomkar/1363648
   */
  function getCookie (name) {
    var dc = document.cookie
    var prefix = name + '='
    var begin = dc.indexOf('; ' + prefix)
    if (begin == -1) {
      begin = dc.indexOf(prefix)
      if (begin != 0) return null
    } else {
      begin += 2
    }
    var end = document.cookie.indexOf(';', begin)
    if (end == -1) {
      end = dc.length
    }
    return unescape(dc.substring(begin + prefix.length, end))
  }

  function createCookie (name, value, days) {
    if (days) {
      var date = new Date()
      date.setTime(date.getTime() + (days*24*60*60*1000))
      var expires = '; expires=' + date.toGMTString()
    }
    else var expires = ''
    document.cookie = name + '=' + value + expires + '; path=/'
  }

  function loadIntro () {
    var intro = window._intro

    if (!intro) return

    var locales = intro.locales
    var locale = intro.locale
    var shepherdOptions = intro.shepherd_options

    function Tour(tour) {
      this.tour = tour
      this.shepherd = new Shepherd.Tour(extend({
        classPrefix: 'intro',
        defaultStepOptions: {
          scrollTo: true
        },
        useModalOverlay: tour.options.overlay_visible
      }, shepherdOptions))
    }

    Tour.prototype.setup = function () {
      this.configure()
      this.start()
      return this
    }

    Tour.prototype.test = function (options) {
      this.tour.options.steps.forEach(function (step) {
        if (step.element && !document.querySelector(step.element)) {
          step.element = options.element
        }
      })

      this.configure()
      this.start()
    }

    Tour.prototype.configure = function () {
      var btnCompleteText = this.tour.options['btn_complete_text_' + locale] || this.tour.options.btn_complete_text
      locales.complete = btnCompleteText || locales.complete

      this.configureSteps(this.tour.options.steps)

      this.shepherd.on('complete', this.complete.bind(this))
      this.shepherd.on('cancel', this.cancel.bind(this))
      this.shepherd.on('show', this.show.bind(this))
    }

    Tour.prototype.configureSteps = function (steps) {
      var self = this

      steps.forEach(function (step, index) {
        var baseOptions = self.configureStepBase(step, index)
        var btnOptions  = self.configureStepButtons(step, index, steps)

        self.shepherd.addStep(extend(baseOptions, btnOptions))
      })
    }

    Tour.prototype.configureStepBase = function (step, index) {
      var options = {}
      var popperOptions = {}
      var stepTitle = step['title_' + locale] || step.title
      var stepContent = step['content_' + locale] || step.content

      options.id = 'tour-' + index

      if (stepTitle) {
        options.title = stepTitle
      }

      if (step.image_url) {
        options.text = '<div class="shepherd-image-box" x-placement="' + (step.image_placement || 'top') + '">' +
                          '<div class="shepherd-image-box-content"><img height="' + step.image_height + 'px" width="' + step.image_width + 'px" src="' + encodeURI(step.image_url) + '"></div>' +
                          (stepContent ? ('<div class="shepherd-image-box-text">' + stepContent + '</div>') : '') +
                       '</div>'
      } else if (stepContent) {
        options.text = '<div class="shepherd-text-box">' + stepContent + '</div>'
      }

      if (step.element) {
        options.attachTo = {
          element: step.element,
          on: (step.placement || 'bottom')
        }
        options.showOn = function () {
          return document.querySelector(step.element)
        }
      }

      options.showCancelLink = step.cancel_link

      // @see https://github.com/FezVrasta/popper.js/issues/670
      if (step.fixed_placement) {
        popperOptions.modifiers = {
          preventOverflow: {
            escapeWithReference: true
          }
        }
      }

      options.tippyOptions = {
        zIndex: (step.z_index || 99),
        maxWidth: null,
        popperOptions: popperOptions
      }

      return options
    }

    Tour.prototype.configureStepButtons = function (step, index, steps) {
      var options = {}

      if (this.tour.options.btn_visible == 1) {
        if (index === 0) {
          options.buttons = [{ text: locales.exit, action: this.shepherd.cancel, secondary: true }]
          if (steps.length === 1) {
            options.buttons.push({ text: locales.complete, action: this.shepherd.complete })
          } else {
            options.buttons.push({ text: locales.next, action: this.next.bind(this) })
          }
        } else if (index === steps.length - 1) {
          options.buttons = [
            { text: locales.back, action: this.shepherd.back, secondary: true },
            { text: locales.complete, action: this.shepherd.complete }
          ]
        } else {
          options.buttons = [
            { text: locales.back, action: this.shepherd.back, secondary: true },
            { text: locales.next, action: this.next.bind(this) }
          ]
        }
      } else {
        options.buttons = []
      }

      return options
    }

    Tour.prototype.start = function () {
      var firstStep = this.shepherd.steps[0]

      if (firstStep && (!firstStep.options.attachTo || firstStep.options.showOn())) {
        this.shepherd.start()
      } else {
        this.shepherd.cancel()
      }
    }

    Tour.prototype.next = function () {
      var shepherd = this.shepherd
      var nextStep = shepherd.steps[shepherd.steps.indexOf(shepherd.getCurrentStep()) + 1]

      if (nextStep && (!nextStep.options.attachTo || nextStep.options.showOn())) {
        shepherd.next()
      } else {
        shepherd.cancel()
      }
    }

    Tour.prototype.hide = function () {
      this.shepherd.hide()
    }

    Tour.prototype.show = function (e) {
      var self = this

      setTimeout(function () {
        var element = e.step.el

        var image = element.querySelector('.shepherd-image-box img')
        if (image) {
          image.onload = function () {
            document.body.scrollTop = document.documentElement.scrollTop = window.screenTop + 1
          }
        }

        if (self.tour.options.overlay_visible) {
          var container = element.closest('.tippy-popper')
          var preContrainer = container && container.previousElementSibling

          if (preContrainer.classList.contains((self.shepherd.classPrefix || '') + 'shepherd-modal-overlay-container')) {
            preContrainer.style.zIndex = e.step.options.tippyOptions.zIndex
          }
        }
      }, 0)
    }

    Tour.prototype.complete = function () {
      this.record('complete')

      if (this.tour.options.btn_complete_link) {
        window.open(this.tour.options.btn_complete_link)
      }
    }

    Tour.prototype.cancel = function () {
      this.record('cancel')
    }

    Tour.prototype.record = function (action) {
      if (!this.tour.id) return

      createCookie('intro-tour-' + this.tour.id, (action || 'complete'), 7300)

      var xhr = new XMLHttpRequest()
      var csrfToken = document.querySelector('meta[name="csrf-token"]')

      xhr.open('POST', intro.record_tours_path)
      csrfToken && xhr.setRequestHeader('X-CSRF-Token', csrfToken.content)
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.send(JSON.stringify({
        id: this.tour.id
      }))
    }

    intro.Tour = Tour

    function loadTours () {
      var xhr = new XMLHttpRequest()

      xhr.open(
        'GET',
        intro.tours_path +
        '?controller_path=' + encodeURIComponent(intro.controller) +
        '&action_name=' + encodeURIComponent(intro.action) +
        '&original_url=' + encodeURIComponent(intro.original_url)
      )
      xhr.onload = function () {
        if (xhr.status !== 200) return

        var res = JSON.parse(xhr.response)

        if (res.data) {
          res.data.forEach(function (tour) {
            if (tour && tour.options && !getCookie('intro-tour-' + tour.id)) {
              new Tour(tour).setup()
            }
          })
        }
      }

      xhr.send()
    }

    loadTours()
  }

  if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
    if (!window._introBindTurbolinks) {
      document.addEventListener('turbolinks:load', loadIntro)

      window._introBindTurbolinks = true
    }
  } else {
    document.addEventListener('DOMContentLoaded', loadIntro)
  }
})()