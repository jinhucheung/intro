//= require shepherd.min

document.addEventListener('DOMContentLoaded', function () {
  var introMeta = document.querySelector('meta[name="_intro"]')

  if (!introMeta) return

  var locale = JSON.parse(introMeta.dataset.locale)

  var shepherdOptions = JSON.parse(introMeta.dataset.shepherdOptions)

  function TourBoost(tour) {
    this.tour = tour
    this.shepherd = new Shepherd.Tour(extend({
      defaultStepOptions: {
        classes: 'shepherd-theme-intro',
        scrollTo: true
      },
      useModalOverlay: tour.options.overlay_visible
    }, shepherdOptions))
  }

  TourBoost.prototype.setup = function () {
    this.configure()
    this.start()
  }

  TourBoost.prototype.test = function (options) {
    this.tour.options.steps.forEach(function (step) {
      if (step.element && !document.querySelector(step.element)) {
        step.element = options.element
      }
    })

    this.configure()
    this.start()
  }

  TourBoost.prototype.configure = function () {
    locale.complete = this.tour.options.btn_complete_text || locale.complete

    this.configureSteps(this.tour.options.steps)

    this.shepherd.on('complete', this.complete.bind(this))
    this.shepherd.on('cancel', this.cancel.bind(this))
  }

  TourBoost.prototype.configureSteps = function (steps) {
    var self = this

    steps.forEach(function (step, index) {
      var baseOptions = self.configureStepBase(step, index)
      var btnOptions  = self.configureStepButtons(step, index, steps)

      self.shepherd.addStep(extend(baseOptions, btnOptions))
    })
  }

  TourBoost.prototype.configureStepBase = function (step, index) {
    var options = {}
    var popperOptions = {}

    options.id = 'tour-' + index

    if (step.title) {
      options.title = step.title
    }

    if (step.image_url) {
      options.text = '<div class="shepherd-image-box" data-position="' + (step.image_placement || 'top') + '" data-has-title="' + !!step.title + '" data-has-btn="' + !!this.tour.options.btn_visible + '">' +
                        '<div class="shepherd-image-box-source-container"><img height="' + step.image_height + 'px" width="' + step.image_width + 'px" src="' + encodeURI(step.image_url) + '"></div>' +
                        (step.content ? ('<div class="shepherd-image-box-text">' + step.content + '</div>') : '') +
                     '</div>'
    } else if (step.content) {
      options.text = '<div class="shepherd-text-source" data-has-title="' + !!step.title + '" data-has-btn="' + !!this.tour.options.btn_visible + '">' + step.content + '</div>'
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
      theme: 'tippy-theme-intro',
      maxWidth: null,
      popperOptions: popperOptions
    }

    return options
  }

  TourBoost.prototype.configureStepButtons = function (step, index, steps) {
    var options = {}

    if (this.tour.options.btn_visible == 1) {
      if (index === 0) {
        options.buttons = [{ text: locale.exit, action: this.shepherd.cancel, classes: 'shepherd-button-secondary' }]
        if (steps.length === 1) {
          options.buttons.push({ text: locale.complete, action: this.shepherd.complete })
        } else {
          options.buttons.push({ text: locale.next, action: this.next.bind(this) })
        }
      } else if (index === steps.length - 1) {
        options.buttons = [
          { text: locale.back, action: this.shepherd.back, classes: 'shepherd-button-secondary' },
          { text: locale.complete, action: this.shepherd.complete }
        ]
      } else {
        options.buttons = [
          { text: locale.back, action: this.shepherd.back, classes: 'shepherd-button-secondary' },
          { text: locale.next, action: this.next.bind(this) }
        ]
      }
    } else {
      options.buttons = []
    }

    return options
  }

  TourBoost.prototype.start = function () {
    var firstStep = this.shepherd.steps[0]

    if (firstStep && (!firstStep.options.attachTo || firstStep.options.showOn())) {
      this.shepherd.start()
    } else {
      this.shepherd.cancel()
    }
  }

  TourBoost.prototype.next = function () {
    var shepherd = this.shepherd
    var nextStep = shepherd.steps[shepherd.steps.indexOf(shepherd.getCurrentStep()) + 1]

    if (nextStep && (!nextStep.options.attachTo || nextStep.options.showOn())) {
      shepherd.next()
    } else {
      shepherd.cancel()
    }
  }

  TourBoost.prototype.hide = function () {
    this.shepherd.hide()
  }

  TourBoost.prototype.complete = function () {
    this.record('complete')

    if (this.tour.options.btn_complete_link) {
      window.open(this.tour.options.btn_complete_link)
    }
  }

  TourBoost.prototype.cancel = function () {
    this.record('cancel')
  }

  TourBoost.prototype.record = function (action) {
    var self = this

    if (!self.tour.id) return

    var xhr = new XMLHttpRequest()
    xhr.open('POST', introMeta.dataset.recordToursPath)
    xhr.onload = function () {
      if (xhr.status !== 200) return

      createCookie('intro-tour-' + self.tour.id, (action || 'complete'), 365)
    }
    xhr.send(JSON.stringify({
      id: self.tour.id
    }))
  }

  window.IntroTourBoost = TourBoost

  function loadTours () {
    var xhr = new XMLHttpRequest()

    xhr.open(
      'GET',
      introMeta.dataset.toursPath +
      '?controller_path=' + encodeURIComponent(introMeta.dataset.controller) +
      '&action_name=' + encodeURIComponent(introMeta.dataset.action) +
      '&original_url=' + encodeURIComponent(introMeta.dataset.originalUrl)
    )
    xhr.onload = function () {
      if (xhr.status !== 200) return

      var res = JSON.parse(xhr.response)

      if (res.data) {
        res.data.forEach(function (tour) {
          if (tour && tour.options && !getCookie('intro-tour-' + tour.id)) {
            new TourBoost(tour).setup()
          }
        })
      }
    }

    xhr.send()
  }

  loadTours()

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
})