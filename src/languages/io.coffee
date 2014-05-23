Language = require './language'
iota = require 'iota-compiler'
esprima = require 'esprima'

module.exports = class Io extends Language
  name: 'Io'
  id: 'io'
  parserID: 'iota'
  runtimeGlobals: iota.lib

  obviouslyCannotTranspile: (rawCode) ->
    false

  wrap: (rawCode, aether) ->
    @wrappedCodePrefix = """chooseAction := method("""
    @wrappedCodeSuffix = """)\nplayer chooseAction := getSlot("chooseAction")\nplayer chooseAction"""

    @wrappedCodePrefix + rawCode + @wrappedCodeSuffix

  parse: (code, aether) ->

    wrappedCode = iota.compile(code, true);
    wrappedCode = wrappedCode.replace('execute', aether.options.functionName) if aether.options.functionName

    console.log wrappedCode

    ast = esprima.parse(wrappedCode)
    ast