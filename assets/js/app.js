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
    const selector = '#' + this.el.id
    const query = this.el.querySelector('input[name=query]')

    query.addEventListener('blur', () => {
      setTimeout(() => this.pushEventTo(selector, 'blur', {}), 0)
    })
  },
  updated() {
    const selector = '#' + this.el.id
    const input = this.el.querySelector('input[type=hidden]')
    const options = this.el.querySelectorAll('li')

    options.forEach(opt => opt.addEventListener('click', () => {
      input.value = opt.dataset.value

      this.pushEvent('validate', serializeForm(input.form))
      this.pushEventTo(selector, 'select', {value: input.value})
    }))
  }
}

Hooks.TokenField = {
  mounted() {
    this.selector = '#' + this.el.id
    this.onClick = Hooks.TokenField.onClick.bind(this)
    this.onDocumentClick = Hooks.TokenField.onDocumentClick.bind(this)
    this.pushCompEvent = (action, args) => (
      this.pushEventTo(this.selector, action, args)
    )

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
