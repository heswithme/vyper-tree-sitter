const PREC = {
  conditional: 0,
  or: 1,
  and: 2,
  compare: 3,
  bitwise_or: 4,
  bitwise_xor: 5,
  bitwise_and: 6,
  shift: 7,
  additive: 8,
  multiplicative: 9,
  unary: 10,
  power: 11,
  call: 12,
  attribute: 13,
};

module.exports = { PREC };
