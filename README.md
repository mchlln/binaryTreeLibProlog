# Binary Tree Predicate Library

This Prolog library provides predicates for handling binary trees. Binary trees are represented as `nil` (the empty tree) or as `t(L, X, R)`, where L and R are left and right subtrees. The values in binary trees can be numbers or letters. For binary search trees, the values must be integers.

## Use the library

1. Download the file `binary_trees_library.pl`.
2. Load the file into Prolog either in your code or in your interpreter with the following command `use_module('path/to/binary_tree_library.pl').`
3. Use the predicates.


## Overview of the predicates

Below are all the predicates I implemented for the library.
You will find a more detailed usage with code snippets in the `binary_tree_library.pl` file.

### Operations for Binary Trees

#### `height(+T, ?H)`
- Returns the height `H` of the binary tree `T`.

#### `maptree(P, T)`
- Succeeds if predicate `P` is true for every value in the tree `T`.

#### `foldr_tree(+P, ?T, ?A, ?R)`
- Performs a right fold of a predicate over all values in a tree.

#### `flatten(+T, ?L)`
- Flattens a tree `T`, producing a list of values `L`.

#### `count(+T, ?L)`
- Counts all nodes in a tree.

#### `leaf_count(+T, ?C)`
- Counts the number of leaves in the binary tree `T`.

#### `search(+T, ?X)`
- Searches for a specified element `X` in a binary tree `T`.

#### `preorder_traversal(+T, ?Result)`
- Performs a preorder traversal of a binary tree `T`.

#### `inorder_traversal(+T, ?Result)`
- Performs an in-order traversal of a binary tree `T`.

#### `post-order_traversal(+T, ?Result)`
- Performs a postorder traversal of a binary tree `T`.

#### `nodes_at_depth(?T, ?D, ?Result)`
- Gives a list `Result` containing all nodes of depth `D` in a binary tree `T`.

#### `depth_of_node(+T, ?V, ?D)`
- Gives the depth `D` of a node of value `V` in a binary tree `T`.

#### `is_leaf(+T, ?V)`
- Returns true if the node of value `V` is a leaf of the binary tree `T`.

#### `is_full(?T)`
- Returns true if the binary tree `T` is full.

#### `is_perfect(?T)`
- Returns true if the binary tree `T` is perfect.

#### `is_quasi_perfect(?T)`
- Returns true if the binary tree `T` is quasi-perfect.

### Operations on Binary Search Trees (BST)

#### `is_bst(+T)`
- Returns true if the binary tree `T` is a binary search tree.

#### `search_bst(+T, +X)`
- Searches for a specified element `X` in a binary search tree `T`.

#### `insert_bst(?X, ?T, ?T1)`
- Inserts a value `X` into a binary search tree `T`, producing a tree `T1`.

#### `delete_bst(X, +T, ?T1)`
- Deletes a specified element `X` from a binary search tree `T`, producing a tree `T1`.

#### `max_value_bst(+T, ?Max)`
- Finds the maximum value `Max` in the binary search tree `T`.

#### `min_value_bst(+T, ?Min)`
- Finds the minimum value `Min` in the binary search tree `T`.

## Testing

Here are some examples of trees that I have used to test the code:

- `my_bst1(T)` - Binary search tree with integer values.
- `my_btree(T)` - Binary tree with non-integer values.
- `my_full_tree(T)` - Full binary tree.
- `my_perfect_tree(T)` - Perfect binary tree (also a binary search tree).
- `my_quasi_perfect_tree(T)` - Quasi-perfect binary tree (also a binary search tree).
- `my_alphabet_tree(T)` - Binary tree with alphabet letters.

Example usage:

```prolog
?- my_full_tree(_T), is_full(_T).
```

## License

This library is released under the MIT License *(see more information about it in file `LICENSE`)*.
