// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '@fortawesome/fontawesome-pro/css/all.css';
import css from '../css/app.scss'
// import '@fortawesome/fontawesome-pro/js/all'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in 'webpack.config.js'.
//
// Import dependencies
//
import 'phoenix_html'
import {Socket} from 'phoenix'
import LiveSocket from 'phoenix_live_view'
import _ from 'lodash'

window.__phrasing__ = {}
const Hooks = {}

let serializeForm = (form, meta = {}) => {
  const memo = {}
  const formData = new FormData(form)

  for(let [key, val] of formData.entries()) {
    if (key.endsWith('[]')) {
      _.update(memo, key.slice(0, -2), x => (x || []).concat([val]))
    } else {
      _.set(memo, key, val)
    }
  }

  return memo
}

Hooks.Adder = {
  mounted() {
    window.__phrasing__.pushAdderEvent = this.pushEvent.bind(this)
    const height = this.el.offsetHeight
    this.el.style.transform = `translateY(-${height}px)`
  },
  updated() {
    const height = this.el.offsetHeight
    this.el.style.transform = `translateY(-${height}px)`
  },
}

Hooks.SelectField = {
  mounted() {
    this.selector = '#' + this.el.id
    this.onClick = Hooks.SelectField.onClick.bind(this)
    this.onDocumentClick = Hooks.SelectField.onDocumentClick.bind(this)
    this.pushCompEvent = (act, args) => this.pushEventTo(this.selector, act, args)
    this.pushFormEvent = this.el.dataset.formSelector
      ? (act, args) => this.pushEventTo(this.el.dataset.formSelector, act, args)
      : this.pushEvent

    this.events.call(this, 'add')
  },
  onClick(event) {
    const input = this.el.querySelector('input[type=hidden]')
    const query = this.el.querySelector('input[name=query]')
    const main = this.el.querySelector('main')
    const options = [...this.el.querySelectorAll('li')]

    if (options.includes(event.target)) {
      const params = {value: "" + event.target.dataset.value}
      input.value = event.target.dataset.value
      this.pushFormEvent('validate', serializeForm(input.form))
      this.pushCompEvent('select', params)
      // setTimeout(() => this.pushCompEvent('blur', {}), 0)
    }

    if (main == event.target) {
      query.focus()
    }
  },
  onDocumentClick(event) {
    if (!this.el.contains(event.target)) {
      this.pushCompEvent('blur', {})
    }
  },
  beforeDestroy() {
    this.events.call(this, 'remove')
  },
  events(action) {
    this.el[action + 'EventListener']('click', this.onClick)
    document[action + 'EventListener']('click', this.onDocumentClick)
  }
}

Hooks.TokenField = {
  mounted() {
    this.selector = '#' + this.el.id
    this.onClick = Hooks.TokenField.onClick.bind(this)
    this.onDocumentClick = Hooks.TokenField.onDocumentClick.bind(this)
    this.pushCompEvent = (act, args) => this.pushEventTo(this.selector, act, args)

    this.events.call(this, 'add')
  },
  updated() {
    const isStale = this.el.querySelector('input[type=hidden][data-stale]')

    if (isStale) {
      this.pushEvent('validate', serializeForm(isStale.form))
    }
  },
  onClick(event) {
    const tokens = [...this.el.querySelectorAll('.token')]
    const options = [...this.el.querySelectorAll('li')]
    const params = {value: "" + event.target.dataset.value}

    if (tokens.includes(event.target)) {
      token.classList.add('destroy')
      setTimeout(() => {
        this.pushCompEvent('destroy', params)
      }, 200)
    }

    if (options.includes(event.target)) {
      this.pushCompEvent('select', params)
    }
  },
  onDocumentClick(event) {
    if (!this.el.contains(event.target)) {
      this.pushCompEvent('blur', {})
    }
  },
  beforeDestroy() {
    this.events.call(this, 'remove')
  },
  events(action) {
    this.el[action + 'EventListener']('click', this.onClick)
    document[action + 'EventListener']('click', this.onDocumentClick)
  }
}

Hooks.GoBack = {
  mounted() {
    this.el.addEventListener('click', () => {
      setTimeout(() => window.history.back(), 0)
    })
  },
}

window.Add = {
  navbar() {
    window.__phrasing__.pushAdderEvent('open', {})
  }
}


let csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks});
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from './socket'
