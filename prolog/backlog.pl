:- module(backlog, [ weave2/3
                   , weave/2
                   ]).

% hard-code k for now
k(0.9).

% An empty schedule has no value
value_of_schedule([], 0) :- !.

% A non-empty schedule has value equal to the value of the first ticket plus
% k times the value of the remainder of the schedule
value_of_schedule([Ticket|RemainingSchedule], ValueOfSchedule) :-
  k(K),
  value_of_ticket(Ticket, ValueOfTicket),
  value_of_schedule(RemainingSchedule, ValueOfRemainingSchedule),
  ValueOfSchedule is ValueOfTicket + (K * ValueOfRemainingSchedule).

% Base cases for weaving 2 schedules, weaving an empty schedule with another yields the other schedule.
weave2([], RightSchedule, RightSchedule) :- !.
weave2(LeftSchedule, [], LeftSchedule) :- !.

% Non-trivial case for weaving two lists. The algorithm chooses between initially
% choosing the head of the left or right by calculating the value of each option
% and choosing the higher value.
weave2([LeftHead|LeftTail], [RightHead|RightTail], Woven) :-

  weave2(LeftTail, [RightHead|RightTail], WovenRemainderLeft),
  weave2(RightTail, [LeftHead|LeftTail], WovenRemainderRight),

  WovenLeftFirst = [LeftHead|WovenRemainderLeft],
  WovenRightFirst = [RightHead|WovenRemainderRight],

  value_of_schedule(WovenLeftFirst, ValueLeftFirst),
  value_of_schedule(WovenRightFirst, ValueRightFirst),

  (ValueLeftFirst >= ValueRightFirst
    -> Woven = WovenLeftFirst
     ; Woven = WovenRightFirst).

% Base cases for weaving no schedules or a single schedule
weave([], []) :- !.
weave([Schedule], Schedule) :- !.

% Weaving two or more schedules together is done by weaving the first two and weaving
% this result with the remainder, if present.
weave([First|[Second|Remainder]], Woven) :-
  weave2(First, Second, WovenInitial),
  (Remainder = []
    -> Woven = WovenInitial
     ; weave([WovenInitial|Remainder], Woven)).
