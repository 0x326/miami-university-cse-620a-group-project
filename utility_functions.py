#script(python)

import clingo


def str_format(template_str: clingo.Symbol, *arguments: clingo.Symbol) -> str:
    template_str = template_str.string
    arguments = (symbol.string if symbol.type == clingo.SymbolType.String else symbol
                 for symbol in arguments)
    return template_str.format(*arguments)


#end.
