# Reference Notes

This grammar is being built against Vyper's own parsing pipeline, not against an
editor grammar.

## Canonical Sources

- `vyper/ast/grammar.lark`
- `vyper/ast/pre_parser.py`
- `vyper/ast/parse.py`

## Key Findings

- Vyper preprocessing is part of the real syntax story.
  `pre_parser.py` rewrites Vyper-specific constructs into Python-compatible code
  before Python AST parsing.
- `# pragma ...` directives are comments handled by the pre-parser.
- `struct`, `event`, `flag`, `enum`, and `interface` are translated before the
  Python parse step. They still need first-class Tree-sitter nodes.
- `log Foo(...)` is a dedicated statement form.
- `extcall` and `staticcall` are dedicated expression forms.
- `for i: uint256 in xs:` is real syntax. The type annotation is captured by the
  pre-parser before Python parsing.
- State-variable annotations such as `public(...)`, `immutable(...)`,
  `transient(...)`, and `reentrant(...)` are part of the declaration syntax.
- `implements: Name` and `exports: (...)` are top-level declarations.

## AST Observations

From `parse_to_ast` on small reference snippets:

- `owner: public(address)` becomes `VariableDecl`
- `event Transfer: ...` becomes `EventDef`
- `log Transfer(...)` becomes `Log`
- `result = extcall self.token.transfer(...)` becomes `Assign` with `ExtCall`
- `result = staticcall self.token.balanceOf(...)` becomes `Assign` with `StaticCall`
- `interface ERC20: ...` becomes `InterfaceDef`
- `implements: ERC20` becomes `ImplementsDecl`
- `exports: (foo, bar.baz)` becomes `ExportsDecl`

## Tree-sitter Policy

- Compiler syntax is authoritative.
- Tree-sitter node design is editor-oriented, not a byte-for-byte copy of the
  compiler AST.
- Other editor grammars may be used only as secondary references for highlighting
  expectations, not as parser truth.
