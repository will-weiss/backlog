:- use_module('../prolog/backlog').


% Some sample tickets with sample values
value_of_ticket('make pasta', 2).
value_of_ticket('scratch back', 3).
value_of_ticket('do the thing', 4).
value_of_ticket('have a day', 5).
value_of_ticket('hit the jackpot', 1000).

% Helper predicate to assert that the value is ground and equal to an expected value
is_equal(Value, Expectation) :-
  assertion(ground(Value)),
  assertion(Value = Expectation).


% Unit tests
:- use_module(library(tap)).

'weave2/3 works for trivial case where left schedule is empty' :-
  weave2([], ['scratch back'], Woven),
  is_equal(Woven, ['scratch back']).

'weave2/3 works for trivial case where right schedule is empty' :-
  weave2(['scratch back'], [], Woven),
  is_equal(Woven, ['scratch back']).

'weave2/3 works for non-trivial case' :-
  weave2(['make pasta', 'have a day'], ['hit the jackpot'], Woven),
  is_equal(Woven, ['hit the jackpot', 'make pasta', 'have a day']).

'weave2/3 prioritizes up front value when differences between tickets are small' :-
  weave2(['make pasta', 'have a day'], ['scratch back', 'do the thing'], Woven),
  is_equal(Woven, ['scratch back', 'do the thing', 'make pasta', 'have a day']).

'weave2/3 prioritizes the highest value tickets when differences between tickets are large' :-
  weave2(['make pasta', 'hit the jackpot'], ['scratch back', 'do the thing'], Woven),
  is_equal(Woven, ['make pasta', 'hit the jackpot', 'scratch back', 'do the thing']).


'weave/2 works for trivial case where there are no schedules to be woven' :-
  weave([], Woven),
  is_equal(Woven, []).

'weave/2 works for trivial case where there is one schedule to be woven' :-
  weave([['make pasta', 'have a day']], Woven),
  is_equal(Woven, ['make pasta', 'have a day']).

'weave/2 works for weaving 2 schedules' :-
  weave([['make pasta', 'have a day'], ['hit the jackpot']], Woven),
  is_equal(Woven, ['hit the jackpot', 'make pasta', 'have a day']).

'weave/2 weaves 3 or more schedules' :-
  weave([[], ['make pasta', 'hit the jackpot'], ['do the thing'], ['have a day']], Woven),
  is_equal(Woven, ['make pasta', 'hit the jackpot', 'have a day', 'do the thing']).
