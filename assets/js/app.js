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

window.__phrasing__ = {}
const Hooks = {}

Hooks.Adder = {
  mounted() {
    console.log('mounted')
    window.__phrasing__.pushAdderEvent = this.pushEvent.bind(this)
    const height = this.el.offsetHeight
    this.el.style.transform = `translateY(-${height}px)`
  },
  updated() {
    const height = this.el.offsetHeight
    this.el.style.transform = `translateY(-${height}px)`
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
