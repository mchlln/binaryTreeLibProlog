/*
End of semester project : library implementing useful predicates for handling
binary trees in Prolog

We consider that binary trees are represented as nil (the empty tree) or as t(L, X, R),
where L and R are left and right subtrees.
The values in binary trees can be numbers or letters.
The values in binary search trees must be integers.
Here are some examples of trees to test the code, use them as follows :
?- my_full_tree(_T), is_full(_T).
For each of the predicates, you can see its description and the intended usage
*/
my_bst1(T) :- T = t(t(t(nil, 1, nil), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil))).
my_btree(T) :- T = t(t(t(nil, 5, nil), 3, t(nil, 4, nil)), 2, t(nil, 8, nil)).
my_full_tree(T) :- T = t(t(t(nil,4,nil),2,t(nil,7,nil)),5, t(nil, 6, nil)).
my_perfect_tree(T) :- T = t(t(nil, 1, nil),2,t(nil,3,nil)). %also bst
my_quasi_perfect_tree(T) :- T = t(t(t(nil, 1, nil), 3,t(nil, 4, nil)), 6, t(t(nil, 8, nil), 10, nil)). %also bst
my_alphabet_tree(T) :- T =t(t(t(nil, a, nil), c, t(nil,e , nil)), f, t(t(nil, h, nil),m, t(nil, n, nil))).

% OPERATIONS FOR BINARY TREES
/*
Predicate height(+T, ?H) that is true if H is the height of the binary tree T.

Usage:
    Find height of a tree
?- my_alphabet_tree(_T), height(_T,R).
R = 2.
    Check if T is of height H, correct result
?- my_alphabet_tree(_T), height(_T,2).
true.
    Check if T is of height H, wrong result
?- my_alphabet_tree(_T), height(_T,3).
false.
*/
height(nil, -1).
height(t(Left, _, Right), H) :-
    HL #>= -1, HR #>= -1, H #>= 0,
    H #= max(HL, HR) + 1, height(Left, HL), height(Right, HR).

/*Predicate maptree(P, T) that succeeds if a predicate P is true for every value
in a tree.

Usage:
    Checks that a predicate is true for all elements, true
?- my_btree(_T), maptree(<(1),_T).
true ;
false.
    Checks that a predicate is true for all elements, false
?- my_btree(_T), maptree(=(1),_T).
false.
*/
maptree(_, nil).
maptree(P, t(L, X, R)) :- call(P, X), maptree(P, L), maptree(P, R).

/*
Predicate foldr_tree(+P, ?T, ?A, ?R) that performs a right fold of a
predicate over all values in a tree.
*/
foldr_tree(_P, nil, A, A).
foldr_tree(P, t(L, X, R), A, Ret) :-
    foldr_tree(P, R, A, A1),
    call(P, X, A1, A2),
    foldr_tree(P,L, A2, Ret).


/*
Predicate flatten(+T, ?L) that flattens a tree, producing a list of
values in the tree. For any node t(L, X, R), the values in L should appear
before X in the list, and the values in R should appear after X.

Usage:
    Flatten the tree T into a list
?- my_btree(_T), flatten(_T, L).
L = [5, 3, 4, 2, 8] ;
false.
    Flatten an empty tree into a list
?- flatten(nil, L).
L = [] ;
false.
*/
cons(X, L, [X | L]).
flatten(T, L) :- foldr_tree(cons, T, [], L).

/*
Predicate count(+T, ?L) that counts all nodes in a tree,
can generate all trees of count N.

Usage:
    Count all nodes in a tree T, empty tree
?- count(nil, C).
C = 0.
    Count all nodes in a non empty tree
?- my_alphabet_tree(_T), count(_T,C).
C = 7.
*/
count(nil, 0).
count(t(L, _, R), N) :- N #>= 1, LN #>= 0, RN #>= 0, N #= LN + RN + 1,
                        count(L, LN), count(R, RN).

/*
Predicate leaf_count(+T, ?C) that gives the count C of the number of leaves in the binary tree T

Usage:
    Count all leaves in a tree T
?- my_alphabet_tree(_T), leaf_count(_T,C).
C = 4 ;
false.
    Count all leaves in an empty tree
?- leaf_count(nil,C).
C = 0.
    Check count of leaves
?- my_alphabet_tree(_T), leaf_count(_T,4).
true ;
false.
*/
leaf_count(nil,0).
leaf_count(t(nil, _, nil), 1).
leaf_count(t(L,_,nil),C) :- dif(L,nil),leaf_count(L,C).
leaf_count(t(nil,_,R),C) :- dif(R,nil),leaf_count(R,C).
leaf_count(t(L, _, R), C) :- dif(L,nil),dif(R,nil),C #= CL + CR, leaf_count(L, CL), leaf_count(R, CR).

/*
Predicate search(+T, ?X) that searches for a specified element X in a binary tree T.

Usage:
    Check if an element is present in a tree, element not inside
?- my_alphabet_tree(_T), search(_T,2).
false.
    Check if an element is present in a tree, element not inside
?- my_alphabet_tree(_T), search(_T,a).
true;
false.
    Give element present in the binary tree
?- my_alphabet_tree(_T), search(_T,R).
R = f ;
R = c ;
R = a ;
R = e ;
R = m ;
R = h ;
R = n ;
false.
*/
search(t(_, X, _), X).
search(t(L, _, _), X) :- search(L, X).
search(t(_, _, R), X) :- search(R, X).


/*
Predicate preorder_traversal(+T, ?Result) that performs a preorder traversal of a binary tree T and
gives the result in the list Result.

Usage:
    Performs preorder traversal of a tree
?- my_alphabet_tree(_T), preorder_traversal(_T,L).
L = [f, c, a, e, m, h, n].
    Check if the list corresponds to the preorder traversal of T
?- my_alphabet_tree(_T), preorder_traversal(_T,[f, c, a, e, m, h, n]).
true.
*/
preorder_traversal(nil, []).
preorder_traversal(t(L, X, R), [X|List]) :-
    preorder_traversal(L, LL),
    preorder_traversal(R, LR),
    append(LL, LR, List).

/*
Predicate inorder_traversal(+T, ?Result) that performs an in-order traversal of a binary tree T and
gives the result in the list Result.

Usage:
    Performs in-order traversal of a tree
?- my_alphabet_tree(_T), inorder_traversal(_T,L).
L = [a, c, e, f, h, m, n].
    Check if the list corresponds to the in-dorder traversal of T
?- my_alphabet_tree(_T), inorder_traversal(_T,[a, c, e, f, h, m, n]).
true.
*/
inorder_traversal(nil, []).
inorder_traversal(t(L, X, R), List) :-
    inorder_traversal(L, LL),
    inorder_traversal(R, LR),
    append(LL, [X], LTmp),
    append(LTmp, LR, List).

/*
Predicate postorder_traversal(+T, ?Result) that performs a postorder traversal of a binary tree T and
gives the result in the list Result.

Usage:
    Performs postorder traversal of a tree
?- my_alphabet_tree(_T), postorder_traversal(_T,L).
L = [a, e, c, h, n, m, f].
    Check if the list corresponds to the postorder traversal of T
?- my_alphabet_tree(_T), postorder_traversal(_T,[a, e, c, h, n, m, f]).
true.
*/
postorder_traversal(nil, []).
postorder_traversal(t(L, X, R), List) :-
    postorder_traversal(L, LL),
    postorder_traversal(R, LR),
    append(LL, LR, LTmp),
    append(LTmp, [X], List).

/*
Predicate nodes_at_depth(?T, ?D, ?Result) that gives a list Result containing all nodes of depth
T of a binary tree T.

Usage:
    Find all nodes at depth D in the tree T
?- my_alphabet_tree(_T), nodes_at_depth(_T, 2, R).
R = [a, e, h, n] ;
    Check if the nodes in the result list are at depth D in tree T
?- my_alphabet_tree(_T), nodes_at_depth(_T, 2, [a, e, h, n]).
true .
    Squeleton of a tree with nodes at depth D corresponding to the list Result
?- my_alphabet_tree(_T), nodes_at_depth(T, 2, [a, e, h, n]).
T = t(t(t(_, a, _), _, t(_, e, _)), _, t(t(_, h, _), _, t(_, n, _))) ;
false.
*/
nodes_at_depth(nil, _, []).
nodes_at_depth(t(_, X, _), 0, [X]).
nodes_at_depth(t(L, _, R), D, Res) :- D #> 0, NewD #= D - 1,
                            nodes_at_depth(L, NewD, NResL), nodes_at_depth(R,NewD, NResR),
                            append(NResL, NResR, Res).
/*
Predicate depth_of_node(+T, ?V, ?D) that gives the depth D of a node of value V in a binary tree T.
The depth is equal to -1 if the node is not in the tree.

Usage:
    Give the list of all nodes at depth D
?- my_alphabet_tree(_T), depth_of_node(_T,V, 2).
V = a ;
V = e ;
V = h ;
V = n ;
false.
    Check if a given node  of value V is at depth D
?- my_alphabet_tree(_T), depth_of_node(_T,a, 2).
true ;
false.
    Give the depth of a node of value V
?- my_alphabet_tree(_T), depth_of_node(_T,a, D).
D = 2 ;
false.
*/
depth_of_node(nil, _, -1).
depth_of_node(t(_, X, _), X, 0).
depth_of_node(t(L, X, _), V, D) :- dif(X, V), depth_of_node(L, V, D1), dif(D1, -1), D #= D1 + 1.
depth_of_node(t(_, X, R), V, D) :- dif(X, V), depth_of_node(R, V, D1), dif(D1, -1), D #= D1 + 1.


/*
Predicate is_leaf(+T, ?V) that returns true if the node of value V is a leaf of the binary
tree T.

Usage:
    Tell if a given node of value V is a leaf
?- my_alphabet_tree(_T), is_leaf(_T,a ).
true ;
false.
    Tell if a given node of value V is a leaf
?- my_alphabet_tree(_T), is_leaf(_T,b ).
false.
*/
is_leaf(t(nil, V, nil), V).
is_leaf(t(L, _, _), V) :- is_leaf(L, V).
is_leaf(t(_, _, R), V) :- is_leaf(R, V).

/*
Predicate is_full(?T) that returns true if the binary tree T is full.
All node has 0 or two leafs.

Usage:
    Say whether a tree is full
?- my_alphabet_tree(_T), is_full(_T ).
true ;
false.

?- my_quasi_perfect_tree(_T), is_full(_T ).
false.
*/
is_full(nil).
is_full(t(nil, _, nil)).
is_full(t(L, _, R)) :- dif(L, nil) , dif(R, nil), is_full(L), is_full(R).

/*
Predicate is_perfect(?T) that returns true if the binary tree T is perfect.
All leafs should be at the same depth.

Usage:
    Say whether a tree is perfect
?- my_quasi_perfect_tree(_T), is_perfect(_T ).
false.

?- my_perfect_tree(_T), is_perfect(_T ).
true.
*/
is_perfect(nil).
is_perfect(t(Left, _, Right)) :-
    count(Left, CL), count(Right, CR), CL #= CR,
    is_perfect(Left),
    is_perfect(Right).

/*
Predicate is_quasi_perfect(T) that returns true if the binary tree T is
quasi perfect.
-> all leafs are at depth h or h-1 (h = height of T), each subtree until
h-1 is full, leafs at depth h are on the left.

Usage:
    Say whether a tree is quasi perfect
?- my_quasi_perfect_tree(_T), is_quasi_perfect(_T ).
true ;
false.

?- my_bst1(_T), is_quasi_perfect(_T ).
false.
*/
is_quasi_perfect(nil).
is_quasi_perfect(t(L, _, R)) :- height(L, HL), height(R, HR),
                                HL - HR #= 0, is_full(L), is_quasi_perfect(R).
is_quasi_perfect(t(L, _, R)) :- height(L, HL), height(R, HR),
                                HL - HR #= 1, is_full(R), is_quasi_perfect(L).


%OPERATIONS ON BINARY SEARCH TREES

/*
Predicate is_bst(+T) that returns true if the binary tree T is a binary search tree.

Usage:
    Say whether a tree is a binary search tree
?- my_bst1(_T), is_bst(_T ).
true.

?- my_btree(_T), is_bst(_T ).
false.
*/
is_bst_aux(nil,_,_).
is_bst_aux(t(L,V,R),Min, Max) :- V #> Min, V #< Max,
                                NexMin #= V, NMax #= V,
                                is_bst_aux(L,Min,NMax), is_bst_aux(R,NexMin, Max).

is_bst(T):- is_bst_aux(T,-99999, 99999).

/*
Predicate search_bst(+T, +X) that searches for a specified element X in a binary search tree T.
Returns a boolean to indicate whether the element X is in T

Usage:
    Find a present element in the tree
?- my_btree(_T), search_bst(_T, 2 ).
true ;
false.
    Search for a absent element in the tree
?- my_btree(_T), search_bst(_T, 1 ).
false.
*/
search_bst(t(_, X, _), X).
search_bst(t(L, V, _), X) :-  X #< V, search_bst(L, X).
search_bst(t(_, V, R), X) :-  X #> V, search_bst(R, X).

/*
Predicate insert_bst(?X, ?T, ?T1) that inserts a value X into a binary search tree T,
producing a tree T1. If the value X is already in the tree T, then T1 should equal T.

Usage:
    Inserting a value already present in the bst
?- my_bst1(_T), insert_bst(1,_T,R).
R = t(t(t(nil, 1, nil), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil))) ;
false.
    Inserting a new value in the bst
?- my_bst1(_T), insert_bst(2,_T,R).
R = t(t(t(nil, 1, t(nil, 2, nil)), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil))) ;
false.
    Checking if we inserted X into T to make T1
?- my_bst1(_T), insert_bst(2,_T, t(t(t(nil, 1, t(nil, 2, nil)), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 1
0, nil)))).
true ;
false.
    Finding trees made by inserting X into T1
?-  insert_bst(2,T, t(t(t(nil, 1, t(nil, 2, nil)), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil)))).
T = t(t(t(nil, 1, nil), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil))) ;
T = t(t(t(nil, 1, t(nil, 2, nil)), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil))) ;
false.
    Find which value has been inserted into T to make T1
?- my_bst1(_T), insert_bst(R,_T, t(t(t(nil, 1, t(nil, 2, nil)), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 1
0, nil)))).
R = 2 ;
false.
    If T1 and T2 are identical, give the list of elements to insert into a nil tree to obtain T1
?- my_bst1(_T), insert_bst(R,_T, t(t(t(nil, 1, nil), 3, t(nil, 4, nil)), 5, t(nil, 8, t(nil, 10, nil)))).

R = 5 ;
R = 3 ;
R = 1 ;
R = 4 ;
R = 8 ;
R = 10 ;
false.
*/
insert_bst(X, nil, t(nil, X, nil)).
insert_bst(X, t(L,X,R), t(L, X, R)).
insert_bst(X, t(L, V, R), t(L2, V, R)) :- X #< V, insert_bst(X, L, L2).
insert_bst(X, t(L, V, R), t(L, V, R2)) :- X #> V, insert_bst(X, R, R2).

/*
Predicate delete_bst(X, +T, ?T1) that deletes a specified element X from a binary search
tree T, producing a tree T1. If the element X is not found in the tree T, then T1
should equal T.

Usage:
    Deleting an existing node from the binary search tree, returns the modified tree
?- my_quasi_perfect_tree(_T), delete_bst(6, _T, R).
R = t(t(t(nil, 1, nil), 3, nil), 4, t(t(nil, 8, nil), 10, nil)) ;
false.

    Deleting a non-existing node from a binary search tree, just returns the original tree
?- my_quasi_perfect_tree(_T), delete_bst(5, _T, R).
R = t(t(t(nil, 1, nil), 3, t(nil, 4, nil)), 6, t(t(nil, 8, nil), 10, nil)) ;
false.
*/
delete_bst(_, nil, nil).
delete_bst(X, t(nil, X, nil), nil).
delete_bst(X, t(L, X, nil), L):- dif(L,nil).
delete_bst(X, t(nil, X, R), R) :- dif(R,nil).

delete_bst(X, t(L, V, R), t(Res, V, R)) :- X #< V, delete_bst(X, L, Res).
delete_bst(X, t(L, V, R), t(L, V, Res)) :- X #> V, delete_bst(X, R, Res).

delete_bst(X, t(L, X, R), t(NL, MaxL, R)) :-
    dif(L,nil), max_value_bst(L, MaxL), delete_bst(MaxL, L, NL).

/*
Predicate max_value_bst(+T, ?Max) that finds the maximum value Max in the binary search tree T
If the tree is empty, returns -99999, assuming that we have trees with values greater than this.
Usage:
    Finding the maximum element in a binary search tree
?- my_bst1(_T), max_value_bst(_T,R).
R = 10 ;
false.
    Checking the maximum element of a bst, with right result.
?- my_bst1(_T), max_value_bst(_T,10).
true ;
false.
    Checking the maximum element of a bst, with right result.
?- my_bst1(_T), max_value_bst(_T,1).
false.
    Checking the maximum element of a nil bst.
?- max_value_bst(nil,R).
R = -99999.
*/
max_value_bst(nil, -99999).
max_value_bst(t(_, X, nil), X).
max_value_bst(t(_, _, R), Max) :- dif(R, nil), max_value_bst(R, Max).

/*
Predicate min_value_bst(+T, ?Min) that finds the minimum value Min in the binary search tree T
If the tree is empty, returns 99999, assuming that we have trees with values smaller than this.

Usage:
    Finding the minimum element in a binary search tree
?- my_bst1(_T), min_value_bst(_T,R).
R = 1;
false.
    Checking the minimum element of a bst, with right result.
?- my_bst1(_T), min_value_bst(_T,1).
true ;
false.
    Checking the minimum element of a bst, with right result.
?- my_bst1(_T), min_value_bst(_T,10).
false.
    Checking the minimum element of a nil bst.
?- min_value_bst(nil,R).
R = 99999.

*/
min_value_bst(nil, 99999).
min_value_bst(t(nil, X, _), X).
min_value_bst(t(L, _, _), Min) :- dif(L, nil), min_value_bst(L, Min).
