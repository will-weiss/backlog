:- module(backlog, [ weave/2 ]).

% hard-code k for now
k(0.9).

% An empty schedule has no value
value_of_schedule([], 0) :- !.

% A non-empty schedule has value equal to the value of the first ticket plus
% k times the value of the remainder of the schedule
value_of_schedule([Head|Tail], Value) :-
  k(K),
  value_of_ticket(Head, ValueOfHead),
  value_of_schedule(Tail, ValueOfTail),
  Value is ValueOfHead + (K * ValueOfTail).

% Various base cases for weaving empty lists.
weave([], []) :- !.
weave([List], List) :- !.
weave([[], List], List) :- !.
weave([List, []], List) :- !.

% The first non-trivial case where two lists are woven together.
weave([[Head1|Tail1], [Head2|Tail2]], Woven) :-
  !,

  weave([Tail1, [Head2|Tail2]], Remainder1),
  weave([Tail2, [Head1|Tail1]], Remainder2),

  Woven1 = [Head1|Remainder1],
  Woven2 = [Head2|Remainder2],

  value_of_schedule(Woven1, Value1),
  value_of_schedule(Woven2, Value2),

  (Value1 > Value2 -> Woven = Woven1 ; Woven = Woven2).

% Weaving more than two lists together is done by weaving the first two and weaving
% this result with the woven remainder.
weave([First|[Second|Remainder]], Woven) :-
  weave([First, Second], WovenInitial),
  weave(Remainder, WovenRemainder),
  weave([WovenInitial, WovenRemainder], Woven).
