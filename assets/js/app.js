import "phoenix_html"
import "./charts"

import ChatSocket from "./socket";
window.ChatSocket = ChatSocket;

import MSSPSocket from "./mssp";
window.MSSPSocket = MSSPSocket;

import React from "react";
import ReactDOM from "react-dom";

import Connection from "./connection";
import RedirectURI from "./redirect-uri";

window.Components = {
  Connection,
  RedirectURI,
}

/**
 * ReactPhoenix
 *
 * Copied from https://github.com/geolessel/react-phoenix/blob/master/src/react_phoenix.js
 */
class ReactPhoenix {
  static init() {
    const elements = document.querySelectorAll('[data-react-class]')
    Array.prototype.forEach.call(elements, e => {
      const targetId = document.getElementById(e.dataset.reactTargetId)
      const targetDiv = targetId ? targetId : e
      const reactProps = e.dataset.reactProps ? e.dataset.reactProps : "{}"
      const reactElement = React.createElement(eval(e.dataset.reactClass), JSON.parse(reactProps))
      ReactDOM.render(reactElement, targetDiv)
    })
  }
}

document.addEventListener("DOMContentLoaded", e => {
  ReactPhoenix.init();
})
