:- use_module(library(clpfd)).

solver(Rows) :-
    length(Rows, 9),
    maplist(same_length(Rows), Rows),
    append(Rows, Vs),
    Vs ins 1..9,
    maplist(all_distinct, Rows),
    transpose(Rows, Columns),
    maplist(all_distinct, Columns), 

    Rows = [A,B,C,D,E,F,G,H,I],
    squares(A, B, C),
    squares(D, E, F),
    squares(G, H, I),

    maplist(labeling([ff]), Rows).

squares([], [], []).
squares( [A, B, C | Ss1],
         [D, E, F | Ss2],
         [G, H, I | Ss3]) :-
    all_distinct([A, B, C, D, E, F, G, H, I]),
    squares(Ss1, Ss2, Ss3).

difficulty(Rows, Start, Diff, Dest, Ffsear):-
    append(Rows, Cs),
    count(Cs, Start),

    weakprop(Rows, Diff),
    constraintprop(Rows, Dest),
    ffsearch(Rows, Ffsear),

    Weak is ((Diff - Start) / (81 - Start)) * 100,
    /* This is ONLY intelligent propagation, not including weak propogation
    that also exists within constraint propagation */
    Constraint is ((Dest - Start) / (81 - Start)) * 100,
    /* Unless the input is invalid, this should always be 1.0 */
    Ffsearch is ((Ffsear - Start) / (81 - Start)) * 100,

    write('\nPercent Solved from start:'),
    write('\nWeak Propagation: %'),
    format('~2f~n', [Weak]),
    write('Constraint Propagation: %'),
    format('~2f~n', [Constraint]),
    write('Search: %'),
    format('~2f~n', [Ffsearch]),
    write('\n').

weakprop(Rows, N):-
    length(Rows, 9),
    maplist(same_length(Rows), Rows),
    append(Rows, Vs),
    Vs ins 1..9,
    maplist(all_different, Rows),
    transpose(Rows, Columns),
    maplist(all_different, Columns),

    Rows = [A,B,C,D,E,F,G,H,I],
    squares(A, B, C),
    squares(D, E, F),
    squares(G, H, I),

    append(Rows, Cs),
    count(Cs, N).

constraintprop(Rows, N):-
    length(Rows, 9),
    maplist(same_length(Rows), Rows),
    append(Rows, Vs),
    Vs ins 1..9,
    maplist(all_distinct, Rows),
    transpose(Rows, Columns),
    maplist(all_distinct, Columns),

    Rows = [A,B,C,D,E,F,G,H,I],
    squares(A, B, C),
    squares(D, E, F),
    squares(G, H, I),

    append(Rows, Cs),
    count(Cs, N).

/* Uses search to fill in the Latin Square. Although this works well
and is fast in this context, it is not the most efficient way of solving
this problem. */
ffsearch(Rows, N):-
    length(Rows, 9),
    maplist(same_length(Rows), Rows),
    append(Rows, Vs),
    Vs ins 1..9,
    maplist(label, Rows),
    transpose(Rows, Columns),
    maplist(label, Columns),

    Rows = [A,B,C,D,E,F,G,H,I],
    squares(A, B, C),
    squares(D, E, F),
    squares(G, H, I),

    append(Rows, Cs),
    count(Cs, N).

count([],0).
count([H|Tail], N) :-
    count(Tail, N1),
    (  number(H)
    -> N is N1 + 1
    ;  N = N1
    ).

puzzle(1,  [[_,4,_,9,_,_,_,5,_],
            [2,_,_,_,_,_,_,4,_],
            [1,9,_,_,8,_,7,_,_],
            [5,_,_,_,_,_,1,_,_],
            [_,_,7,_,6,_,_,_,3],
            [_,_,_,_,3,_,8,9,_],
            [_,8,_,3,4,_,_,6,_],
            [3,_,_,2,_,8,_,_,_],
            [_,_,_,_,_,_,_,_,_]]).

puzzle(2,  [[_,_,9,5,_,_,_,3,7],
            [1,3,7,9,_,_,_,5,2],
            [2,_,_,_,_,3,6,9,_],
            [3,5,2,_,1,_,_,_,6],
            [_,_,_,4,5,2,3,_,_],
            [_,8,1,_,3,_,2,_,_],
            [6,_,3,_,4,_,8,_,9],
            [5,2,_,_,_,1,_,6,_],
            [_,_,_,3,_,7,_,_,_]]).

puzzle(3,  [[_,5,_,1,_,_,_,_,_],
            [2,_,_,5,_,_,6,_,_],
            [1,_,_,_,8,_,2,_,_],
            [_,8,_,4,3,_,_,_,_],
            [_,_,_,_,_,_,_,4,_],
            [_,_,_,_,_,7,9,3,2],
            [_,4,_,6,7,_,_,_,_],
            [_,7,_,_,_,_,_,1,9],
            [9,_,_,_,_,8,_,_,_]]).