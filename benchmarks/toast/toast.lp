#theory qf_lia {
    linear_term {
        + : 5, unary;
        - : 5, unary;
        * : 4, binary, left;
        + : 3, binary, left;
        - : 3, binary, left
    };

    dom_term {
        + : 5, unary;
        - : 5, unary;
        .. : 1, binary, left
    };

    &dom/0 : dom_term, {=}, linear_term, any;
    &sum/0 : linear_term, {<=,=,>=,<,>,!=}, linear_term, any
}.

#const numBread=10.

%% __domain(1..numBread):- numBread > 1.
%% $domain(1..2):- numBread == 1.

bread(1..numBread).
side(1..2).

% Toasting consists of a piece of bread with two sides
toast(B,S):-bread(B),side(S).

&dom {1..numBread} = csptoast(B,S) :- toast(B,S).

% Without loss of generality, we toast the first side before the second and cannot be done simultaneously
&sum { csptoast(B,S1) } < csptoast(B,S2) :- toast(B,S1), toast(B,S2), S1 < S2.

% Without lost of generality, we toast the first piece before the next
&sum { csptoast(B1,S) } <= csptoast(B2,S) :- toast(B1,S), toast(B2,S), B1 < B2.

% If there are two pieces of bread being toasted, then all other pieces must be toasted at a different time.
&sum { csptoast(B3,S3) } != csptoast(B1,S1) :- &sum { csptoast(B1,S1) } = csptoast(B2,S2), toast(B1,S1), toast(B2,S2), toast(B3,S3), B3 != B1, B3 != B2, B1 != B2.

&dom {0..1000} = totalMinutes.

&sum {totalMinutes} = csptoast(numBread,2).
