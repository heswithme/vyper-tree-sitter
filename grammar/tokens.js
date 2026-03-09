const BYTE_STRING_DOUBLE = /b"([^"\\\n]|\\.)*"/;
const BYTE_STRING_SINGLE = /b'([^'\\\n]|\\.)*'/;
const STRING_DOUBLE = /"([^"\\\n]|\\.)*"/;
const STRING_SINGLE = /'([^'\\\n]|\\.)*'/;

const DOCSTRING_CHUNK_DOUBLE_PATTERNS = [
  /[^"\n]+/,
  /\\./,
  /"[^"\n]/,
  /""[^"\n]/,
];

const DOCSTRING_CHUNK_SINGLE_PATTERNS = [
  /[^'\n]+/,
  /\\./,
  /'[^'\n]/,
  /''[^'\n]/,
];

module.exports = {
  BYTE_STRING_DOUBLE,
  BYTE_STRING_SINGLE,
  STRING_DOUBLE,
  STRING_SINGLE,
  DOCSTRING_CHUNK_DOUBLE_PATTERNS,
  DOCSTRING_CHUNK_SINGLE_PATTERNS,
};
