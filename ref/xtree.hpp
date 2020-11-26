/* xtree
	Copyright (c) Microsoft Corporation.
	SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
*/
#pragma once
#ifndef _XTREE_
#define _XTREE_
#include "yvals_core.h"
#if _STL_COMPILER_PREPROCESSOR
#include <xmemory>

#if _HAS_CXX17
#include <xnode_handle.h>
#endif // _HAS_CXX17

#pragma pack(push, _CRT_PACKING)
#pragma warning(push, _STL_WARNING_LEVEL)
#pragma warning(disable : _STL_DISABLED_WARNINGS)
_STL_DISABLE_CLANG_WARNINGS
#pragma push_macro("new")
#undef new

namespace std {
	// CLASS TEMPLATE Tree_unchecked_const_iterator
	template <class _Mytree, class _Base = _Iterator_base0>
	class Tree_unchecked_const_iterator : public _Base {
	public:
		using iterator_category = bidirectional_iterator_tag;

		using node_pointer = typename _Mytree::node_pointer;
		using value_type = typename _Mytree::value_type;
		using difference_type = typename _Mytree::difference_type;
		using pointer = typename _Mytree::const_pointer;
		using reference = const value_type&;

		Tree_unchecked_const_iterator() noexcept : _Ptr() {}

		Tree_unchecked_const_iterator(node_pointer _Pnode, const _Mytree* _Plist) noexcept : _Ptr(_Pnode) {
			this->_Adopt(_Plist);
		}

		[[nodiscard]] reference operator*() const {
			return _Ptr->Value;
		}

		[[nodiscard]] pointer operator->() const {
			return pointer_traits<pointer>::pointer_to(**this);
		}

		Tree_unchecked_const_iterator& operator++() {
			if (_Ptr->Node_right->Is_nil) { // climb looking for right subtree
				node_pointer _Pnode;
				while (!(_Pnode = _Ptr->Node_parent)->Is_nil && _Ptr == _Pnode->Node_right) {
					_Ptr = _Pnode; // ==> parent while right subtree
				}

				_Ptr = _Pnode; // ==> parent (head if end())
			} else {
				_Ptr = _Mytree::find_leftest(_Ptr->Node_right); // ==> smallest of right subtree
			}

			return *this;
		}

		Tree_unchecked_const_iterator operator++(int) {
			Tree_unchecked_const_iterator _Tmp = *this;
			++* this;
			return _Tmp;
		}

		Tree_unchecked_const_iterator& operator--() {
			if (_Ptr->Is_nil) {
				_Ptr = _Ptr->Node_right; // end() ==> rightmost
			} else if (_Ptr->Node_left->Is_nil) { // climb looking for left subtree
				node_pointer _Pnode;
				while (!(_Pnode = _Ptr->Node_parent)->Is_nil && _Ptr == _Pnode->Node_left) {
					_Ptr = _Pnode; // ==> parent while left subtree
				}

				if (!_Ptr->Is_nil) { // decrement non-begin()
					_Ptr = _Pnode; // ==> parent if not head
				}
			} else {
				_Ptr = _Mytree::find_rightest(_Ptr->Node_left); // ==> largest of left subtree
			}

			return *this;
		}

		Tree_unchecked_const_iterator operator--(int) {
			Tree_unchecked_const_iterator _Tmp = *this;
			--* this;
			return _Tmp;
		}

		[[nodiscard]] bool operator==(const Tree_unchecked_const_iterator& Node_right) const {
			return _Ptr == Node_right._Ptr;
		}

		[[nodiscard]] bool operator!=(const Tree_unchecked_const_iterator& Node_right) const {
			return !(*this == Node_right);
		}

		[[nodiscard]] bool operator==(_Default_sentinel) const noexcept {
			return !!_Ptr->Is_nil; // TRANSITION, avoid warning C4800:
									// "Implicit conversion from 'char' to bool. Possible information loss" (/Wall)
		}

		[[nodiscard]] bool operator!=(_Default_sentinel) const noexcept {
			return !_Ptr->Is_nil;
		}

		node_pointer _Ptr; // pointer to node
	};

	// CLASS TEMPLATE Tree_unchecked_iterator
	template <class _Mytree>
	class Tree_unchecked_iterator : public Tree_unchecked_const_iterator<_Mytree> {
	public:
		using _Mybase = Tree_unchecked_const_iterator<_Mytree>;
		using iterator_category = bidirectional_iterator_tag;

		using node_pointer = typename _Mytree::node_pointer;
		using value_type = typename _Mytree::value_type;
		using difference_type = typename _Mytree::difference_type;
		using pointer = typename _Mytree::pointer;
		using reference = value_type&;

		using _Mybase::_Mybase;

		reference operator*() const {
			return const_cast<reference>(_Mybase::operator*());
		}

		pointer operator->() const {
			return pointer_traits<pointer>::pointer_to(**this);
		}

		Tree_unchecked_iterator& operator++() {
			_Mybase::operator++();
			return *this;
		}

		Tree_unchecked_iterator operator++(int) {
			Tree_unchecked_iterator _Tmp = *this;
			_Mybase::operator++();
			return _Tmp;
		}

		Tree_unchecked_iterator& operator--() {
			_Mybase::operator--();
			return *this;
		}

		Tree_unchecked_iterator operator--(int) {
			Tree_unchecked_iterator _Tmp = *this;
			_Mybase::operator--();
			return _Tmp;
		}
	};

	// CLASS TEMPLATE Tree_const_iterator
	template <class _Mytree>
	class Tree_const_iterator : public Tree_unchecked_const_iterator<_Mytree, _Iterator_base> {
	public:
		using _Mybase = Tree_unchecked_const_iterator<_Mytree, _Iterator_base>;
		using iterator_category = bidirectional_iterator_tag;

		using node_pointer = typename _Mytree::node_pointer;
		using value_type = typename _Mytree::value_type;
		using difference_type = typename _Mytree::difference_type;
		using pointer = typename _Mytree::const_pointer;
		using reference = const value_type&;

		using _Mybase::_Mybase;

		reference operator*() const {
	#if _ITERATOR_DEBUG_LEVEL == 2
			const auto _Mycont = static_cast<const _Mytree*>(this->_Getcont());
			_STL_ASSERT(_Mycont, "cannot dereference value-initialized map/set iterator");
			_STL_VERIFY(this->_Ptr != _Mycont->Node_head, "cannot dereference end map/set iterator");
	#endif // _ITERATOR_DEBUG_LEVEL == 2

			return this->_Ptr->Value;
		}

		pointer operator->() const {
			return pointer_traits<pointer>::pointer_to(**this);
		}

		Tree_const_iterator& operator++() {
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(this->_Getcont(), "cannot increment value-initialized map/set iterator");
			_STL_VERIFY(!this->_Ptr->Is_nil, "cannot increment end map/set iterator");
	#endif // _ITERATOR_DEBUG_LEVEL == 2

			_Mybase::operator++();
			return *this;
		}

		Tree_const_iterator operator++(int) {
			Tree_const_iterator _Tmp = *this;
			++* this;
			return _Tmp;
		}

		Tree_const_iterator& operator--() {
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_ASSERT(this->_Getcont(), "cannot decrement value-initialized map/set iterator");
			node_pointer _Ptrsav = this->_Ptr;
			_Mybase::operator--();
			_STL_VERIFY(_Ptrsav != this->_Ptr, "cannot decrement begin map/set iterator");
	#else // ^^^ _ITERATOR_DEBUG_LEVEL == 2 ^^^ // vvv _ITERATOR_DEBUG_LEVEL != 2 vvv
			_Mybase::operator--();
	#endif // _ITERATOR_DEBUG_LEVEL == 2

			return *this;
		}

		Tree_const_iterator operator--(int) {
			Tree_const_iterator _Tmp = *this;
			--* this;
			return _Tmp;
		}

		[[nodiscard]] bool operator==(const Tree_const_iterator& Node_right) const {
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(this->_Getcont() == Node_right._Getcont(), "map/set iterators incompatible");
	#endif // _ITERATOR_DEBUG_LEVEL == 2

			return this->_Ptr == Node_right._Ptr;
		}

		[[nodiscard]] bool operator!=(const Tree_const_iterator& Node_right) const {
			return !(*this == Node_right);
		}

	#if _ITERATOR_DEBUG_LEVEL == 2
		friend void _Verify_range(const Tree_const_iterator& _First, const Tree_const_iterator& _Last) {
			_STL_VERIFY(_First._Getcont() == _Last._Getcont(), "map/set iterators in range are from different containers");
		}
	#endif // _ITERATOR_DEBUG_LEVEL == 2

		using _Prevent_inheriting_unwrap = Tree_const_iterator;

		[[nodiscard]] Tree_unchecked_const_iterator<_Mytree> _Unwrapped() const {
			return Tree_unchecked_const_iterator<_Mytree>(this->_Ptr, static_cast<const _Mytree*>(this->_Getcont()));
		}

		void _Seek_to(const Tree_unchecked_const_iterator<_Mytree> _It) {
			this->_Ptr = _It._Ptr;
		}
	};

	// CLASS TEMPLATE Tree_iterator
	template <class _Mytree>
	class Tree_iterator : public Tree_const_iterator<_Mytree> {
	public:
		using _Mybase = Tree_const_iterator<_Mytree>;
		using iterator_category = bidirectional_iterator_tag;

		using node_pointer = typename _Mytree::node_pointer;
		using value_type = typename _Mytree::value_type;
		using difference_type = typename _Mytree::difference_type;

		using pointer = typename _Mytree::pointer;
		using reference = value_type&;

		using _Mybase::_Mybase;

		[[nodiscard]] reference operator*() const {
			return const_cast<reference>(_Mybase::operator*());
		}

		[[nodiscard]] pointer operator->() const {
			return pointer_traits<pointer>::pointer_to(**this);
		}

		Tree_iterator& operator++() {
			_Mybase::operator++();
			return *this;
		}

		Tree_iterator operator++(int) {
			Tree_iterator _Tmp = *this;
			_Mybase::operator++();
			return _Tmp;
		}

		Tree_iterator& operator--() {
			_Mybase::operator--();
			return *this;
		}

		Tree_iterator operator--(int) {
			Tree_iterator _Tmp = *this;
			_Mybase::operator--();
			return _Tmp;
		}

		using _Prevent_inheriting_unwrap = Tree_iterator;

		[[nodiscard]] Tree_unchecked_iterator<_Mytree> _Unwrapped() const {
			return Tree_unchecked_iterator<_Mytree>(this->_Ptr, static_cast<const _Mytree*>(this->_Getcont()));
		}
	};

	// tree TYPE WRAPPERS
	template <class _Value_type, class _Size_type, class _Difference_type, class _Pointer, class _Const_pointer,
		class _Reference, class _Const_reference, class _Nodeptr_type>
		struct Tree_iterator_defines {
		using value_type = _Value_type;
		using size_type = _Size_type;
		using difference_type = _Difference_type;
		using pointer = _Pointer;
		using const_pointer = _Const_pointer;
		using node_pointer = _Nodeptr_type;
	};

	template <class _Value_type, class _Voidptr>
	struct Tree_node {
		using node_pointer = _Rebind_pointer_t<_Voidptr, Tree_node>;
		using value_type = _Value_type;
		node_pointer Node_left; // left subtree, or smallest element if head
		node_pointer Node_parent; // parent, or root of tree if head
		node_pointer Node_right; // right subtree, or largest element if head
		char Color; // Red or Black, Black if head
		char Is_nil; // true only if head (also nil) node; TRANSITION, should be bool
		value_type Value; // the stored value, unused if head

		enum RB_colors { // colors for link to parent
			Red,
			Black
		};

		Tree_node(const Tree_node&) = delete;
		Tree_node& operator=(const Tree_node&) = delete;

		template <class _Alloc>
		static node_pointer _Buyheadnode(_Alloc& _Al) {
			static_assert(is_same_v<typename _Alloc::value_type, Tree_node>, "Bad _Buyheadnode call");
			const auto _Pnode = _Al.allocate(1);
			_Construct_in_place(_Pnode->Node_left, _Pnode);
			_Construct_in_place(_Pnode->Node_parent, _Pnode);
			_Construct_in_place(_Pnode->Node_right, _Pnode);
			_Pnode->Color = Black;
			_Pnode->Is_nil = true;
			return _Pnode;
		}

		template <class _Alloc, class... _Valty>
		static node_pointer _Buynode(_Alloc& _Al, node_pointer head, _Valty&&... _Val) {
			// allocate a node with defaults and set links and value
			static_assert(is_same_v<typename _Alloc::value_type, Tree_node>, "Bad _Buynode call");
			_Alloc_construct_ptr<_Alloc> _Newnode(_Al);
			_Newnode._Allocate();
			allocator_traits<_Alloc>::construct(_Al, _STD addressof(_Newnode._Ptr->Value), _STD forward<_Valty>(_Val)...);
			_Construct_in_place(_Newnode._Ptr->Node_left, head);
			_Construct_in_place(_Newnode._Ptr->Node_parent, head);
			_Construct_in_place(_Newnode._Ptr->Node_right, head);
			_Newnode._Ptr->Color = Red;
			_Newnode._Ptr->Is_nil = false;
			return _Newnode._Release();
		}

		template <class _Alloc>
		static void _Freenode0(_Alloc& _Al, node_pointer _Ptr) noexcept {
			static_assert(is_same_v<typename _Alloc::value_type, Tree_node>, "Bad _Freenode0 call");
			_Destroy_in_place(_Ptr->Node_left);
			_Destroy_in_place(_Ptr->Node_parent);
			_Destroy_in_place(_Ptr->Node_right);
			allocator_traits<_Alloc>::deallocate(_Al, _Ptr, 1);
		}

		template <class _Alloc>
		static void _Freenode(_Alloc& _Al, node_pointer _Ptr) noexcept {
			static_assert(is_same_v<typename _Alloc::value_type, Tree_node>, "Bad _Freenode call");
			allocator_traits<_Alloc>::destroy(_Al, _STD addressof(_Ptr->Value));
			_Freenode0(_Al, _Ptr);
		}
	};

	template <class _Ty>
	struct _Tree_simple_types : _Simple_types<_Ty> {
		using _Node = Tree_node<_Ty, void*>;
		using node_pointer = _Node*;
	};

	enum class _Tree_child {
		Node_right, // perf note: compare with Node_right rather than Node_left where possible for comparison with zero
		Node_left,
		_Unused // indicates that tree child should never be used for insertion
	};

	template <class node_pointer>
	struct _Tree_id {
		node_pointer Node_parent; // the leaf node under which a new node should be inserted
		_Tree_child _Child;
	};

	template <class node_pointer>
	struct _Tree_find_result {
		_Tree_id<node_pointer> _Location;
		node_pointer _Bound;
	};

	template <class node_pointer>
	struct _Tree_find_hint_result {
		_Tree_id<node_pointer> _Location;
		bool _Duplicate;
	};

	[[noreturn]] inline void _Throw_tree_length_error() {
		_Xlength_error("map/set too long");
	}

	// CLASS TEMPLATE _Tree_val
	template <class _Val_types>
	class _Tree_val : public _Container_base {
	public:
		using node_pointer = typename _Val_types::node_pointer;

		using value_type = typename _Val_types::value_type;
		using size_type = typename _Val_types::size_type;
		using difference_type = typename _Val_types::difference_type;
		using pointer = typename _Val_types::pointer;
		using const_pointer = typename _Val_types::const_pointer;
		using reference = value_type&;
		using const_reference = const value_type&;

		using _Unchecked_const_iterator = Tree_unchecked_const_iterator<_Tree_val>;
		using const_iterator = Tree_const_iterator<_Tree_val>;

		_Tree_val() noexcept : Node_head(), inner_Size(0) {}

		enum RB_colors { // colors for link to parent
			Red,
			Black
		};

		static node_pointer find_rightest(node_pointer _Pnode) noexcept { // return rightmost node in subtree at _Pnode
			while (!_Pnode->Node_right->Is_nil) {
				_Pnode = _Pnode->Node_right;
			}

			return _Pnode;
		}

		static node_pointer find_leftest(node_pointer _Pnode) noexcept { // return leftmost node in subtree at _Pnode
			while (!_Pnode->Node_left->Is_nil) {
				_Pnode = _Pnode->Node_left;
			}

			return _Pnode;
		}

		void rotate_left(node_pointer _Wherenode) noexcept { // promote right node to root of subtree
			node_pointer _Pnode = _Wherenode->Node_right;
			_Wherenode->Node_right = _Pnode->Node_left;

			if (!_Pnode->Node_left->Is_nil) {
				_Pnode->Node_left->Node_parent = _Wherenode;
			}

			_Pnode->Node_parent = _Wherenode->Node_parent;

			if (_Wherenode == Node_head->Node_parent) {
				Node_head->Node_parent = _Pnode;
			} else if (_Wherenode == _Wherenode->Node_parent->Node_left) {
				_Wherenode->Node_parent->Node_left = _Pnode;
			} else {
				_Wherenode->Node_parent->Node_right = _Pnode;
			}

			_Pnode->Node_left = _Wherenode;
			_Wherenode->Node_parent = _Pnode;
		}

		void rotate_right(node_pointer _Wherenode) noexcept { // promote left node to root of subtree
			node_pointer _Pnode = _Wherenode->Node_left;
			_Wherenode->Node_left = _Pnode->Node_right;

			if (!_Pnode->Node_right->Is_nil) {
				_Pnode->Node_right->Node_parent = _Wherenode;
			}

			_Pnode->Node_parent = _Wherenode->Node_parent;

			if (_Wherenode == Node_head->Node_parent) {
				Node_head->Node_parent = _Pnode;
			} else if (_Wherenode == _Wherenode->Node_parent->Node_right) {
				_Wherenode->Node_parent->Node_right = _Pnode;
			} else {
				_Wherenode->Node_parent->Node_left = _Pnode;
			}

			_Pnode->Node_right = _Wherenode;
			_Wherenode->Node_parent = _Pnode;
		}

		node_pointer erase_at(_Unchecked_const_iterator _Where) noexcept {
			node_pointer _Erasednode = _Where._Ptr; // node to erase
			++_Where; // save successor iterator for return

			node_pointer _Fixnode; // the node to recolor as needed
			node_pointer _Fixnodeparent; // parent of _Fixnode (which may be nil)
			node_pointer _Pnode = _Erasednode;

			if (_Pnode->Node_left->Is_nil) {
				_Fixnode = _Pnode->Node_right; // stitch up right subtree
			} else if (_Pnode->Node_right->Is_nil) {
				_Fixnode = _Pnode->Node_left; // stitch up left subtree
			} else { // two subtrees, must lift successor node to replace erased
				_Pnode = _Where._Ptr; // _Pnode is successor node
				_Fixnode = _Pnode->Node_right; // _Fixnode is only subtree
			}

			if (_Pnode == _Erasednode) { // at most one subtree, relink it
				_Fixnodeparent = _Erasednode->Node_parent;
				if (!_Fixnode->Is_nil) {
					_Fixnode->Node_parent = _Fixnodeparent; // link up
				}

				if (Node_head->Node_parent == _Erasednode) {
					Node_head->Node_parent = _Fixnode; // link down from root
				} else if (_Fixnodeparent->Node_left == _Erasednode) {
					_Fixnodeparent->Node_left = _Fixnode; // link down to left
				} else {
					_Fixnodeparent->Node_right = _Fixnode; // link down to right
				}

				if (Node_head->Node_left == _Erasednode) {
					Node_head->Node_left = _Fixnode->Is_nil ? _Fixnodeparent // smallest is parent of erased node
						: find_leftest(_Fixnode); // smallest in relinked subtree
				}

				if (Node_head->Node_right == _Erasednode) {
					Node_head->Node_right = _Fixnode->Is_nil ? _Fixnodeparent // largest is parent of erased node
						: find_rightest(_Fixnode); // largest in relinked subtree
				}
			} else { // erased has two subtrees, _Pnode is successor to erased
				_Erasednode->Node_left->Node_parent = _Pnode; // link left up
				_Pnode->Node_left = _Erasednode->Node_left; // link successor down

				if (_Pnode == _Erasednode->Node_right) {
					_Fixnodeparent = _Pnode; // successor is next to erased
				} else { // successor further down, link in place of erased
					_Fixnodeparent = _Pnode->Node_parent; // parent is successor's
					if (!_Fixnode->Is_nil) {
						_Fixnode->Node_parent = _Fixnodeparent; // link fix up
					}

					_Fixnodeparent->Node_left = _Fixnode; // link fix down
					_Pnode->Node_right = _Erasednode->Node_right; // link next down
					_Erasednode->Node_right->Node_parent = _Pnode; // right up
				}

				if (Node_head->Node_parent == _Erasednode) {
					Node_head->Node_parent = _Pnode; // link down from root
				} else if (_Erasednode->Node_parent->Node_left == _Erasednode) {
					_Erasednode->Node_parent->Node_left = _Pnode; // link down to left
				} else {
					_Erasednode->Node_parent->Node_right = _Pnode; // link down to right
				}

				_Pnode->Node_parent = _Erasednode->Node_parent; // link successor up
				_STD swap(_Pnode->Color, _Erasednode->Color); // recolor it
			}

			if (_Erasednode->Color == Black) { // erasing black link, must recolor/rebalance tree
				for (; _Fixnode != Node_head->Node_parent && _Fixnode->Color == Black; _Fixnodeparent = _Fixnode->Node_parent) {
					if (_Fixnode == _Fixnodeparent->Node_left) { // fixup left subtree
						_Pnode = _Fixnodeparent->Node_right;
						if (_Pnode->Color == Red) { // rotate red up from right subtree
							_Pnode->Color = Black;
							_Fixnodeparent->Color = Red;
							rotate_left(_Fixnodeparent);
							_Pnode = _Fixnodeparent->Node_right;
						}

						if (_Pnode->Is_nil) {
							_Fixnode = _Fixnodeparent; // shouldn't happen
						} else if (_Pnode->Node_left->Color == Black
									&& _Pnode->Node_right->Color == Black) { // redden right subtree with black children
							_Pnode->Color = Red;
							_Fixnode = _Fixnodeparent;
						} else { // must rearrange right subtree
							if (_Pnode->Node_right->Color == Black) { // rotate red up from left sub-subtree
								_Pnode->Node_left->Color = Black;
								_Pnode->Color = Red;
								rotate_right(_Pnode);
								_Pnode = _Fixnodeparent->Node_right;
							}

							_Pnode->Color = _Fixnodeparent->Color;
							_Fixnodeparent->Color = Black;
							_Pnode->Node_right->Color = Black;
							rotate_left(_Fixnodeparent);
							break; // tree now recolored/rebalanced
						}
					} else { // fixup right subtree
						_Pnode = _Fixnodeparent->Node_left;
						if (_Pnode->Color == Red) { // rotate red up from left subtree
							_Pnode->Color = Black;
							_Fixnodeparent->Color = Red;
							rotate_right(_Fixnodeparent);
							_Pnode = _Fixnodeparent->Node_left;
						}

						if (_Pnode->Is_nil) {
							_Fixnode = _Fixnodeparent; // shouldn't happen
						} else if (_Pnode->Node_right->Color == Black
									&& _Pnode->Node_left->Color == Black) { // redden left subtree with black children
							_Pnode->Color = Red;
							_Fixnode = _Fixnodeparent;
						} else { // must rearrange left subtree
							if (_Pnode->Node_left->Color == Black) { // rotate red up from right sub-subtree
								_Pnode->Node_right->Color = Black;
								_Pnode->Color = Red;
								rotate_left(_Pnode);
								_Pnode = _Fixnodeparent->Node_left;
							}

							_Pnode->Color = _Fixnodeparent->Color;
							_Fixnodeparent->Color = Black;
							_Pnode->Node_left->Color = Black;
							rotate_right(_Fixnodeparent);
							break; // tree now recolored/rebalanced
						}
					}
				}

				_Fixnode->Color = Black; // stopping node is black
			}

			if (0 < inner_Size) {
				--inner_Size;
			}

			return _Erasednode;
		}

		node_pointer insert_at(const _Tree_id<node_pointer> Location, const node_pointer NewNode) noexcept {
			++inner_Size;
			const auto _Head = Node_head;
			NewNode->Node_parent = Location.Node_parent;
			if (Location.Node_parent == _Head) { // first node in tree, just set head values
				_Head->Node_left = NewNode;
				_Head->Node_parent = NewNode;
				_Head->Node_right = NewNode;
				NewNode->Color = Black; // the root is black
				return NewNode;
			}

			_STL_INTERNAL_CHECK(Location._Child != _Tree_child::_Unused);
			if (Location._Child == _Tree_child::Node_right) { // add to right of Location.Node_parent
				_STL_INTERNAL_CHECK(Location.Node_parent->Node_right->Is_nil);
				Location.Node_parent->Node_right = NewNode;
				if (Location.Node_parent == _Head->Node_right) { // remember rightmost node
					_Head->Node_right = NewNode;
				}
			} else { // add to left of Location.Node_parent
				_STL_INTERNAL_CHECK(Location.Node_parent->Node_left->Is_nil);
				Location.Node_parent->Node_left = NewNode;
				if (Location.Node_parent == _Head->Node_left) { // remember leftmost node
					_Head->Node_left = NewNode;
				}
			}

			for (node_pointer _Pnode = NewNode; _Pnode->Node_parent->Color == Red;) {
				if (_Pnode->Node_parent == _Pnode->Node_parent->Node_parent->Node_left) { // fixup red-red in left subtree
					const auto _Parent_sibling = _Pnode->Node_parent->Node_parent->Node_right;
					if (_Parent_sibling->Color == Red) { // parent's sibling has two red children, blacken both
						_Pnode->Node_parent->Color = Black;
						_Parent_sibling->Color = Black;
						_Pnode->Node_parent->Node_parent->Color = Red;
						_Pnode = _Pnode->Node_parent->Node_parent;
					} else { // parent's sibling has red and black children
						if (_Pnode == _Pnode->Node_parent->Node_right) { // rotate right child to left
							_Pnode = _Pnode->Node_parent;
							rotate_left(_Pnode);
						}

						_Pnode->Node_parent->Color = Black; // propagate red up
						_Pnode->Node_parent->Node_parent->Color = Red;
						rotate_right(_Pnode->Node_parent->Node_parent);
					}
				} else { // fixup red-red in right subtree
					const auto _Parent_sibling = _Pnode->Node_parent->Node_parent->Node_left;
					if (_Parent_sibling->Color == Red) { // parent's sibling has two red children, blacken both
						_Pnode->Node_parent->Color = Black;
						_Parent_sibling->Color = Black;
						_Pnode->Node_parent->Node_parent->Color = Red;
						_Pnode = _Pnode->Node_parent->Node_parent;
					} else { // parent's sibling has red and black children
						if (_Pnode == _Pnode->Node_parent->Node_left) { // rotate left child to right
							_Pnode = _Pnode->Node_parent;
							rotate_right(_Pnode);
						}

						_Pnode->Node_parent->Color = Black; // propagate red up
						_Pnode->Node_parent->Node_parent->Color = Red;
						rotate_left(_Pnode->Node_parent->Node_parent);
					}
				}
			}

			_Head->Node_parent->Color = Black; // root is always black
			return NewNode;
		}

		void _Orphan_ptr(const node_pointer _Ptr) noexcept {
	#if _ITERATOR_DEBUG_LEVEL == 2
			_Lockit _Lock(_LOCK_DEBUG);
			_Iterator_base12** _Pnext = &this->_Myproxy->_Myfirstiter;
			while (*_Pnext) {
				const auto _Pnextptr = static_cast<const_iterator&>(**_Pnext)._Ptr;
				if (_Pnextptr == Node_head || (_Ptr != nullptr && _Pnextptr != _Ptr)) {
					_Pnext = &(*_Pnext)->_Mynextiter;
				} else { // orphan the iterator
					(*_Pnext)->_Myproxy = nullptr;
					*_Pnext = (*_Pnext)->_Mynextiter;
				}
			}
	#else // ^^^ _ITERATOR_DEBUG_LEVEL == 2 ^^^ // vvv _ITERATOR_DEBUG_LEVEL != 2 vvv
			(void)_Ptr;
	#endif // _ITERATOR_DEBUG_LEVEL == 2
		}

		template <class _Alnode>
		void _Erase_tree_and_orphan(_Alnode& _Al, node_pointer _Rootnode) noexcept {
			while (!_Rootnode->Is_nil) { // free subtrees, then node
				_Erase_tree_and_orphan(_Al, _Rootnode->Node_right);
				auto _To_delete = _STD exchange(_Rootnode, _Rootnode->Node_left);
				_Orphan_ptr(_To_delete);
				_Alnode::value_type::_Freenode(_Al, _To_delete);
			}
		}

		template <class _Alnode>
		void _Erase_tree(_Alnode& _Al, node_pointer _Rootnode) noexcept {
			while (!_Rootnode->Is_nil) { // free subtrees, then node
				_Erase_tree(_Al, _Rootnode->Node_right);
				_Alnode::value_type::_Freenode(_Al, _STD exchange(_Rootnode, _Rootnode->Node_left));
			}
		}

		template <class _Alnode>
		void _Erase_head(_Alnode& _Al) noexcept {
			this->_Orphan_all();
			_Erase_tree(_Al, Node_head->Node_parent);
			_Alnode::value_type::_Freenode0(_Al, Node_head);
		}

		node_pointer Node_head; // pointer to head node
		size_type Inner_size; // number of elements
	};

	// STRUCT TEMPLATE _Tree_head_scoped_ptr
	template <class _Alnode, class _Scary_val>
	struct _Tree_head_scoped_ptr { // temporary storage for allocated node pointers to ensure exception safety
		_Alnode& _Al;
		_Scary_val* _Mycont;

		_Tree_head_scoped_ptr(_Alnode& _Al_, _Scary_val& _Mycont_) : _Al(_Al_), _Mycont(_STD addressof(_Mycont_)) {
			_Mycont->Node_head = _Alnode::value_type::_Buyheadnode(_Al);
		}

		void _Release() noexcept {
			_Mycont = nullptr;
		}

		~_Tree_head_scoped_ptr() {
			if (_Mycont) {
				_Mycont->_Erase_head(_Al);
			}
		}
	};

	template <class _Alnode>
	struct _Tree_temp_node_alloc : _Alloc_construct_ptr<_Alnode> {
		// EH helper for _Tree_temp_node
		explicit _Tree_temp_node_alloc(_Alnode& _Al_) : _Alloc_construct_ptr<_Alnode>(_Al_) {
			_Alloc_construct_ptr<_Alnode>::_Allocate();
		}

		_Tree_temp_node_alloc(const _Tree_temp_node_alloc&) = delete;
		_Tree_temp_node_alloc& operator=(const _Tree_temp_node_alloc&) = delete;
	};

	template <class _Alnode>
	struct _Tree_temp_node : _Tree_temp_node_alloc<_Alnode> {
		// temporarily stores a constructed tree node
		using _Alnode_traits = allocator_traits<_Alnode>;
		using node_pointer = typename _Alnode_traits::pointer;

		enum RB_colors { // colors for link to parent
			Red,
			Black
		};

		template <class... _Valtys>
		explicit _Tree_temp_node(_Alnode& _Al_, node_pointer _Head, _Valtys&&... _Vals)
			: _Tree_temp_node_alloc<_Alnode>(_Al_) {
			_Alnode_traits::construct(this->_Al, _STD addressof(this->_Ptr->Value), _STD forward<_Valtys>(_Vals)...);
			_Construct_in_place(this->_Ptr->Node_left, _Head);
			_Construct_in_place(this->_Ptr->Node_parent, _Head);
			_Construct_in_place(this->_Ptr->Node_right, _Head);
			this->_Ptr->Color = Red;
			this->_Ptr->Is_nil = false;
		}

		_Tree_temp_node(const _Tree_temp_node&) = delete;
		_Tree_temp_node& operator=(const _Tree_temp_node&) = delete;

		~_Tree_temp_node() {
			if (this->_Ptr) {
				_Destroy_in_place(this->_Ptr->Node_left);
				_Destroy_in_place(this->_Ptr->Node_parent);
				_Destroy_in_place(this->_Ptr->Node_right);
				_Alnode_traits::destroy(this->_Al, _STD addressof(this->_Ptr->Value));
			}
		}
	};

	// CLASS TEMPLATE Tree
	template <class _Traits>
	class Tree { // ordered red-black tree for map/multimap/set/multiset
	public:
		using value_type = typename _Traits::value_type;
		using allocator_type = typename _Traits::allocator_type;

	protected:
		using _Alty = _Rebind_alloc_t<allocator_type, value_type>;
		using _Alty_traits = allocator_traits<_Alty>;
		using _Node = Tree_node<value_type, typename _Alty_traits::void_pointer>;
		using _Alnode = _Rebind_alloc_t<allocator_type, _Node>;
		using _Alnode_traits = allocator_traits<_Alnode>;
		using node_pointer = typename _Alnode_traits::pointer;

		using _Scary_val = _Tree_val<conditional_t<_Is_simple_alloc_v<_Alnode>, _Tree_simple_types<value_type>,
			Tree_iterator_defines<value_type, typename _Alty_traits::size_type, typename _Alty_traits::difference_type,
			typename _Alty_traits::pointer, typename _Alty_traits::const_pointer, value_type&, const value_type&,
			node_pointer>>>;

		static constexpr bool _Multi = _Traits::_Multi;

		enum RB_colors { // colors for link to parent
			Red,
			Black
		};

	public:
		using key_type = typename _Traits::key_type;
		using value_compare = typename _Traits::value_compare;

		using key_compare = typename _Traits::key_compare;

		using size_type = typename _Alty_traits::size_type;
		using difference_type = typename _Alty_traits::difference_type;
		using pointer = typename _Alty_traits::pointer;
		using const_pointer = typename _Alty_traits::const_pointer;
		using reference = value_type&;
		using const_reference = const value_type&;

		using iterator =
			conditional_t<is_same_v<key_type, value_type>, Tree_const_iterator<_Scary_val>, Tree_iterator<_Scary_val>>;
		using const_iterator = Tree_const_iterator<_Scary_val>;
		using _Unchecked_iterator = conditional_t<is_same_v<key_type, value_type>,
			Tree_unchecked_const_iterator<_Scary_val>, Tree_unchecked_iterator<_Scary_val>>;
		using _Unchecked_const_iterator = Tree_unchecked_const_iterator<_Scary_val>;

		using reverse_iterator = _STD reverse_iterator<iterator>;
		using const_reverse_iterator = _STD reverse_iterator<const_iterator>;

		struct _Copy_tag {
			explicit _Copy_tag() = default;
		};

		struct _Move_tag {
			explicit _Move_tag() = default;
		};

		Tree(const key_compare& _Parg) : _Mypair(_One_then_variadic_args_t{}, _Parg, _Zero_then_variadic_args_t{}) {
			_Alloc_sentinel_and_proxy();
		}

		Tree(const key_compare& _Parg, const allocator_type& _Al)
			: _Mypair(_One_then_variadic_args_t{}, _Parg, _One_then_variadic_args_t{}, _Al) {
			_Alloc_sentinel_and_proxy();
		}

		template <class _Any_alloc>
		Tree(const Tree& Node_right, _Any_alloc&& _Al)
			: _Mypair(_One_then_variadic_args_t{}, Node_right.key_comp(), _One_then_variadic_args_t{},
						_STD forward<_Any_alloc>(_Al)) {
			auto&& _Alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Getal());
			const auto _Scary = _Get_scary();
			_Container_proxy_ptr<_Alty> _Proxy(_Alproxy, *_Scary);
			_Tree_head_scoped_ptr<_Alnode, _Scary_val> _Sentinel(_Getal(), *_Scary);
			_Copy(Node_right, _Copy_tag{});
			_Sentinel._Release();
			_Proxy._Release();
		}

		Tree(Tree&& Node_right)
			: _Mypair(
			_One_then_variadic_args_t{}, Node_right.key_comp(), _One_then_variadic_args_t{}, _STD move(Node_right._Getal())) {
			_Alloc_sentinel_and_proxy();
			_Swap_val(Node_right);
		}

	private:
		void _Different_allocator_move_construct(Tree&& Node_right) {
			// TRANSITION, VSO-761321 (inline into only caller when that is fixed)
			auto&& _Alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Getal());
			const auto _Scary = _Get_scary();
			_Container_proxy_ptr<_Alty> _Proxy(_Alproxy, *_Scary);
			_Tree_head_scoped_ptr<_Alnode, _Scary_val> _Sentinel(_Getal(), *_Scary);
			_Copy(Node_right, _Move_tag{});
			_Sentinel._Release();
			_Proxy._Release();
		}

	public:
		Tree(Tree&& Node_right, const allocator_type& _Al)
			: _Mypair(_One_then_variadic_args_t{}, Node_right.key_comp(), _One_then_variadic_args_t{}, _Al) {
			if _CONSTEXPR_IF(!_Alnode_traits::is_always_equal::value) {
				if (_Getal() != Node_right._Getal()) {
					_Different_allocator_move_construct(_STD move(Node_right));
					return;
				}
			}

			_Alloc_sentinel_and_proxy();
			_Swap_val(Node_right);
		}

	private:
		void _Move_assign(Tree& Node_right, _Equal_allocators) noexcept(is_nothrow_move_assignable_v<key_compare>) {
			clear();
			_Getcomp() = Node_right._Getcomp();
			_Pocma(_Getal(), Node_right._Getal());
			_Swap_val(Node_right);
		}

		void _Move_assign(Tree& Node_right, _Propagate_allocators) {
			if (_Getal() == Node_right._Getal()) {
				_Move_assign(Node_right, _Equal_allocators{});
			} else {
				clear();
				_Getcomp() = Node_right._Getcomp();
				auto&& _Alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Getal());
				auto&& _Right_alproxy = _GET_PROXY_ALLOCATOR(_Alnode, Node_right._Getal());
				_Container_proxy_ptr<_Alty> _Proxy(_Right_alproxy, _Leave_proxy_unbound{});
				const auto _Scary = _Get_scary();
				auto _Right_scary = Node_right._Get_scary();
				const auto _Newhead = _STD exchange(_Right_scary->Node_head, _Node::_Buyheadnode(Node_right._Getal()));
				const auto _Newsize = _STD exchange(_Right_scary->inner_Size, size_type{0});
				_Scary->_Erase_head(_Getal());
				_Pocma(_Getal(), Node_right._Getal());
				_Scary->Node_head = _Newhead;
				_Scary->inner_Size = _Newsize;
				_Proxy._Bind(_Alproxy, _Scary);
				_Scary->_Swap_proxy_and_iterators(*_Right_scary);
			}
		}

		void _Move_assign(Tree& Node_right, _No_propagate_allocators) {
			if (_Getal() == Node_right._Getal()) {
				_Move_assign(Node_right, _Equal_allocators{});
			} else {
				clear();
				_Getcomp() = Node_right._Getcomp();
				_Copy(Node_right, _Move_tag{});
			}
		}

	public:
		Tree& operator=(Tree&& Node_right) noexcept(noexcept(_Move_assign(Node_right, _Choose_pocma<_Alnode>{}))) {
			if (this != _STD addressof(Node_right)) {
				_Move_assign(Node_right, _Choose_pocma<_Alnode>{});
			}

			return *this;
		}

	private:
		void _Swap_val(Tree& Node_right) { // swap contents with Node_right, equal allocators
			const auto _Scary = _Get_scary();
			auto _Right_scary = Node_right._Get_scary();
			_Scary->_Swap_proxy_and_iterators(*_Right_scary);
			_Swap_adl(_Getcomp(), Node_right._Getcomp());
			_Swap_adl(_Scary->Node_head, _Right_scary->Node_head);
			_STD swap(_Scary->inner_Size, _Right_scary->inner_Size);
		}

	protected:
	#if _HAS_IF_CONSTEXPR
		template <class... _Valtys>
		pair<node_pointer, bool> _Emplace(_Valtys&&... _Vals) {
			using _In_place_key_extractor = typename _Traits::template _In_place_key_extractor<_Remove_cvref_t<_Valtys>...>;
			const auto _Scary = _Get_scary();
			_Tree_find_result<node_pointer> _Loc;
			node_pointer _Inserted;
			if constexpr (!_Multi && _In_place_key_extractor::_Extractable) {
				const auto& _Keyval = _In_place_key_extractor::erase_at(_Vals...);
				_Loc = _Find_lower_bound(_Keyval);
				if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
					return {_Loc._Bound, false};
				}

				_Check_grow_by_1();
				_Inserted = _Tree_temp_node<_Alnode>(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...)._Release();
				// nothrow hereafter
			} else {
				_Tree_temp_node<_Alnode> _Newnode(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...);
				const auto& _Keyval = _Traits::_Kfn(_Newnode._Ptr->Value);
				if constexpr (_Multi) { // duplicate check if unique
					_Loc = _Find_upper_bound(_Keyval);
				} else {
					_Loc = _Find_lower_bound(_Keyval);
					if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
						return {_Loc._Bound, false};
					}
				}

				_Check_grow_by_1();
				// nothrow hereafter
				_Inserted = _Newnode._Release();
			}

			return {_Scary->insert_at(_Loc._Location, _Inserted), true};
		}
	#else // ^^^ _HAS_IF_CONSTEXPR // !_HAS_IF_CONSTEXPR vvv

		template <class... _Valtys>
		pair<node_pointer, bool> _Emplace1(true_type, _Valtys&&... _Vals) { // _Emplace for extractable
			using _In_place_key_extractor = typename _Traits::template _In_place_key_extractor<_Remove_cvref_t<_Valtys>...>;
			const auto _Scary = _Get_scary();
			_Tree_find_result<node_pointer> _Loc;
			node_pointer _Inserted;
			const auto& _Keyval = _In_place_key_extractor::erase_at(_Vals...);
			_Loc = _Find_lower_bound(_Keyval);
			if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
				return {_Loc._Bound, false};
			}

			_Check_grow_by_1();
			_Inserted = _Tree_temp_node<_Alnode>(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...)._Release();

			// nothrow hereafter
			return {_Scary->insert_at(_Loc._Location, _Inserted), true};
		}

		template <class... _Valtys>
		pair<node_pointer, bool> _Emplace1(false_type, _Valtys&&... _Vals) { // _Emplace for unextractable
			const auto _Scary = _Get_scary();
			_Tree_find_result<node_pointer> _Loc;
			node_pointer _Inserted;
			{
				_Tree_temp_node<_Alnode> _Newnode(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...);
				const auto& _Keyval = _Traits::_Kfn(_Newnode._Ptr->Value);
				if _CONSTEXPR_IF(_Multi) { // duplicate check if unique
					_Loc = _Find_upper_bound(_Keyval);
				} else {
					_Loc = _Find_lower_bound(_Keyval);
					if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
						return {_Loc._Bound, false};
					}
				}

				_Check_grow_by_1();
				// nothrow hereafter
				_Inserted = _Newnode._Release();
			}

			return {_Scary->insert_at(_Loc._Location, _Inserted), true};
		}

		template <class... _Valtys>
		pair<node_pointer, bool> _Emplace(_Valtys&&... _Vals) {
			return _Emplace1(
				bool_constant < !_Multi
				&& _Traits::template _In_place_key_extractor<_Remove_cvref_t<_Valtys>...>::_Extractable > {},
				_STD forward<_Valtys>(_Vals)...);
		}

	#endif // _HAS_IF_CONSTEXPR

	public:
		template <class... _Valtys>
		pair<iterator, bool> emplace(_Valtys&&... _Vals) {
			const auto _Result = _Emplace(_STD forward<_Valtys>(_Vals)...);
			return {iterator(_Result.first, _Get_scary()), _Result.second};
		}

	protected:
	#if _HAS_IF_CONSTEXPR
		template <class... _Valtys>
		node_pointer _Emplace_hint(const node_pointer _Hint, _Valtys&&... _Vals) {
			using _In_place_key_extractor = typename _Traits::template _In_place_key_extractor<_Remove_cvref_t<_Valtys>...>;
			const auto _Scary = _Get_scary();
			_Tree_find_hint_result<node_pointer> _Loc;
			node_pointer _Inserted;
			if constexpr (!_Multi && _In_place_key_extractor::_Extractable) {
				_Loc = _Find_hint(_Hint, _In_place_key_extractor::erase_at(_Vals...));
				if (_Loc._Duplicate) {
					return _Loc._Location.Node_parent;
				}

				_Check_grow_by_1();
				_Inserted = _Tree_temp_node<_Alnode>(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...)._Release();
				// nothrow hereafter
			} else {
				_Tree_temp_node<_Alnode> _Newnode(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...);
				_Loc = _Find_hint(_Hint, _Traits::_Kfn(_Newnode._Ptr->Value));
				if constexpr (!_Multi) {
					if (_Loc._Duplicate) {
						return _Loc._Location.Node_parent;
					}
				}

				_Check_grow_by_1();
				// nothrow hereafter
				_Inserted = _Newnode._Release();
			}

			return _Scary->insert_at(_Loc._Location, _Inserted);
		}
	#else // ^^^ _HAS_IF_CONSTEXPR // !_HAS_IF_CONSTEXPR vvv
		template <class... _Valtys>
		node_pointer _Emplace_hint1(true_type, const node_pointer _Hint, _Valtys&&... _Vals) {
			using _In_place_key_extractor = typename _Traits::template _In_place_key_extractor<_Remove_cvref_t<_Valtys>...>;
			const auto _Scary = _Get_scary();
			const auto _Loc = _Find_hint(_Hint, _In_place_key_extractor::erase_at(_Vals...));
			if (_Loc._Duplicate) {
				return _Loc._Location.Node_parent;
			}

			_Check_grow_by_1();
			const auto _Inserted =
				_Tree_temp_node<_Alnode>(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...)._Release();
			// nothrow hereafter

			return _Scary->insert_at(_Loc._Location, _Inserted);
		}

		template <class... _Valtys>
		node_pointer _Emplace_hint1(false_type, const node_pointer _Hint, _Valtys&&... _Vals) {
			const auto _Scary = _Get_scary();
			_Tree_find_hint_result<node_pointer> _Loc;
			node_pointer _Inserted;
			{
				_Tree_temp_node<_Alnode> _Newnode(_Getal(), _Scary->Node_head, _STD forward<_Valtys>(_Vals)...);
				_Loc = _Find_hint(_Hint, _Traits::_Kfn(_Newnode._Ptr->Value));
				if (_Loc._Duplicate) {
					return _Loc._Location.Node_parent;
				}

				_Check_grow_by_1();
				// nothrow hereafter
				_Inserted = _Newnode._Release();
			}

			return _Scary->insert_at(_Loc._Location, _Inserted);
		}

		template <class... _Valtys>
		node_pointer _Emplace_hint(const node_pointer _Hint, _Valtys&&... _Vals) {
			return _Emplace_hint1(
				bool_constant < !_Multi
				&& _Traits::template _In_place_key_extractor<_Remove_cvref_t<_Valtys>...>::_Extractable > {},
				_Hint, _STD forward<_Valtys>(_Vals)...);
		}
	#endif // _HAS_IF_CONSTEXPR

	public:
		template <class... _Valtys>
		iterator emplace_hint(const_iterator _Where, _Valtys&&... _Vals) { // insert value_type(_Val...) at _Where
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Where._Getcont() == _Scary, "map/set insert iterator outside range");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
			return iterator(_Emplace_hint(_Where._Ptr, _STD forward<_Valtys>(_Vals)...), _Scary);
		}

		~Tree() noexcept {
			const auto _Scary = _Get_scary();
			_Scary->_Erase_head(_Getal());
	#if _ITERATOR_DEBUG_LEVEL != 0 // TRANSITION, ABI
			auto&& _Alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Getal());
			_Delete_plain_internal(_Alproxy, _Scary->_Myproxy);
	#endif // _ITERATOR_DEBUG_LEVEL != 0
		}

	private:
		void _Copy_assign(const Tree& Node_right, false_type) {
			clear();
			_Getcomp() = Node_right._Getcomp();
			_Pocca(_Getal(), Node_right._Getal());
			_Copy(Node_right, _Copy_tag{});
		}

		void _Copy_assign(const Tree& Node_right, true_type) {
			if (_Getal() == Node_right._Getal()) {
				_Copy_assign(Node_right, false_type{});
			} else {
				clear();
				const auto _Scary = _Get_scary();
				_Scary->_Orphan_all();
				auto& _Al = _Getal();
				auto&& _Alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Al);
				const auto& _Right_al = Node_right._Getal();
				auto&& _Right_alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Right_al);
				_Container_proxy_ptr<_Alty> _Proxy(_Right_alproxy, _Leave_proxy_unbound{});
				auto _Right_al_non_const = _Right_al;
				auto _Newhead = _Node::_Buyheadnode(_Right_al_non_const);
				_Node::_Freenode0(_Al, _Scary->Node_head);
				_Pocca(_Al, _Right_al);
				_Scary->Node_head = _Newhead;
				_Proxy._Bind(_Alproxy, _Scary);
				_Getcomp() = Node_right._Getcomp();
				_Copy(Node_right, _Copy_tag{});
			}
		}

	public:
		Tree& operator=(const Tree& Node_right) {
			if (this != _STD addressof(Node_right)) {
				_Copy_assign(Node_right, _Choose_pocca<_Alnode>{});
			}

			return *this;
		}

		[[nodiscard]] iterator begin() noexcept {
			const auto _Scary = _Get_scary();
			return iterator(_Scary->Node_head->Node_left, _Scary);
		}

		[[nodiscard]] const_iterator begin() const noexcept {
			const auto _Scary = _Get_scary();
			return const_iterator(_Scary->Node_head->Node_left, _Scary);
		}

		[[nodiscard]] iterator end() noexcept {
			const auto _Scary = _Get_scary();
			return iterator(_Scary->Node_head, _Scary);
		}

		[[nodiscard]] const_iterator end() const noexcept {
			const auto _Scary = _Get_scary();
			return const_iterator(_Scary->Node_head, _Scary);
		}

		_Unchecked_iterator _Unchecked_begin() noexcept {
			return _Unchecked_iterator(_Get_scary()->Node_head->Node_left, nullptr);
		}

		_Unchecked_const_iterator _Unchecked_begin() const noexcept {
			return _Unchecked_const_iterator(_Get_scary()->Node_head->Node_left, nullptr);
		}

		_Default_sentinel _Unchecked_end() const noexcept {
			return {};
		}

		_Unchecked_const_iterator _Unchecked_end_iter() const noexcept {
			return _Unchecked_const_iterator(_Get_scary()->Node_head, nullptr);
		}

		[[nodiscard]] reverse_iterator rbegin() noexcept {
			return reverse_iterator(end());
		}

		[[nodiscard]] const_reverse_iterator rbegin() const noexcept {
			return const_reverse_iterator(end());
		}

		[[nodiscard]] reverse_iterator rend() noexcept {
			return reverse_iterator(begin());
		}

		[[nodiscard]] const_reverse_iterator rend() const noexcept {
			return const_reverse_iterator(begin());
		}

		[[nodiscard]] const_iterator cbegin() const noexcept {
			return begin();
		}

		[[nodiscard]] const_iterator cend() const noexcept {
			return end();
		}

		[[nodiscard]] const_reverse_iterator crbegin() const noexcept {
			return rbegin();
		}

		[[nodiscard]] const_reverse_iterator crend() const noexcept {
			return rend();
		}

		[[nodiscard]] size_type size() const noexcept {
			return _Get_scary()->inner_Size;
		}

		[[nodiscard]] size_type max_size() const noexcept {
			return (_STD min)(
				static_cast<size_type>((numeric_limits<difference_type>::max)()), _Alnode_traits::max_size(_Getal()));
		}

		[[nodiscard]] bool empty() const noexcept {
			return size() == 0;
		}

		[[nodiscard]] allocator_type get_allocator() const noexcept {
			return static_cast<allocator_type>(_Getal());
		}

		[[nodiscard]] key_compare key_comp() const {
			return _Getcomp();
		}

		[[nodiscard]] value_compare value_comp() const {
			return value_compare(key_comp());
		}

		template <bool _Multi2 = _Multi, enable_if_t<!_Multi2, int> = 0>
		pair<iterator, bool> insert(const value_type& _Val) {
			const auto _Result = _Emplace(_Val);
			return {iterator(_Result.first, _Get_scary()), _Result.second};
		}

		template <bool _Multi2 = _Multi, enable_if_t<_Multi2, int> = 0>
		iterator insert(const value_type& _Val) {
			return iterator(_Emplace(_Val).first, _Get_scary());
		}

		template <bool _Multi2 = _Multi, enable_if_t<!_Multi2, int> = 0>
		pair<iterator, bool> insert(value_type&& _Val) {
			const auto _Result = _Emplace(_STD move(_Val));
			return {iterator(_Result.first, _Get_scary()), _Result.second};
		}

		template <bool _Multi2 = _Multi, enable_if_t<_Multi2, int> = 0>
		iterator insert(value_type&& _Val) {
			return iterator(_Emplace(_STD move(_Val)).first, _Get_scary());
		}

		iterator insert(const_iterator _Where, const value_type& _Val) {
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Where._Getcont() == _Scary, "map/set insert iterator outside range");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
			return iterator(_Emplace_hint(_Where._Ptr, _Val), _Scary);
		}

		iterator insert(const_iterator _Where, value_type&& _Val) {
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Where._Getcont() == _Scary, "map/set insert iterator outside range");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
			return iterator(_Emplace_hint(_Where._Ptr, _STD move(_Val)), _Scary);
		}

		template <class _Iter>
		void insert(_Iter _First, _Iter _Last) {
			_Adl_verify_range(_First, _Last);
			auto _UFirst = _Get_unwrapped(_First);
			const auto _ULast = _Get_unwrapped(_Last);
			const auto Node_head = _Get_scary()->Node_head;
			for (; _UFirst != _ULast; ++_UFirst) {
				_Emplace_hint(Node_head, *_UFirst);
			}
		}

		void insert(initializer_list<value_type> _Ilist) {
			insert(_Ilist.begin(), _Ilist.end());
		}

	private:
		node_pointer _Erase_unchecked(_Unchecked_const_iterator _Where) noexcept {
			const auto _Scary = _Get_scary();
			_Unchecked_const_iterator _Successor = _Where;
			++_Successor; // save successor iterator for return
			node_pointer _Erasednode = _Scary->erase_at(_Where); // node to erase
			_Scary->_Orphan_ptr(_Erasednode);
			_Node::_Freenode(_Getal(), _Erasednode); // delete erased node
			return _Successor._Ptr; // return successor nodeptr
		}

		node_pointer _Erase_unchecked(_Unchecked_const_iterator _First, _Unchecked_const_iterator _Last) noexcept {
			const auto _Begin = _Unchecked_begin();
			if (_First == _Begin && _Last._Ptr->Is_nil) {
				// erase all
				clear();
				return _Last._Ptr;
			}

			// partial erase, one at a time
			while (_First != _Last) {
				_Erase_unchecked(_First++);
			}

			return _Last._Ptr;
		}

	public:
		template <class _Iter = iterator, enable_if_t<!is_same_v<_Iter, const_iterator>, int> = 0>
		iterator erase(iterator _Where) noexcept /* strengthened */ {
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Where._Getcont() == _Scary, "map/set erase iterator from incorrect container");
			_STL_VERIFY(!_Where._Ptr->Is_nil, "cannot erase map/set end() iterator");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
			return iterator(_Erase_unchecked(_Where._Unwrapped()), _Scary);
		}

		iterator erase(const_iterator _Where) noexcept /* strengthened */ {
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Where._Getcont() == _Scary, "map/set erase iterator from incorrect container");
			_STL_VERIFY(!_Where._Ptr->Is_nil, "cannot erase map/set end() iterator");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
			return iterator(_Erase_unchecked(_Where._Unwrapped()), _Scary);
		}

		iterator erase(const_iterator _First, const_iterator _Last) noexcept /* strengthened */ {
			return iterator(_Erase_unchecked(_First._Unwrapped(), _Last._Unwrapped()), _Get_scary());
		}

		size_type erase(const key_type& _Keyval) noexcept(noexcept(_Eqrange(_Keyval))) /* strengthened */ {
			const auto _Where = _Eqrange(_Keyval);
			const _Unchecked_const_iterator _First(_Where.first, nullptr);
			const _Unchecked_const_iterator _Last(_Where.second, nullptr);
			const auto _Num = static_cast<size_type>(_STD distance(_First, _Last));
			_Erase_unchecked(_First, _Last);
			return _Num;
		}

		void clear() noexcept {
			const auto _Scary = _Get_scary();
			_Scary->_Orphan_ptr(nullptr);
			auto _Head = _Scary->Node_head;
			_Scary->_Erase_tree(_Getal(), _Head->Node_parent);
			_Head->Node_parent = _Head;
			_Head->Node_left = _Head;
			_Head->Node_right = _Head;
			_Scary->inner_Size = 0;
		}

	private:
		template <class _Other>
		[[nodiscard]] node_pointer _Find(const _Other& _Keyval) const {
			const _Tree_find_result<node_pointer> _Loc = _Find_lower_bound(_Keyval);
			if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
				return _Loc._Bound;
			}

			return _Get_scary()->Node_head;
		}

	public:
		[[nodiscard]] iterator find(const key_type& _Keyval) {
			return iterator(_Find(_Keyval), _Get_scary());
		}

		[[nodiscard]] const_iterator find(const key_type& _Keyval) const {
			return const_iterator(_Find(_Keyval), _Get_scary());
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] iterator find(const _Other& _Keyval) {
			return iterator(_Find(_Keyval), _Get_scary());
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] const_iterator find(const _Other& _Keyval) const {
			return const_iterator(_Find(_Keyval), _Get_scary());
		}

	#if _HAS_CXX20
		[[nodiscard]] bool contains(const key_type& _Keyval) const {
			return _Lower_bound_duplicate(_Find_lower_bound(_Keyval)._Bound, _Keyval);
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] bool contains(const _Other& _Keyval) const {
			return _Lower_bound_duplicate(_Find_lower_bound(_Keyval)._Bound, _Keyval);
		}
	#endif // _HAS_CXX20

		[[nodiscard]] size_type count(const key_type& _Keyval) const {
			if _CONSTEXPR_IF(_Multi) {
				const auto _Ans = _Eqrange(_Keyval);
				return static_cast<size_type>(_STD distance(
					_Unchecked_const_iterator(_Ans.first, nullptr), _Unchecked_const_iterator(_Ans.second, nullptr)));
			} else {
				return _Lower_bound_duplicate(_Find_lower_bound(_Keyval)._Bound, _Keyval);
			}
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] size_type count(const _Other& _Keyval) const {
			const auto _Ans = _Eqrange(_Keyval);
			return static_cast<size_type>(_STD distance(
				_Unchecked_const_iterator(_Ans.first, nullptr), _Unchecked_const_iterator(_Ans.second, nullptr)));
		}

		[[nodiscard]] iterator lower_bound(const key_type& _Keyval) {
			return iterator(_Find_lower_bound(_Keyval)._Bound, _Get_scary());
		}

		[[nodiscard]] const_iterator lower_bound(const key_type& _Keyval) const {
			return const_iterator(_Find_lower_bound(_Keyval)._Bound, _Get_scary());
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] iterator lower_bound(const _Other& _Keyval) {
			return iterator(_Find_lower_bound(_Keyval)._Bound, _Get_scary());
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] const_iterator lower_bound(const _Other& _Keyval) const {
			return const_iterator(_Find_lower_bound(_Keyval)._Bound, _Get_scary());
		}

		[[nodiscard]] iterator upper_bound(const key_type& _Keyval) {
			return iterator(_Find_upper_bound(_Keyval)._Bound, _Get_scary());
		}

		[[nodiscard]] const_iterator upper_bound(const key_type& _Keyval) const {
			return const_iterator(_Find_upper_bound(_Keyval)._Bound, _Get_scary());
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] iterator upper_bound(const _Other& _Keyval) {
			return iterator(_Find_upper_bound(_Keyval)._Bound, _Get_scary());
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] const_iterator upper_bound(const _Other& _Keyval) const {
			return const_iterator(_Find_upper_bound(_Keyval)._Bound, _Get_scary());
		}

		[[nodiscard]] pair<iterator, iterator> equal_range(const key_type& _Keyval) {
			const auto _Result = _Eqrange(_Keyval);
			const auto _Scary = _Get_scary();
			return {iterator(_Result.first, _Scary), iterator(_Result.second, _Scary)};
		}

		[[nodiscard]] pair<const_iterator, const_iterator> equal_range(const key_type& _Keyval) const {
			const auto _Result = _Eqrange(_Keyval);
			const auto _Scary = _Get_scary();
			return {const_iterator(_Result.first, _Scary), const_iterator(_Result.second, _Scary)};
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] pair<iterator, iterator> equal_range(const _Other& _Keyval) {
			const auto _Result = _Eqrange(_Keyval);
			const auto _Scary = _Get_scary();
			return {iterator(_Result.first, _Scary), iterator(_Result.second, _Scary)};
		}

		template <class _Other, class _Mycomp = key_compare, class = typename _Mycomp::is_transparent>
		[[nodiscard]] pair<const_iterator, const_iterator> equal_range(const _Other& _Keyval) const {
			const auto _Result = _Eqrange(_Keyval);
			const auto _Scary = _Get_scary();
			return {const_iterator(_Result.first, _Scary), const_iterator(_Result.second, _Scary)};
		}

		void swap(Tree& Node_right) noexcept(_Is_nothrow_swappable<key_compare>::value) /* strengthened */ {
			if (this != _STD addressof(Node_right)) {
				_Pocs(_Getal(), Node_right._Getal());
				_Swap_val(Node_right);
			}
		}

	protected:
		template <class _Keyty>
		_Tree_find_hint_result<node_pointer> _Find_hint(const node_pointer _Hint, const _Keyty& _Keyval) const {
			const auto& _Comp = _Getcomp();
			const auto _Head = _Get_scary()->Node_head;
			if _CONSTEXPR_IF(_Multi) { // insert even if duplicate
				if (_Hint->Is_nil) {
					// insert at end if greater than or equal to last element
					if (_Head->Node_parent->Is_nil || !_DEBUG_LT_PRED(_Comp, _Keyval, _Traits::_Kfn(_Head->Node_right->Value))) {
						return {{_Head->Node_right, _Tree_child::Node_right}, false};
					}

					// _Hint is end(); it must be closer to the end of equivalents
					return {_Find_upper_bound(_Keyval)._Location, false};
				}

				if (_Hint == _Head->Node_left) {
					// insert at beginning if less than or equal to first element
					if (!_DEBUG_LT_PRED(_Comp, _Traits::_Kfn(_Hint->Value), _Keyval)) {
						return {{_Hint, _Tree_child::Node_left}, false};
					}

					// _Hint is begin(); it must be closer to the beginning of equivalents
					return {_Find_lower_bound(_Keyval)._Location, false};
				}

				if (!_DEBUG_LT_PRED(_Comp, _Traits::_Kfn(_Hint->Value), _Keyval)) {
					// _Val <= *_Hint
					const auto _Prev = (--(_Unchecked_const_iterator(_Hint, nullptr)))._Ptr;
					if (!_DEBUG_LT_PRED(_Comp, _Keyval, _Traits::_Kfn(_Prev->Value))) {
						// _Val <= *_Hint and _Val >= *prev(_Hint); insert here
						if (_Prev->Node_right->Is_nil) {
							return {{_Prev, _Tree_child::Node_right}, false};
						} else {
							return {{_Hint, _Tree_child::Node_left}, false};
						}
					}

					// _Val goes before *_Hint; _Hint must be closer to the end of equivalents
					return {_Find_upper_bound(_Keyval)._Location, false};
				}

				// _Val goes after *_Hint; _Hint must be closer to the beginning of equivalents
				return {_Find_lower_bound(_Keyval)._Location, false};
			} else { // insert only if unique
				if (_Hint->Is_nil) { // insert at end if after last element
					// insert at end if greater than last element
					if (_Head->Node_parent->Is_nil || _DEBUG_LT_PRED(_Comp, _Traits::_Kfn(_Head->Node_right->Value), _Keyval)) {
						return {{_Head->Node_right, _Tree_child::Node_right}, false};
					}
				} else if (_Hint == _Head->Node_left) {
					// insert at beginning if less than first element
					if (_DEBUG_LT_PRED(_Comp, _Keyval, _Traits::_Kfn(_Hint->Value))) {
						return {{_Hint, _Tree_child::Node_left}, false};
					}
				} else if (_DEBUG_LT_PRED(_Comp, _Keyval, _Traits::_Kfn(_Hint->Value))) {
					// _Val < *_Hint
					const auto _Prev = (--(_Unchecked_const_iterator(_Hint, nullptr)))._Ptr;
					if (_DEBUG_LT_PRED(_Comp, _Traits::_Kfn(_Prev->Value), _Keyval)) {
						// _Val < *_Hint and _Val > *prev(_Hint); insert here
						if (_Prev->Node_right->Is_nil) {
							return {{_Prev, _Tree_child::Node_right}, false};
						} else {
							return {{_Hint, _Tree_child::Node_left}, false};
						}
					}
				} else if (_DEBUG_LT_PRED(_Comp, _Traits::_Kfn(_Hint->Value), _Keyval)) {
					// _Val > *_Hint
					const auto _Next = (++(_Unchecked_const_iterator(_Hint, nullptr)))._Ptr;
					if (_Next->Is_nil || _DEBUG_LT_PRED(_Comp, _Keyval, _Traits::_Kfn(_Next->Value))) {
						// _Val > *_Hint and _Val < *next(_Hint); insert here
						if (_Hint->Node_right->Is_nil) {
							return {{_Hint, _Tree_child::Node_right}, false};
						}

						return {{_Next, _Tree_child::Node_left}, false};
					}
				} else {
					// _Val is equivalent to *_Hint; don't insert
					return {{_Hint, _Tree_child::Node_right}, true};
				}

				const auto _Loc = _Find_lower_bound(_Keyval);
				if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
					return {{_Loc._Bound, _Tree_child::_Unused}, true};
				}

				return {_Loc._Location, false};
			}
		}

		template <class _Keyty>
		_Tree_find_result<node_pointer> _Find_upper_bound(const _Keyty& _Keyval) const {
			const auto _Scary = _Get_scary();
			_Tree_find_result<node_pointer> _Result{{_Scary->Node_head->Node_parent, _Tree_child::Node_right}, _Scary->Node_head};
			node_pointer _Trynode = _Result._Location.Node_parent;
			while (!_Trynode->Is_nil) {
				_Result._Location.Node_parent = _Trynode;
				if (_DEBUG_LT_PRED(_Getcomp(), _Keyval, _Traits::_Kfn(_Trynode->Value))) {
					_Result._Location._Child = _Tree_child::Node_left;
					_Result._Bound = _Trynode;
					_Trynode = _Trynode->Node_left;
				} else {
					_Result._Location._Child = _Tree_child::Node_right;
					_Trynode = _Trynode->Node_right;
				}
			}

			return _Result;
		}

		template <class _Keyty>
		bool _Lower_bound_duplicate(const node_pointer _Bound, const _Keyty& _Keyval) const {
			return !_Bound->Is_nil && !_DEBUG_LT_PRED(_Getcomp(), _Keyval, _Traits::_Kfn(_Bound->Value));
		}

		template <class _Keyty>
		_Tree_find_result<node_pointer> _Find_lower_bound(const _Keyty& _Keyval) const {
			const auto _Scary = _Get_scary();
			_Tree_find_result<node_pointer> _Result{{_Scary->Node_head->Node_parent, _Tree_child::Node_right}, _Scary->Node_head};
			node_pointer _Trynode = _Result._Location.Node_parent;
			while (!_Trynode->Is_nil) {
				_Result._Location.Node_parent = _Trynode;
				if (_DEBUG_LT_PRED(_Getcomp(), _Traits::_Kfn(_Trynode->Value), _Keyval)) {
					_Result._Location._Child = _Tree_child::Node_right;
					_Trynode = _Trynode->Node_right;
				} else {
					_Result._Location._Child = _Tree_child::Node_left;
					_Result._Bound = _Trynode;
					_Trynode = _Trynode->Node_left;
				}
			}

			return _Result;
		}

		void _Check_grow_by_1() {
			if (max_size() == _Get_scary()->inner_Size) {
				_Throw_tree_length_error();
			}
		}

		template <class _Moveit>
		void _Copy(const Tree& Node_right, _Moveit _Movefl) { // copy or move entire tree from Node_right
			const auto _Scary = _Get_scary();
			const auto _Right_scary = Node_right._Get_scary();
			_Scary->Node_head->Node_parent = _Copy_nodes(_Right_scary->Node_head->Node_parent, _Scary->Node_head, _Movefl);
			_Scary->inner_Size = _Right_scary->inner_Size;
			if (!_Scary->Node_head->Node_parent->Is_nil) { // nonempty tree, look for new smallest and largest
				_Scary->Node_head->Node_left = _Scary_val::find_leftest(_Scary->Node_head->Node_parent);
				_Scary->Node_head->Node_right = _Scary_val::find_rightest(_Scary->Node_head->Node_parent);
			} else { // empty tree, just tidy head pointers
				_Scary->Node_head->Node_left = _Scary->Node_head;
				_Scary->Node_head->Node_right = _Scary->Node_head;
			}
		}

		template <class _Ty, class _Is_set>
		node_pointer _Copy_or_move(_Ty& _Val, _Copy_tag, _Is_set) { // copy to new node
			return _Buynode(_Val);
		}

		template <class _Ty>
		node_pointer _Copy_or_move(_Ty& _Val, _Move_tag, true_type) { // move to new node -- set
			return _Buynode(_STD move(_Val));
		}

		template <class _Ty>
		node_pointer _Copy_or_move(_Ty& _Val, _Move_tag, false_type) { // move to new node -- map
			return _Buynode(_STD move(const_cast<key_type&>(_Val.first)), _STD move(_Val.second));
		}

		template <class _Moveit>
		node_pointer _Copy_nodes(node_pointer _Rootnode, node_pointer _Wherenode, _Moveit _Movefl) {
			// copy entire subtree, recursively
			const auto _Scary = _Get_scary();
			node_pointer _Newroot = _Scary->Node_head; // point at nil node

			if (!_Rootnode->Is_nil) { // copy or move a node, then any subtrees
				typename is_same<key_type, value_type>::type _Is_set;
				node_pointer _Pnode = _Copy_or_move(_Rootnode->Value, _Movefl, _Is_set);
				_Pnode->Node_parent = _Wherenode;
				_Pnode->Color = _Rootnode->Color;
				if (_Newroot->Is_nil) {
					_Newroot = _Pnode; // memorize new root
				}

				_TRY_BEGIN
					_Pnode->Node_left = _Copy_nodes(_Rootnode->Node_left, _Pnode, _Movefl);
				_Pnode->Node_right = _Copy_nodes(_Rootnode->Node_right, _Pnode, _Movefl);
				_CATCH_ALL
					_Scary->_Erase_tree_and_orphan(_Getal(), _Newroot); // subtree copy failed, bail out
				_RERAISE;
				_CATCH_END
			}

			return _Newroot; // return newly constructed tree
		}

		template <class _Other>
		pair<node_pointer, node_pointer> _Eqrange(const _Other& _Keyval) const
			noexcept(_Nothrow_compare<key_compare, key_type, _Other>&& _Nothrow_compare<key_compare, _Other, key_type>) {
			// find range of nodes equivalent to _Keyval
			const auto _Scary = _Get_scary();
			const auto& _Comp = _Getcomp();
			node_pointer _Pnode = _Scary->Node_head->Node_parent;
			node_pointer _Lonode = _Scary->Node_head; // end() if search fails
			node_pointer _Hinode = _Scary->Node_head; // end() if search fails

			while (!_Pnode->Is_nil) {
				const auto& _Nodekey = _Traits::_Kfn(_Pnode->Value);
				if (_DEBUG_LT_PRED(_Comp, _Nodekey, _Keyval)) {
					_Pnode = _Pnode->Node_right; // descend right subtree
				} else { // _Pnode not less than _Keyval, remember it
					if (_Hinode->Is_nil && _DEBUG_LT_PRED(_Comp, _Keyval, _Nodekey)) {
						_Hinode = _Pnode; // _Pnode greater, remember it
					}

					_Lonode = _Pnode;
					_Pnode = _Pnode->Node_left; // descend left subtree
				}
			}

			_Pnode = _Hinode->Is_nil ? _Scary->Node_head->Node_parent : _Hinode->Node_left; // continue scan for upper bound
			while (!_Pnode->Is_nil) {
				if (_DEBUG_LT_PRED(_Getcomp(), _Keyval, _Traits::_Kfn(_Pnode->Value))) {
					// _Pnode greater than _Keyval, remember it
					_Hinode = _Pnode;
					_Pnode = _Pnode->Node_left; // descend left subtree
				} else {
					_Pnode = _Pnode->Node_right; // descend right subtree
				}
			}

			return {_Lonode, _Hinode};
		}

	#if _HAS_CXX17
	public:
		using node_type = typename _Traits::node_type;

		node_type extract(const const_iterator _Where) {
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Where._Getcont() == _Scary && !_Where._Ptr->Is_nil, "map/set erase iterator outside range");
	#endif // _ITERATOR_DEBUG_LEVEL == 2

			const auto _Ptr = _Scary->erase_at(_Where._Unwrapped());
			_Scary->_Orphan_ptr(_Ptr);
			return node_type::_Make(_Ptr, _Getal());
		}

		node_type extract(const key_type& _Keyval) {
			const const_iterator _Where = find(_Keyval);
			if (_Where == end()) {
				return node_type{};
			}

			return extract(_Where);
		}

		auto insert(node_type&& _Handle) {
			if (_Handle.empty()) {
				if constexpr (_Multi) {
					return end();
				} else {
					return _Insert_return_type<iterator, node_type>{end(), false, {}};
				}
			}

			_Check_node_allocator(_Handle);
			const auto _Scary = _Get_scary();
			const auto _Attempt_node = _Handle._Getptr();
			const auto& _Keyval = _Traits::_Kfn(_Attempt_node->Value);
			_Tree_find_result<node_pointer> _Loc;
			if constexpr (_Multi) {
				_Loc = _Find_upper_bound(_Keyval);
			} else {
				_Loc = _Find_lower_bound(_Keyval);
				if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
					return _Insert_return_type<iterator, node_type>{
						iterator(_Loc._Bound, _Scary), false, _STD move(_Handle)};
				}
			}

			_Check_grow_by_1();

			// nothrow hereafter

			_Attempt_node->Node_left = _Scary->Node_head;
			// _Attempt_node->Node_parent handled in insert_at
			_Attempt_node->Node_right = _Scary->Node_head;
			_Attempt_node->Color = Red;

			const auto _Inserted = _Scary->insert_at(_Loc._Location, _Handle._Release());
			if constexpr (_Multi) {
				return iterator(_Inserted, _Scary);
			} else {
				return _Insert_return_type<iterator, node_type>{iterator(_Inserted, _Scary), true, _STD move(_Handle)};
			}
		}

		iterator insert(const const_iterator _Hint, node_type&& _Handle) {
			const auto _Scary = _Get_scary();
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(_Hint._Getcont() == _Scary, "map/set insert iterator outside range");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
			if (_Handle.empty()) {
				return end();
			}

			_Check_node_allocator(_Handle);
			const auto _Attempt_node = _Handle._Getptr();
			const auto& _Keyval = _Traits::_Kfn(_Attempt_node->Value);
			const auto _Loc = _Find_hint(_Hint._Ptr, _Keyval);
			if (_Loc._Duplicate) {
				return iterator(_Loc._Location.Node_parent, _Scary);
			}

			_Check_grow_by_1();

			_Attempt_node->Node_left = _Scary->Node_head;
			// _Attempt_node->Node_parent handled in insert_at
			_Attempt_node->Node_right = _Scary->Node_head;
			_Attempt_node->Color = Red;

			return iterator(_Scary->insert_at(_Loc._Location, _Handle._Release()), _Scary);
		}

		template <class>
		friend class Tree;

		template <class _Other_traits>
		void merge(Tree<_Other_traits>& _That) {
			static_assert(is_same_v<node_pointer, typename Tree<_Other_traits>::node_pointer>,
							"merge() requires an argument with a compatible node type.");

			static_assert(is_same_v<allocator_type, typename Tree<_Other_traits>::allocator_type>,
							"merge() requires an argument with the same allocator type.");

			if constexpr (is_same_v<Tree, Tree<_Other_traits>>) {
				if (this == _STD addressof(_That)) {
					return;
				}
			}

	#if _ITERATOR_DEBUG_LEVEL == 2
			if constexpr (!_Alnode_traits::is_always_equal::value) {
				_STL_VERIFY(_Getal() == _That._Getal(), "allocator incompatible for merge");
			}
	#endif // _ITERATOR_DEBUG_LEVEL == 2

			const auto _Scary = _Get_scary();
			const auto _Head = _Scary->Node_head;
			const auto _That_scary = _That._Get_scary();
			auto _First = _That._Unchecked_begin();
			while (!_First._Ptr->Is_nil) {
				const auto _Attempt_node = _First._Ptr;
				++_First;
				_Tree_find_result<node_pointer> _Loc;
				const auto& _Keyval = _Traits::_Kfn(_Attempt_node->Value);
				if constexpr (_Multi) {
					_Loc = _Find_upper_bound(_Keyval);
				} else {
					_Loc = _Find_lower_bound(_Keyval);
					if (_Lower_bound_duplicate(_Loc._Bound, _Keyval)) {
						continue;
					}
				}

				_Check_grow_by_1();

				// nothrow hereafter for this iteration
				const auto _Extracted = _That_scary->erase_at(_Unchecked_const_iterator(_Attempt_node, nullptr));
				_Extracted->Node_left = _Head;
				// _Extracted->Node_parent handled in insert_at
				_Extracted->Node_right = _Head;
				_Extracted->Color = Red;

				const auto _Inserted = _Scary->insert_at(_Loc._Location, _Extracted);
				_Reparent_ptr(_Inserted, _That);
			}
		}

		template <class _Other_traits>
		void merge(Tree<_Other_traits>&& _That) {
			static_assert(is_same_v<node_pointer, typename Tree<_Other_traits>::node_pointer>,
							"merge() requires an argument with a compatible node type.");

			static_assert(is_same_v<allocator_type, typename Tree<_Other_traits>::allocator_type>,
							"merge() requires an argument with the same allocator type.");

			merge(_That);
		}

	protected:
		template <class _Other_traits>
		void _Reparent_ptr(const node_pointer _Ptr, Tree<_Other_traits>& _Old_parent) {
			(void)_Ptr;
			(void)_Old_parent;
	#if _ITERATOR_DEBUG_LEVEL == 2
			_Lockit _Lock(_LOCK_DEBUG);
			const auto _Old_parent_scary = _Old_parent._Get_scary();
			_Iterator_base12** _Pnext = &_Old_parent_scary->_Myproxy->_Myfirstiter;
			_STL_VERIFY(_Pnext, "source container corrupted");
			if (_Ptr == nullptr || _Ptr == _Old_parent_scary->Node_head) {
				return;
			}

			const auto _My_saved_proxy = _Get_scary()->_Myproxy;
			_Iterator_base12** const _My_saved_first = &_My_saved_proxy->_Myfirstiter;

			while (*_Pnext) {
				_Iterator_base12** const _Next = &(*_Pnext)->_Mynextiter;
				const auto _Iter = static_cast<const_iterator*>(*_Pnext);
				if (_Iter->_Ptr == _Ptr) { // reparent the iterator
					*_Pnext = *_Next;
					_Iter->_Myproxy = _My_saved_proxy;
					_Iter->_Mynextiter = *_My_saved_first;
					*_My_saved_first = _Iter;
				} else { // skip the iterator
					_Pnext = _Next;
				}
			}
	#endif // _ITERATOR_DEBUG_LEVEL == 2
		}

		void _Check_node_allocator(node_type& _Handle) const {
			(void)_Handle;
	#if _ITERATOR_DEBUG_LEVEL == 2
			_STL_VERIFY(get_allocator() == _Handle._Getal(), "node handle allocator incompatible for insert");
	#endif // _ITERATOR_DEBUG_LEVEL == 2
		}
	#endif // _HAS_CXX17

		void _Alloc_sentinel_and_proxy() {
			const auto _Scary = _Get_scary();
			auto&& _Alproxy = _GET_PROXY_ALLOCATOR(_Alnode, _Getal());
			_Container_proxy_ptr<_Alnode> _Proxy(_Alproxy, *_Scary);
			_Scary->Node_head = _Node::_Buyheadnode(_Getal());
			_Proxy._Release();
		}

		template <class... _Valty>
		node_pointer _Buynode(_Valty&&... _Val) {
			return _Node::_Buynode(_Getal(), _Get_scary()->Node_head, _STD forward<_Valty>(_Val)...);
		}

		key_compare& _Getcomp() noexcept {
			return _Mypair._Get_first();
		}

		const key_compare& _Getcomp() const noexcept {
			return _Mypair._Get_first();
		}

		_Alnode& _Getal() noexcept {
			return _Mypair._Myval2._Get_first();
		}

		const _Alnode& _Getal() const noexcept {
			return _Mypair._Myval2._Get_first();
		}

		_Scary_val* _Get_scary() noexcept {
			return _STD addressof(_Mypair._Myval2._Myval2);
		}

		const _Scary_val* _Get_scary() const noexcept {
			return _STD addressof(_Mypair._Myval2._Myval2);
		}

	private:
		_Compressed_pair<key_compare, _Compressed_pair<_Alnode, _Scary_val>> _Mypair;
	};

	template <class _Traits>
	[[nodiscard]] bool operator==(const Tree<_Traits>& Node_left, const Tree<_Traits>& Node_right) {
		return Node_left.size() == Node_right.size()
			&& _STD equal(Node_left._Unchecked_begin(), Node_left._Unchecked_end_iter(), Node_right._Unchecked_begin());
	}

	template <class _Traits>
	[[nodiscard]] bool operator!=(const Tree<_Traits>& Node_left, const Tree<_Traits>& Node_right) {
		return !(Node_left == Node_right);
	}

	template <class _Traits>
	[[nodiscard]] bool operator<(const Tree<_Traits>& Node_left, const Tree<_Traits>& Node_right) {
		return _STD lexicographical_compare(
			Node_left._Unchecked_begin(), Node_left._Unchecked_end_iter(), Node_right._Unchecked_begin(), Node_right._Unchecked_end_iter());
	}

	template <class _Traits>
	[[nodiscard]] bool operator>(const Tree<_Traits>& Node_left, const Tree<_Traits>& Node_right) {
		return Node_right < Node_left;
	}

	template <class _Traits>
	[[nodiscard]] bool operator<=(const Tree<_Traits>& Node_left, const Tree<_Traits>& Node_right) {
		return !(Node_right < Node_left);
	}

	template <class _Traits>
	[[nodiscard]] bool operator>=(const Tree<_Traits>& Node_left, const Tree<_Traits>& Node_right) {
		return !(Node_left < Node_right);
	}
}

#pragma pop_macro("new")
_STL_RESTORE_CLANG_WARNINGS
#pragma warning(pop)
#pragma pack(pop)
#endif // _STL_COMPILER_PREPROCESSOR
#endif // _XTREE_
