###
# object.watch polyfill

## authors:

- eli grey, http://eligrey.com
- bryn austin bellomy <bryn.bellomy@gmail.com>
 
NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
###

# object.watch
unless Object::watch?
  Object.defineProperty Object.prototype, 'watch',
    enumerable: false
    configurable: true
    writable: false
    value: (prop, handler) ->
      this.__watch_handlers ?= {}
      this.__watch_handlers[prop] ?= []
      this.__watch_handlers[prop].push handler

      oldval = this[prop]
      newval = oldval
      getter = -> newval
      setter = (val) ->
        oldval = newval
        newval = val
        for fn in this.__watch_handlers[prop]
          fn.call(this, prop, oldval, val)


      if delete this[prop] # can't watch constants
        Object.defineProperty this, prop,
          get: getter
          set: setter
          enumerable: true
          configurable: true



# object.unwatch
unless Object::unwatch?
  Object.defineProperty Object.prototype, 'unwatch',
    enumerable: false
    configurable: true
    writable: false
    value: (prop) ->
      val = this[prop]
      delete this[prop] # remove accessors

      this[prop] = val
