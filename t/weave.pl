:- use_module('../prolog/backlog').


% Some sample tickets with sample values.
value_of_ticket('make pasta', 2).
value_of_ticket('scratch back', 3).
value_of_ticket('do the thing', 4).
value_of_ticket('have a day', 5).

% Unit tests
:- use_module(library(tap)).

'weaving works' :-
  weave([['make pasta', 'have a day'], ['scratch back', 'do the thing'], []], Woven),
  assertion(ground(Woven)),
  assertion(length(Woven, 4)),
  assertion(Woven = ['scratch back', 'do the thing', 'make pasta', 'have a day']).
